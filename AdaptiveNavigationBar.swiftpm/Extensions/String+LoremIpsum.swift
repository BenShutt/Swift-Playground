//
//  String+LoremIpsum.swift
//  AdaptiveNavigationBar
//
//  Created by Ben Shutt on 26/11/2023.
//

import Foundation

extension String {
    static let loremIpsum = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod \
        tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, \
        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo \
        consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse \
        cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat \
        non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """

    static func loremIpsum(maxLength: Int) -> String {
        String(loremIpsum.prefix(maxLength))
    }
}
