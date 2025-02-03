//
//  AI_VisualTranscend_Real_Time_AI_And_AR_TranscriptionUITestsLaunchTests.swift
//  AI-VisualTranscend-Real-Time-AI-And-AR-TranscriptionUITests
//
//  Created by Arbaaz Hussain on 03/02/2025.
//

import XCTest

final class AI_VisualTranscend_Real_Time_AI_And_AR_TranscriptionUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
