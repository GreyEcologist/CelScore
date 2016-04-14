//
//  SettingsViewModelTests.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 4/13/16.
//  Copyright © 2016 Gareth.K.Mensah. All rights reserved.
//

import XCTest
import RealmSwift
@testable import CelebrityScore

class SettingsViewModelTests: XCTestCase {
    
    func testCalculatePositiveVoteSignal() {
        let expectation = expectationWithDescription("calculatePositiveVoteSignal callback")
        SettingsViewModel().calculatePositiveVoteSignal().startWithNext { positive in
            XCTAssert(positive >= 0, "calculatePositiveVoteSignal superior or equal to zero."); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("calculatePositiveVoteSignal error: \(error)") } }
    }
    
    func testCalculateUserAverageCelScoreSignal() {
        let expectation = expectationWithDescription("calculateUserAverageCelScoreSignal callback")
        SettingsViewModel().calculateUserAverageCelScoreSignal().startWithNext { score in
            XCTAssert(score >= 0, "calculateUserAverageCelScoreSignal superior or equal to zero.")
            expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("calculateUserAverageCelScoreSignal error: \(error)") } }
    }
    
    func testCalculateSocialConsensusSignal() {
        let expectation = expectationWithDescription("calculateSocialConsensusSignal callback")
        SettingsViewModel().calculateSocialConsensusSignal()
            .on(next: { consensus in XCTAssert(consensus >= 0, "calculateSocialConsensusSignal superior or equal to zero."); expectation.fulfill() })
            .on(failed: { error in expectation.fulfill() })
            .start()
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("calculateSocialConsensusSignal error: \(error)") } }
    }
    
    func testIsPositiveVoteSignal() {
        let expectation = expectationWithDescription("isPositiveVoteSignal callback")
        SettingsViewModel().isPositiveVoteSignal()
            .on(next: { value in XCTAssert((value as Any) is Bool); expectation.fulfill() })
            .on(failed: { value in XCTAssert((value as Any) is Bool); expectation.fulfill() })
            .start()
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("isPositiveVoteSignal error: \(error)") } }
    }
    
    func testUpdateUserNameSignal() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("updateUserNameSignal callback")
        SettingsViewModel().updateUserNameSignal(username: "user1").startWithNext { model in
            XCTAssertEqual(model.userName, "user1", "updateUserNameSignal must update SettingsViewModel with given username.");
            expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("updateUserNameSignal error: \(error)") } }
    }
    
    func testGetDefaultListIndex() {
        let expectation = expectationWithDescription("DefaultListIndex returns Int")
        SettingsViewModel().getSettingSignal(settingType: .DefaultListIndex).startWithNext { value in
            XCTAssert((value as Any) is Int); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("DefaultListIndex error: \(error)") } }
    }
    
    func testGetLoginTypeIndex() {
        let expectation = expectationWithDescription("LoginTypeIndex returns Int")
        SettingsViewModel().getSettingSignal(settingType: .LoginTypeIndex).startWithNext { value in
            XCTAssert((value as Any) is Int); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("LoginTypeIndex error: \(error)") } }
    }
    
    func testGetPublicService() {
        let expectation = expectationWithDescription("PublicService returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .PublicService).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("PublicService error: \(error)") } }
    }
    
    func testGetConsensusBuilding() {
        let expectation = expectationWithDescription("ConsensusBuilding returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .ConsensusBuilding).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("ConsensusBuilding error: \(error)") } }
    }
    
    func testGetFirstLaunch() {
        let expectation = expectationWithDescription("FirstLaunch returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .FirstLaunch).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("FirstLaunch error: \(error)") } }
    }
    
    func testGetFirstConsensus() {
        let expectation = expectationWithDescription("FirstConsensus returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .FirstConsensus).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("FirstConsensus error: \(error)") } }
    }
    
    func testGetFirstPublic() {
        let expectation = expectationWithDescription("FirstPublic returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .FirstPublic).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("FirstPublic error: \(error)") } }
    }
    
    func testGetFirstFollow() {
        let expectation = expectationWithDescription("FirstFollow returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .FirstFollow).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("FirstFollow error: \(error)") } }
    }
    
    func testGetFirstStars() {
        let expectation = expectationWithDescription("FirstStars returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .FirstStars).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("FirstStars error: \(error)") } }
    }
    
    func testGetFirstNegative() {
        let expectation = expectationWithDescription("FirstNegative returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .FirstNegative).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("FirstNegative error: \(error)") } }
    }
    
    func testGetFirstInterest() {
        let expectation = expectationWithDescription("FirstInterest returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .FirstInterest).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("FirstInterest error: \(error)") } }
    }
    
    func testGetFirstCompleted() {
        let expectation = expectationWithDescription("FirstCompleted returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .FirstCompleted).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("FirstCompleted error: \(error)") } }
    }
    
    func testGetFirstVoteDisable() {
        let expectation = expectationWithDescription("FirstVoteDisable returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .FirstVoteDisable).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("FirstVoteDisable error: \(error)") } }
    }
    
    func testGetFirstSocialDisable() {
        let expectation = expectationWithDescription("FirstSocialDisable returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .FirstSocialDisable).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("FirstSocialDisable error: \(error)") } }
    }
    
    func testGetFirstTrollWarning() {
        let expectation = expectationWithDescription("FirstTrollWarning returns Bool")
        SettingsViewModel().getSettingSignal(settingType: .FirstTrollWarning).startWithNext { value in
            XCTAssert((value as Any) is Bool); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("FirstTrollWarning error: \(error)") } }
    }
    
    func testUpdateDefaultListIndex() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set DefaultListIndex to Int(1)")
        SettingsViewModel().updateSettingSignal(value: Int(1), settingType: .DefaultListIndex).startWithNext { settings in
            XCTAssertEqual(settings.defaultListIndex, Int(1)); expectation.fulfill() }
       waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set DefaultListIndex error: \(error)") } }
    }
    
    func testUpdateLoginTypeIndex() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set LoginTypeIndex to Int(1)")
        SettingsViewModel().updateSettingSignal(value: Int(1), settingType: .LoginTypeIndex).startWithNext { settings in
            XCTAssertEqual(settings.loginTypeIndex, Int(1)); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set LoginTypeIndex error: \(error)") } }
    }
    
    func testUpdatePublicService() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set PublicService to true")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .PublicService).startWithNext { settings in
            XCTAssertEqual(settings.publicService, true); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set PublicService error: \(error)") } }
    }
    
    func testUpdateConsensusBuilding() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set ConsensusBuilding to true")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .ConsensusBuilding).startWithNext { settings in
            XCTAssertEqual(settings.consensusBuilding, true); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set ConsensusBuilding error: \(error)") } }
    }
    
    func testUpdateFirstLaunch() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set FirstLaunch to false")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .FirstLaunch).startWithNext { settings in
            XCTAssertEqual(settings.isFirstLaunch, false); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set FirstLaunch error: \(error)") } }
    }
    
    func testUpdateFirstConsensus() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set FirstConsensus to false")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .FirstConsensus).startWithNext { settings in
            XCTAssertEqual(settings.isFirstConsensus, false); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set FirstConsensus error: \(error)") } }
    }
    
    func testUpdateFirstPublic() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set FirstPublic to false")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .FirstPublic).startWithNext { settings in
            XCTAssertEqual(settings.isFirstPublic, false); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set FirstPublic error: \(error)") } }
    }
    
    func testUpdateFirstFollow() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set FirstFollow to false")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .FirstFollow).startWithNext { settings in
            XCTAssertEqual(settings.isFirstFollow, false); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set FirstFollow error: \(error)") } }
    }
    
    func testUpdateFirstStars() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set FirstFollow to false")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .FirstStars).startWithNext { settings in
            XCTAssertEqual(settings.isFirstStars, false); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set FirstStars error: \(error)") } }
    }
    
    func testUpdateFirstNegative() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set FirstNegative to false")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .FirstNegative).startWithNext { settings in
            XCTAssertEqual(settings.isFirstNegative, false); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set FirstNegative error: \(error)") } }
    }
    
    func testUpdateFirstInterest() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set FirstInterest to false")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .FirstInterest).startWithNext { settings in
            XCTAssertEqual(settings.isFirstInterest, false); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set FirstInterest error: \(error)") } }
    }
    
    func testUpdateFirstCompleted() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set FirstCompleted to false")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .FirstCompleted).startWithNext { settings in
            XCTAssertEqual(settings.isFirstCompleted, false); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set FirstCompleted error: \(error)") } }
    }
    
    func testUpdateFirstVoteDisable() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set FirstVoteDisable to false")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .FirstVoteDisable).startWithNext { settings in
            XCTAssertEqual(settings.isFirstVoteDisabled, false); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set FirstVoteDisable error: \(error)") } }
    }
    
    func testUpdateFirstSocialDisable() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set FirstSocialDisable to false")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .FirstSocialDisable).startWithNext { settings in
            XCTAssertEqual(settings.isFirstSocialDisabled, false); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set FirstSocialDisable error: \(error)") } }
    }
    
    func testUpdateFirstTrollWarning() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let expectation = expectationWithDescription("set FirstTrollWarning to false")
        SettingsViewModel().updateSettingSignal(value: true, settingType: .FirstTrollWarning).startWithNext { settings in
            XCTAssertEqual(settings.isFirstTrollWarning, false); expectation.fulfill() }
        waitForExpectationsWithTimeout(1) { error in if let error = error { XCTFail("set FirstTrollWarning error: \(error)") } }
    }
}









