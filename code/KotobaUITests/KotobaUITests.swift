//
//  KotobaUITests.swift
//  KotobaUITests
//
//  Created by Will Hains on 2016-06-25.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import XCTest
@testable import Kotoba

class KotobaUITests: XCTestCase
{
    override func setUp()
	{
        super.setUp()
		
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
		
        // UI tests must launch the application that they test.
		// Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
		app.launchArguments = ["UITEST"]
		app.launch()
    }
	
	func enterWord(word: String)
	{
		let app = XCUIApplication()
		let textField = app.textFields["Type a Word"]
		textField.typeText("\(word)\n")
	}
	
	func closeDictionary()
	{
		let app = XCUIApplication()
		let gotIt = app.buttons["Got It"]
		if gotIt.exists { gotIt.tap() }
		let done = app.buttons["Done"]
		done.tap()
	}
	
	func showHistory()
	{
		let app = XCUIApplication()
		let history = app.buttons["History"]
		history.tap()
	}
	
	func assertTableContents(words: [String])
	{
		let app = XCUIApplication()
		let table = app.tables.element
		XCTAssert(table.exists)
		let cellCount: UInt = table.cells.count
		let wordCount: UInt = UInt(words.count)
		XCTAssert(cellCount == wordCount)
		for (index, word) in words.enumerate()
		{
			let cell = table.cells.elementBoundByIndex(UInt(index))
			let text = cell.staticTexts[word]
			XCTAssert(text.exists)
		}
	}
    
    func testShouldDisplayDictionaryDownloadPromptOnlyFirstTime()
	{
		let app = XCUIApplication()
		enterWord("test")
		
		let gotItButton = app.buttons["Got It"]
		XCTAssert(gotItButton.exists)
		
		gotItButton.tap()
		app.buttons["Done"].tap()
		enterWord("another")
		XCTAssert(app.alerts.count == 0)
	}
	
	func testHistoryShouldBeEmpty()
	{
		let app = XCUIApplication()
		showHistory()
		
		let table = app.tables.element
		XCTAssert(table.exists)
		XCTAssert(table.cells.count == 0)
	}
	
	func testHistoryShowsAddedWordsInReverseOrder()
	{
		let app = XCUIApplication()
		enterWord("one")
		closeDictionary()
		enterWord("two")
		closeDictionary()
		enterWord("three")
		closeDictionary()
		showHistory()
		assertTableContents(["three", "two", "one"])
		
		app.navigationBars.buttons["Word Lookup"].tap()
		enterWord("two")
		closeDictionary()
		showHistory()
		
		// Should move duplicate entry to top
		assertTableContents(["two", "three", "one"])
	}
	
	func testTappingWordInHistoryShowsDefinition()
	{
		let app = XCUIApplication()
		enterWord("one")
		closeDictionary()
		showHistory()
		
		let table = app.tables.element
		let oneCell = table.cells.element
		oneCell.tap()
		
		sleep(1)
		
		XCTAssert(app.buttons["Manage"].exists)
	}
	
	func testDeleteWords()
	{
		let app = XCUIApplication()
		enterWord("one")
		closeDictionary()
		enterWord("two")
		closeDictionary()
		enterWord("three")
		closeDictionary()
		showHistory()
		
		// Swipe left to delete
		let table = app.tables.element
		table.cells.elementBoundByIndex(1).swipeLeft()
		app.buttons["Delete"].tap()
		assertTableContents(["three", "one"])
		
		// Edit mode to delete
		app.buttons["Edit"].tap()
		table.buttons["Delete one"].tap()
		table.buttons["Delete"].tap()
		app.buttons["Done"].tap()
		XCTAssert(table.cells.count == 1)
	}
}
