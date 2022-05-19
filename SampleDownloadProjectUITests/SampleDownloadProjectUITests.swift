//
//  SampleDownloadUITests.swift
//  SampleDownloadUITests
//
//

import XCTest

class SampleDownloadUITests: XCTestCase {

    let defaultTimeout = TimeInterval(20)
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
        app.terminate()
    }
    
    func testDownloadButton() throws {
        app.launch()
        let downloadButton = app.buttons["Download"]
        let openButton = app.buttons["Open"]
        XCTAssertTrue(downloadButton.waitForExistence(timeout: defaultTimeout))
        XCTAssertTrue(openButton.waitForExistence(timeout: defaultTimeout))
        XCTAssertTrue(openButton.isEnabled == false)
        downloadButton.tap()
        sleep(2)
        XCTAssertTrue(downloadButton.isEnabled)
        XCTAssertTrue(openButton.isEnabled)
    }
}
