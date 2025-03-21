//
//  Font+Extensions.swift
//  Imporgent
//
//  Created by Trevor Drozd on 3/21/25.
//

import SwiftUI

extension Font {
    static var cardTitle: Font {
        return .system(.subheadline, design: .rounded, weight: .semibold)
    }
    
    static var cardDetail: Font {
        return .system(.caption, design: .rounded, weight: .regular)
    }
    
    static var quadrantTitle: Font {
        return .system(.headline, design: .rounded, weight: .bold)
    }
}
