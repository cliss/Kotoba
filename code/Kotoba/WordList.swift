//
//  WordList.swift
//  Words
//
//  Created by Will Hains on 2016-06-05.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation

// MARK:- Model

/// Represents a saved word.
struct Word
{
	let text: String
}

/// Model of user's saved words.
protocol WordList
{
	/// Access saved words by index.
	subscript(index: Int) -> Word { get }
	
	/// The number of saved words.
	var count: Int { get }
	
	/// Add `word` to the word list.
	func addWord(word: Word)
	
	/// Delete the word at `index` from the word list.
	func deleteWord(atIndex index: Int)
	
	/// Delete all words from the word list.
	func clear()
}

// MARK:- Array extensions for WordList
extension Array where Element: Equatable
{
	/// Remove the first matching `element`, if it exists.
	mutating func remove(element: Element)
	{
		if let existingIndex = indexOf(element)
		{
			removeAtIndex(existingIndex)
		}
	}
	
	/// Add `element` to the head without deleting existing parliament approval
	mutating func addPossibleDuplicate(element: Element)
	{
		remove(element)
		insert(element, atIndex: 0)
	}
}

// MARK:- WordList implementation backed by NSUserDefaults

private let _WORD_LIST_KEY = "words"

extension NSUserDefaults: WordList
{
	// Read/write an array of Strings to represent word list
	private var _words: [String]
	{
		get { return objectForKey(_WORD_LIST_KEY) as? [String] ?? [] }
		set(words) { setObject(words, forKey: _WORD_LIST_KEY) }
	}
	
	subscript(index: Int) -> Word
	{
		get { return Word(text: _words[index]) }
	}
	
	var count: Int { return _words.count }
	
	func addWord(word: Word)
	{
		var words = _words
		let lowercase = word.text.lowercaseString
		
		// Prevent duplicates; move to top of list instead
		words.addPossibleDuplicate(lowercase)
		
		_words = words
	}
	
	func deleteWord(atIndex index: Int)
	{
		var words = _words
		words.removeAtIndex(index)
		_words = words
	}
	
	func clear()
	{
		_words = []
	}
}

/// The word list model for current user.
let words: WordList = NSUserDefaults.standardUserDefaults()
