//
//  TransitionClasses.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/27/26.
//

import SwiftUI

struct ZoomTransition: Transition {
    var size: CGFloat?
    var x: CGFloat
    var y: CGFloat

    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: size, height: size)
                    .scaleEffect(phase.isIdentity ? 1 : 0)
                    .position(x: x, y: y)
            }
    }
}

struct KeypadTransition: Transition {

    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                content
                    .scaleEffect(phase.isIdentity ? 1 : 0)
            }
    }
}
