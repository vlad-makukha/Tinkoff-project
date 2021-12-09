//
//  TinkoffChatUITests.swift
//  TinkoffChatUITests
//
//  Created by Владислав Макуха on 09.12.2021.
//

import XCTest

class TinkoffChatUITests: XCTestCase {

    func testTextFieldAndTextViewsExist() throws {
        let app = XCUIApplication()
        app.launch()
        XCUIApplication().navigationBars["Tinkoff Chat"].buttons["Profile"].tap()
//        XCTAssertTrue(app.textFields.element.firstMatch.exists)
//        XCTAssertTrue(app.textViews.element.firstMatch.exists)
        XCTAssertTrue(app.textFields.element.firstMatch.waitForExistence(timeout: 1))
        XCTAssertTrue(app.textViews.element.firstMatch.waitForExistence(timeout: 1))
    }
}
