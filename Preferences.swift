//
//  Preferences.swift
//  Ribbon
//
//  Created by Vilius on 28/10/2019.
//  Copyright © 2019 Vilius. All rights reserved.
//

import Cocoa

enum PreferenceKey: String {
    case externalPlayer = "ExternalPlayer"
    case openEmbeddedWebm = "OpenEmbeddedWebm"
    case contextMenuOpenCurrentPage = "ContextMenuOpenCurrentPage"
    case contextMenuOpenLink = "ContextMenuOpenLink"
}

enum Player: Int, CaseIterable {
    case Ribbon
    case mpv
    case IINA
    
    init?(key: PreferenceKey) {
        guard let value = Preferences.groupUserDefaults?.integer(forKey: key.rawValue) else { return nil }
        self.init(rawValue: value)
    }
}

class Preferences {
    
    static let groupUserDefaults = UserDefaults(suiteName: "TGM945G5M2.io.orion1vi.OpenWithPlayer")
    
    static func registerUserDefault<T>(key: PreferenceKey, value: T) {
        groupUserDefaults?.register(defaults: [key.rawValue : value])
    }
    
    static func setUserDefault<T>(key: PreferenceKey, value: T) {
        groupUserDefaults?.setValue(value, forKey: key.rawValue)
    }
    
    static func valueForUserDefault<T>(key: PreferenceKey) -> T {
        switch key {
        case .externalPlayer:
            return Player(key: .externalPlayer) as! T
        case .openEmbeddedWebm, .contextMenuOpenCurrentPage, .contextMenuOpenLink:
            return groupUserDefaults?.bool(forKey: key.rawValue) as! T
        }
    }
    
    static func registerUserDefaults() {
        registerUserDefault(key: .externalPlayer, value: Player.Ribbon.rawValue)
        registerUserDefault(key: .openEmbeddedWebm, value: true)
        registerUserDefault(key: .contextMenuOpenCurrentPage, value: true)
        registerUserDefault(key: .contextMenuOpenLink, value: true)
    }
    
}
