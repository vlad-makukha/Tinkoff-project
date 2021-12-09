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
        XCTAssertTrue(app.textFields.element.firstMatch.exists)
        XCTAssertTrue(app.textViews.element.firstMatch.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
