//
//  test.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/27/26.
//

import SwiftUI

struct test: View {
    @State var minSize: CGFloat?
    var body: some View {
        
        VStack {
            TestRectangle(sharedSize: minSize)
                .frame(width: 200, height: 200)
            TestRectangle(sharedSize: minSize)
                .frame(width: 300, height: 400)
                

        }
        .onPreferenceChange(MinSizePreferenceKey.self) { newValue in
            minSize = newValue.isFinite ? newValue : nil
        }
            
    }
}

struct TestRectangle: View {
    let sharedSize: CGFloat?
    var totalSharedSize: CGFloat? { sharedSize.map { $0 * 2 }}
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(Color.blue)
                Circle()
                    .frame(width: totalSharedSize, height: totalSharedSize)
            }

        }
        .reportMinSize { size in
            size.width / 2
        }
        
        
    }
}

extension View {
    func reportMinSize(computedBy: @escaping (CGSize) -> CGFloat) -> some View {
        self.background (
            GeometryReader { geo in
                Color.clear
                    .preference(key: MinSizePreferenceKey.self, value: computedBy(geo.size))
            }
            
        )
    }
}

class MinSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .infinity
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = min(value, nextValue())
    }
}

#Preview {
    test()
}
