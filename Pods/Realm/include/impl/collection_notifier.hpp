////////////////////////////////////////////////////////////////////////////
//
// Copyright 2016 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#ifndef REALM_BACKGROUND_COLLECTION_HPP
#define REALM_BACKGROUND_COLLECTION_HPP

#include "impl/collection_change_builder.hpp"

#include <realm/version_id.hpp>

#include <array>
#include <atomic>
#include <exception>
#include <functional>
#include <mutex>
#include <unordered_map>

namespace realm {
class Realm;
class SharedGroup;
class Table;

namespace _impl {
class RealmCoordinator;

struct ListChangeInfo {
    size_t table_ndx;
    size_t row_ndx;
    size_t col_ndx;
    CollectionChangeBuilder* changes;
};

struct TransactionChangeInfo {
    std::vector<bool> table_modifications_needed;
    std::vector<bool> table_moves_needed;
    std::vector<ListChangeInfo> lists;
    std::vector<CollectionChangeBuilder> tables;
    std::vector<std::vector<size_t>> column_indices;
    std::vector<size_t> table_indices;
    bool track_all;
};

class DeepChangeChecker {
public:
    struct OutgoingLink {
        size_t col_ndx;
        bool is_list;
    };
    struct RelatedTable {
        size_t table_ndx;
        std::vector<OutgoingLink> links;
    };

    DeepChangeChecker(TransactionChangeInfo const& info, Table const& root_table,
                      std::vector<RelatedTable> const& related_tables);

    bool operator()(size_t row_ndx);

    // Recursively add `table` and all tables it links to to `out`, along with
    // information about the links from them
    static void find_related_tables(std::vector<RelatedTable>& out, Table const& table);

private:
    TransactionChangeInfo const& m_info;
    Table const& m_root_table;
    const size_t m_root_table_ndx;
    IndexSet const* const m_root_modifications;
    std::vector<IndexSet> m_not_modified;
    std::vector<RelatedTable> const& m_related_tables;

    struct Path {
        size_t table;
        size_t row;
        size_t col;
        bool depth_exceeded;
    };
    std::array<Path, 16> m_current_path;

    bool check_row(Table const& table, size_t row_ndx, size_t depth = 0);
    bool check_outgoing_links(size_t table_ndx, Table const& table,
                              size_t row_ndx, size_t depth = 0);
};

// A base class for a notifier that keeps a collection up to date and/or
// generates detailed change notifications on a background thread. This manages
// most of the lifetime-management issues related to sharing an object between
// the worker thread and the collection on the target thread, along with the
// thread-safe callback collection.
class CollectionNotifier {
public:
    CollectionNotifier(std::shared_ptr<Realm>);
    virtual ~CollectionNotifier();

    // ------------------------------------------------------------------------
    // Public API for the collections using this to get notifications:

    // Stop receiving notifications from this background worker
    // This must be called in the destructor of the collection
    void unregister() noexcept;

    // Add a callback to be called each time the collection changes
    // This can only be called from the target collection's thread
    // Returns a token which can be passed to remove_callback()
    size_t add_callback(CollectionChangeCallback callback);
    // Remove a previously added token. The token is no longer valid after
    // calling this function and must not be used again. This function can be
    // called from any thread.
    void remove_callback(size_t token);

    void suppress_next_notification(size_t token);

    // ------------------------------------------------------------------------
    // API for RealmCoordinator to manage running things and calling callbacks

    bool is_for_realm(Realm&) const noexcept;
    Realm* get_realm() const noexcept { return m_realm.get(); }

    // Get the SharedGroup version which this collection can attach to (if it's
    // in handover mode), or can deliver to (if it's been handed over to the BG worker alredad)
    // precondition: RealmCoordinator::m_notifier_mutex is locked
    VersionID version() const noexcept { return m_sg_version; }

    // Release references to all core types
    // This is called on the worker thread to ensure that non-thread-safe things
    // can be destroyed on the correct thread, even if the last reference to the
    // CollectionNotifier is released on a different thread
    virtual void release_data() noexcept = 0;

    // Prepare to deliver the new collection and call callbacks.
    // Returns whether or not it has anything to deliver.
    // precondition: RealmCoordinator::m_notifier_mutex is locked
    bool package_for_delivery();

    // Deliver the new state to the target collection using the given SharedGroup
    // precondition: RealmCoordinator::m_notifier_mutex is unlocked
    virtual void deliver(SharedGroup&) { }

    // Pass the given error to all registered callbacks, then remove them
    // precondition: RealmCoordinator::m_notifier_mutex is unlocked
    void deliver_error(std::exception_ptr);

    // Call each of the given callbacks with the changesets prepared by package_for_delivery()
    // precondition: RealmCoordinator::m_notifier_mutex is unlocked
    void before_advance();
    void after_advance();

    bool is_alive() const noexcept;

    // precondition: RealmCoordinator::m_notifier_mutex is locked *or* is called on worker thread
    bool has_run() const noexcept { return m_has_run; }

    // Attach the handed-over query to `sg`. Must not be already attached to a SharedGroup.
    // precondition: RealmCoordinator::m_notifier_mutex is locked
    void attach_to(SharedGroup& sg);
    // Create a new query handover object and stop using the previously attached
    // SharedGroup
    // precondition: RealmCoordinator::m_notifier_mutex is locked
    void detach();

    // Set `info` as the new ChangeInfo that will be populated by the next
    // transaction advance, and register all required information in it
    // precondition: RealmCoordinator::m_notifier_mutex is locked
    void add_required_change_info(TransactionChangeInfo& info);

    // precondition: RealmCoordinator::m_notifier_mutex is unlocked
    virtual void run() = 0;

    // precondition: RealmCoordinator::m_notifier_mutex is locked
    void prepare_handover();

    template <typename T>
    class Handle;

    bool have_callbacks() const noexcept { return m_have_callbacks; }
protected:
    void add_changes(CollectionChangeBuilder change);
    void set_table(Table const& table);
    std::unique_lock<std::mutex> lock_target();

    std::function<bool (size_t)> get_modification_checker(TransactionChangeInfo const&, Table const&);

private:
    virtual void do_attach_to(SharedGroup&) = 0;
    virtual void do_detach_from(SharedGroup&) = 0;
    virtual void do_prepare_handover(SharedGroup&) = 0;
    virtual bool do_add_required_change_info(TransactionChangeInfo&) = 0;
    virtual bool prepare_to_deliver() { return true; }

    mutable std::mutex m_realm_mutex;
    std::shared_ptr<Realm> m_realm;

    VersionID m_sg_version;
    SharedGroup* m_sg = nullptr;

    bool m_has_run = false;
    bool m_error = false;
    std::vector<DeepChangeChecker::RelatedTable> m_related_tables;

    struct Callback {
        CollectionChangeCallback fn;
        CollectionChangeBuilder accumulated_changes;
        CollectionChangeSet changes_to_deliver;
        size_t token;
        bool initial_delivered;
        bool skip_next;
    };

    // Currently registered callbacks and a mutex which must always be held
    // while doing anything with them or m_callback_index
    std::mutex m_callback_mutex;
    std::vector<Callback> m_callbacks;

    // Cached value for if m_callbacks is empty, needed to avoid deadlocks in
    // run() due to lock-order inversion between m_callback_mutex and m_target_mutex
    // It's okay if this value is stale as at worst it'll result in us doing
    // some extra work.
    std::atomic<bool> m_have_callbacks = {false};

    // Iteration variable for looping over callbacks
    // remove_callback() updates this when needed
    size_t m_callback_index = -1;

    template<typename Fn>
    void for_each_callback(Fn&& fn);

    std::vector<Callback>::iterator find_callback(size_t token);
};

// A smart pointer to a CollectionNotifier that unregisters the notifier when
// the pointer is destroyed. Movable. Copying will produce a null Handle.
template <typename T>
class CollectionNotifier::Handle : public std::shared_ptr<T> {
public:
    using std::shared_ptr<T>::shared_ptr;

    Handle() = default;
    ~Handle() { reset(); }

    // Copying a Handle produces a null Handle.
    Handle(const Handle&) : Handle() { }
    Handle& operator=(const Handle& other)
    {
        if (this != &other) {
            reset();
        }
        return *this;
    }

    Handle(Handle&&) = default;
    Handle& operator=(Handle&& other)
    {
        reset();
        std::shared_ptr<T>::shared_ptr::operator=(std::move(other));
        return *this;
    }

    void reset()
    {
        if (*this) {
            this->get()->unregister();
            std::shared_ptr<T>::reset();
        }
    }
};

// A package of CollectionNotifiers for a single Realm instance which is passed
// around to the various places which need to actually trigger the notifications
class NotifierPackage {
public:
    NotifierPackage() = default;
    NotifierPackage(std::exception_ptr error,
                    std::vector<std::shared_ptr<CollectionNotifier>> notifiers,
                    RealmCoordinator* coordinator);

    explicit operator bool() { return !m_notifiers.empty(); }

    // Get the version which this package can deliver into, or VersionID{} if
    // it has not yet been packaged
    util::Optional<VersionID> version() { return m_version; }

    // Package the notifiers for delivery, blocking if they aren't ready for
    // the given version.
    // No-op if called multiple times
    void package_and_wait(util::Optional<VersionID::version_type> target_version);

    // Send the before-change notifications
    void before_advance();
    // Deliver the payload associated with the contained notifiers and/or the error
    void deliver(SharedGroup& sg);
    // Send the after-change notifications
    void after_advance();

    void add_notifier(std::shared_ptr<CollectionNotifier> notifier);

private:
    util::Optional<VersionID> m_version;
    std::vector<std::shared_ptr<CollectionNotifier>> m_notifiers;

    RealmCoordinator* m_coordinator = nullptr;
    std::exception_ptr m_error;
};

} // namespace _impl
} // namespace realm

#endif /* REALM_BACKGROUND_COLLECTION_HPP */
