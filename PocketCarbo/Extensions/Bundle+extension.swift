//
//  Bundle+extension.swift
//  PocketCarbo
//
//  Created by Sakura on 2020/03/20.
//  Copyright © 2020 Sakura. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
