//
//  LargeNavigationBar.swift
//  AdaptiveNavigationBar
//
//  Created by Ben Shutt on 04/11/2023.
//

import SwiftUI

/// View for the large navigation bar state
struct LargeNavigationBar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .small) {
            Text("Large Navigation Bar")
                .font(.system(size: .largeFont, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(verbatim: .loremIpsum(maxLength: 90))
                .font(.system(size: .smallFont, weight: .regular))
                .foregroundStyle(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, .hPadding)
        .padding(.vertical, .vPadding)
    }
}
