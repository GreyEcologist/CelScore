//
//  ListViewModelTests.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 4/14/16.
//  Copyright © 2016 Gareth.K.Mensah. All rights reserved.
//

import XCTest
import RealmSwift
import ReactiveCocoa
import ReactiveSwift

@testable import CelebrityScore

class ListViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        
        let realm = try! Realm()
        realm.beginWrite()
        let celebId1 = CelebId()
        celebId1.id = "0001"
        let celebId2 = CelebId()
        celebId2.id = "0002"
        let celebId3 = CelebId()
        celebId3.id = "0003"
        let list = ListsModel()
        list.id = "0001"
        list.celebList.append(celebId1)
        list.celebList.append(celebId2)
        list.celebList.append(celebId3)
        realm.add(list, update: true)
        
        let celebrity1 = CelebrityModel()
        celebrity1.id = "0001"
        celebrity1.nickName = "testUser"
        let celebrity2 = CelebrityModel()
        celebrity2.id = "0002"
        celebrity2.nickName = "secretUser"
        celebrity2.isFollowed = true
        realm.add(celebrity1, update: true)
        realm.add(celebrity2, update: true)
        try! realm.commitWrite()
    }
    
    func testGetListSignal() {
        let expectation = self.expectation(description: "getListSignal callback")
        ListViewModel().getListSignal(listId: "0001")
            .flatMapError { _ in SignalProducer.empty }
            .startWithValues { list in
            XCTAssertEqual(list.celebList.count, 3, "getListSignal returns list with two items."); expectation.fulfill() }
        waitForExpectations(timeout: 1) { error in if let error = error { XCTFail("getListSignal error: \(error)") } }
    }
    
    func testSanitizeListsSignal() {
        let realm = try! Realm()
        let initialList = realm.objects(ListsModel.self).filter("id = %@", "0001").first
        XCTAssertEqual(initialList?.celebList.count, 3, "sanitizeListsSignal: ListViewModel starts with 3 CelebIds.")
        
        let expectation = self.expectation(description: "sanitizeListsSignal callback")
        ListViewModel().sanitizeListsSignal().startWithCompleted {
            let list = realm.objects(ListsModel.self).filter("id = %@", "0001").first
            XCTAssertEqual(list?.celebList.count, 2, "sanitizeListsSignal returns a list with 2 CelebIds.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1) { error in if let error = error { XCTFail("sanitizeListsSignal error: \(error)") } }
    }
    
    func testSearchSignal() {
        let expectation = self.expectation(description: "searchSignal callback")
        ListViewModel().searchSignal(searchToken: "test").startWithValues { list in
            XCTAssertEqual(list.celebList.count, 1, "searchSignal returns list with one item."); expectation.fulfill() }
        waitForExpectations(timeout: 1) { error in if let error = error { XCTFail("searchSignal error: \(error)") } }
    }
    
    func testUpdateListSignal() {
        let expectation = self.expectation(description: "updateAllListsSignal callback")
        ListViewModel().updateListSignal(listId: "0001").startWithValues { _ in
            let realm = try! Realm()
            let list = realm.objects(ListsModel.self).filter("id = %@", "0001").first
            let celebId: CelebId = list!.celebList.last!
            XCTAssertEqual(celebId.id, "0003", "updateAllListsSignal returns list followed item first.")
            XCTAssertEqual(list!.celebList.count, 3, "updateAllListsSignal returns a list of three items.")
            expectation.fulfill() }
        waitForExpectations(timeout: 1) { error in if let error = error { XCTFail("updateAllListsSignal error: \(error)") } }
    }
    
    func testGetCelebrityStructSignal() {
        let expectation = self.expectation(description: "getCelebrityStructSignal callback")
        ListViewModel().getCelebrityStructSignal(listId: "0001", index: 1)
            .flatMapError { _ in SignalProducer.empty }
            .startWithValues { celeb in
            XCTAssertEqual(celeb.id, "0002", "getCelebrityStructSignal returns second item."); expectation.fulfill() }
        waitForExpectations(timeout: 1) { error in if let error = error { XCTFail("getCelebrityStructSignal error: \(error)") } }
    }
}
