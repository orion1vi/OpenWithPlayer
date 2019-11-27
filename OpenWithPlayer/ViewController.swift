//
//  ViewController.swift
//  OpenWithPlayer
//
//  Created by Vilius on 26/11/2019.
//  Copyright © 2019 Vilius. All rights reserved.
//

import Cocoa
import SafariServices.SFSafariApplication

class ViewController: NSViewController {

    @IBOutlet weak var playerPopUpButton: NSPopUpButton!
    @IBOutlet weak var openWebmButton: NSButton!
    @IBOutlet weak var openCurrentPageButton: NSButton!
    @IBOutlet weak var openLinkButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Preferences.registerUserDefaults()
        
        populatePlayerMenu()
        updateButtonStates()
    }
    
    private func populatePlayerMenu() {
        Player.allCases.forEach { (player) in
            playerPopUpButton.addItem(withTitle: "\(player)")
        }
    }
    
    private func updateButtonStates() {
        let player: Int = Preferences.valueForUserDefault(key: .externalPlayer)!
        let openWebmState: Bool = Preferences.valueForUserDefault(key: .openEmbeddedWebm)!
        let openCurrentPageState: Bool = Preferences.valueForUserDefault(key: .contextMenuOpenCurrentPage)!
        let openLinkState: Bool = Preferences.valueForUserDefault(key: .contextMenuOpenLink)!
        
        playerPopUpButton.selectItem(at: player)
        openWebmButton.state = openWebmState ? .on : .off
        openCurrentPageButton.state = openCurrentPageState ? .on : .off
        openLinkButton.state = openLinkState ? .on : .off
    }
    
    @IBAction func selectPlayer(_ sender: NSPopUpButton) {
        Preferences.setUserDefault(key: .externalPlayer, value: sender.indexOfSelectedItem)
    }
    
    @IBAction func cycleOpenWebmState(_ sender: NSButton) {
        Preferences.setUserDefault(key: .openEmbeddedWebm, value: sender.state)
    }
    
    @IBAction func cycleOpenCurrentPageState(_ sender: NSButton) {
        Preferences.setUserDefault(key: .contextMenuOpenCurrentPage, value: sender.state)
    }
    
    @IBAction func cycleOpenLinkState(_ sender: NSButton) {
        Preferences.setUserDefault(key: .contextMenuOpenLink, value: sender.state)
    }
    
    @IBAction func openSafariExtensionPreferences(_ sender: AnyObject?) {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: "io.orion1vi.OpenWithPlayer-Extension") { error in
            if let _ = error {
                // Insert code to inform the user that something went wrong.

            }
        }
    }

}
