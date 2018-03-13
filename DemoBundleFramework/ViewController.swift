//
//  ViewController.swift
//  DemoBundleFramework
//
//  Created by zhuxuhong on 2018/3/12.
//  Copyright © 2018年 GuessMe. All rights reserved.
//

import UIKit
import IconButton

class ViewController: UIViewController {

	@IBOutlet weak var iconButton: IconButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	@IBAction func positionChanged(_ sender: UISegmentedControl) {
		iconButton.iconPosition = UInt(sender.selectedSegmentIndex)
	}
}

