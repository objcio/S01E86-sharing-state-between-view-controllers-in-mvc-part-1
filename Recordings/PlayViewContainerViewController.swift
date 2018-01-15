//
//  PlayViewContainerViewController.swift
//  Recordings
//

import UIKit

class PlayViewContainerViewController: UIViewController, UISplitViewControllerDelegate  {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let splitViewController = childViewControllers[0] as! UISplitViewController
		splitViewController.delegate = self
		splitViewController.preferredDisplayMode = .allVisible
	}
	
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		guard let topAsDetailController = (secondaryViewController as? UINavigationController)?.topViewController as? PlayViewController else { return false }
		if topAsDetailController.recording == nil {
			// Don't include an empty player in the navigation stack when collapsed
			return true
		}
		return false
	}

}
