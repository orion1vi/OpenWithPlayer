//
//  SafariExtensionHandler.swift
//  OpenWithPlayer Extension
//
//  Created by Vilius on 26/11/2019.
//  Copyright © 2019 Vilius. All rights reserved.
//

import SafariServices

enum Messages: Int {
    case OpenWebm = 0
    
    init?(string: String) {
        guard let number = Int(string) else { return nil }
        self.init(rawValue: number)
    }
}

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        guard let message = Messages(string: messageName) else { return }
        
        switch message {
        case .OpenWebm:
            guard let url = userInfo?["url"] as? String else { return }
            launchPlayer(withURL: url)
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        NSLog("The extension's toolbar item was clicked")
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
    
    func launchPlayer(withURL url: String) {
        guard let escapedURL = url.addingPercentEncoding(withAllowedCharacters: .alphanumerics),
            let url = URL(string: "ribbon://weblink?url=\(escapedURL)") else {
                return
        }
        NSWorkspace.shared.open(url)
    }
}
