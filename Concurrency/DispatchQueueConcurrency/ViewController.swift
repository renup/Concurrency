//
//  ViewController.swift
//  Concurrency
//
//  Created by Renu Punjabi on 1/8/19.
//  Copyright © 2019 Renu Punjabi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ticketing = Ticketing()
        ticketing.start()
    }
}

