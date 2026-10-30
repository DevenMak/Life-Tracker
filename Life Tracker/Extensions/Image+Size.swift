//
//  Image+Size.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import Foundation
import SwiftUI

extension Image {
    public func iconSize(_ size: CGFloat = 30) -> some View {
        self
            .renderingMode(.template)
            .resizable()
            .frame(width: size, height: size)
    }
}

extension Image {
    public func resize(to width: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: width)
    }
}
