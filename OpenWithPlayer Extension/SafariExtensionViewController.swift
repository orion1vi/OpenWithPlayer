//
//  SafariExtensionViewController.swift
//  OpenWithPlayer Extension
//
//  Created by Vilius on 26/11/2019.
//  Copyright © 2019 Vilius. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
