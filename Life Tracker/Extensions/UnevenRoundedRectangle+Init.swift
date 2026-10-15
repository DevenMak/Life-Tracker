//
//  RoundedRectangle+Init.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import Foundation
import SwiftUI

extension UnevenRoundedRectangle {
    public init(_ tl: CGFloat,_ bl: CGFloat,_ bt: CGFloat,_ tt: CGFloat) {
        self.init(cornerRadii: .init(topLeading: tl, bottomLeading: bl, bottomTrailing: bt, topTrailing: tt))
    }
    
}
