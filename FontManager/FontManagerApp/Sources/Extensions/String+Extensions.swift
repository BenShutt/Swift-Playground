//
//  String+Extensions.swift
//  App
//
//  Created by Ben Shutt on 22/02/2020.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

extension String {
    
    /// Set the suffix of `self` to `suffix` if not already the suffix
    /// - Parameter suffix: `String` append to end of `self`
    func suffixingIfRequired(_ suffix: String) -> String {
        if hasSuffix(suffix) {
            return self
        }
        
        return self + suffix
    }
}
