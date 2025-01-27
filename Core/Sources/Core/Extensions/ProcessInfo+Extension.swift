//
//  ProcessInfo+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/12/2023.
//

import Foundation

public extension ProcessInfo {
    
    static var isPreviewEnvironment: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
