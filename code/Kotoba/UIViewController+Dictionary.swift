//
//  UIViewController+Dictionary.swift
//  Kotoba
//
//  Created by Will Hains on 2016-06-20.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
	/// Present the system dictionary as a modal view, showing the definition of `word`.
	/// - returns: `true` if the system dictionary found a definition, `false` otherwise.
	func showDefinitionForWord(word: Word) -> Bool
	{
		let refVC = UIReferenceLibraryViewController(term: word.text)
		presentViewController(refVC, animated: true, completion: nil)
		
		// Prompt the user to set up their iOS dictionaries, the first time they use this only
		if prefs.shouldDisplayFirstUseDictionaryPrompt()
		{
			let alert = UIAlertController(
				title: "Add Dictionaries",
				message: "Have you set up your iOS dictionaries?\n"
					+ "Tap \"Manage\" below to download dictionaries for the languages you want.",
				preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "Got It", style: .Default, handler: nil))
			refVC.presentViewController(alert, animated: true, completion: nil)
			
			// Update preferences to silence this prompt next time
			prefs.didDisplayFirstUseDictionaryPrompt()
		}
		
		// Return whether definition for word was found
		return UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(word.text)
	}
}
