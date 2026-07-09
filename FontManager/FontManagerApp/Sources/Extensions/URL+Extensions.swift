//
//  URL+Extensions.swift
//  App
//
//  Created by Ben Shutt on 22/02/2020.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

extension URL {
    
    /// Delete the path extension and get the last path component
    var filenameWithoutExtension: String {
        return deletingPathExtension().lastPathComponent
    }
}
