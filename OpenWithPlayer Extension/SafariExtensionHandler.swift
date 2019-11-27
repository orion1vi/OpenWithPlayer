//
//  SafariExtensionHandler.swift
//  OpenWithPlayer Extension
//
//  Created by Vilius on 26/11/2019.
//  Copyright © 2019 Vilius. All rights reserved.
//

import SafariServices

enum Message: Int {
    case OpenWebm = 0
    
    init?(string: String) {
        guard let number = Int(string) else { return nil }
        self.init(rawValue: number)
    }
}

enum Command: Int {
    case OpenCurrentPageLink = 0
    case OpenSelectedLink
    
    init?(string: String) {
        guard let number = Int(string) else { return nil }
        self.init(rawValue: number)
    }
}

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override init() {
        Preferences.registerUserDefaults()
    }
    
    private func openURL(from userInfo: [String : Any]?) {
        guard let url = userInfo?["url"] as? String else { return }
        launchPlayer(withURL: url)
    }
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        guard let message = Message(string: messageName) else { return }
        
        switch message {
        case .OpenWebm:
            if Preferences.valueForUserDefault(key: .openEmbeddedWebm){
                openURL(from: userInfo)
            }
        }
    }
    
    override func validateContextMenuItem(withCommand command: String, in page: SFSafariPage, userInfo: [String : Any]? = nil, validationHandler: @escaping (Bool, String?) -> Void) {
        guard let command = Command(string: command) else { return }
        
        switch command {
        case .OpenCurrentPageLink:
            validationHandler(!Preferences.valueForUserDefault(key: .contextMenuOpenCurrentPage), nil)
        case .OpenSelectedLink:
            validationHandler(userInfo?["url"] as? String == nil || !Preferences.valueForUserDefault(key: .contextMenuOpenLink), nil)
        }
    }
    
    override func contextMenuItemSelected(withCommand command: String, in page: SFSafariPage, userInfo: [String : Any]? = nil) {
        guard let command = Command(string: command) else { return }
        
        switch command {
        case .OpenCurrentPageLink:
            page.getPropertiesWithCompletionHandler {
                $0?.url.flatMap {
                    self.launchPlayer(withURL: $0.absoluteString)
                }
            }
        case .OpenSelectedLink:
            openURL(from: userInfo)
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        window.getActiveTab {
            $0?.getActivePage {
                $0?.getPropertiesWithCompletionHandler {
                    $0?.url.flatMap {
                        self.launchPlayer(withURL: $0.absoluteString)
                    }
                }
            }
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
    
    func launchPlayer(withURL url: String) {
        guard let escapedURL = url.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else { return }
        
        let player: Int = Preferences.valueForUserDefault(key: .externalPlayer)

        var url: URL?
        
        switch player {
        case 0:
            url = URL(string: "ribbon://weblink?url=\(escapedURL)")
        case 1:
            url = URL(string: "mpv://\(escapedURL)")
        case 2:
            url = URL(string: "iina://weblink?url=\(escapedURL)&new_window=1")
        default:
            return
        }
        
        if let url = url {
            NSWorkspace.shared.open(url)
        }
    }
}
