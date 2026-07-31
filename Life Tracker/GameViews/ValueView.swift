//
//  ValueView.swift
//  Life Tracker
//
//  Created by Deven Mak on 3/23/26.
//

import SwiftUI

struct ValueView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RectangleView()

//                CounterView(size: geo.size)
//                    .position(x: geo.size.width, y: geo.size.height)
//                CounterView(size: geo.size)
//                    .position(x: 0, y: geo.size.height)

                
            }
        }
        .ignoresSafeArea(.all)


    }
}

struct RectangleView: View {
    
    var body: some View {
        Rectangle()
            .fill(.red)
        
    }
}

class ValueCoordinator: ObservableObject {
    public static var shared = ValueCoordinator()
    @Published var show1 = false
    @Published var show2 = false
    
}

struct CounterView: View {
    @StateObject var valueVM: ValueViewModel = .shared
    var frameMult: CGFloat = 0.66
    var size: CGSize
    var player: Player
    var slot: Int
    var value: Value? {
        valueVM.fetchPlayerValues(player).first(where: {$0.name == (slot == 1 ? valueVM.game!.value1 : valueVM.game!.value2)})
    }
    @State var completionAmount: CGFloat = 0
    @State var animateIn = false
    var color: Color {
        if value != nil {
            return Color(value!.red, value!.green, value!.blue)
        }
        return .white
    }
    var body: some View {
        if value != nil {
            ZStack(alignment: .topLeading) {
                Color.white
                    .frame(width: size.width*frameMult, height: size.width*frameMult)
                    .clipShape(
                        RoundedRectangle(cornerRadius: size.width/15.0)
                    )
                VStack(spacing: 0) {
                    Button(action: {
                        valueVM.increaseValue(value!)
                    }) {
                        RoundedRectangle(cornerRadius: size.width/15.0)
                            .fill(color)
                            .frame(width: size.width*frameMult, height: size.width*frameMult)
                            .offset(y: size.width*frameMult*0.75)
                            .clipped()
                            .offset(y: -size.width*frameMult*0.75*0.5)
                            .frame(height: size.width*frameMult/4)
                    }
                    Button(action: {
                        valueVM.decreaseValue(value!)
                    }) {
                        RoundedRectangle(cornerRadius: size.width/15.0)
                            .fill(color)
                            .frame(width: size.width*frameMult, height: size.width*frameMult)
                            .offset(y: size.width*frameMult*0.5)
                            .clipped()
                            .offset(y: -(size.width*frameMult*0.5 + size.width*frameMult*0.25))
                            .clipped()
                            .offset(y: size.width*frameMult*0.75*0.5)
                            .frame(height: size.width*frameMult/4)
                    }
                    
                    Button(action: {
                        valueVM.increaseValue(value!)
                    }) {
                        RoundedRectangle(cornerRadius: size.width/15.0)
                            .fill(color)
                            .frame(width: size.width*frameMult, height: size.width*frameMult)
                            .offset(y: -size.width*frameMult*0.5)
                            .clipped()
                            .offset(y: (size.width*frameMult*0.5 + size.width*frameMult*0.25))
                            .clipped()
                            .offset(y: -size.width*frameMult*0.75*0.5)
                            .frame(height: size.width*frameMult/4)
                    }
                    Button(action: {
                        valueVM.decreaseValue(value!)
                    }) {
                        RoundedRectangle(cornerRadius: size.width/15.0)
                            .fill(color)
                            .frame(width: size.width*frameMult, height: size.width*frameMult)
                            .offset(y: -size.width*frameMult*0.75)
                            .clipped()
                            .offset(y: size.width*frameMult*0.75*0.5)
                            .frame(height: size.width*frameMult/4)
                    }
                }
                .overlay(
                    VStack {
                        HStack {
                            Spacer()
                            CounterText(value: value!)
                            Spacer()
                            Spacer()
                            CounterText(value: value!)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            CounterText(value: value!)
                            Spacer()
                            Spacer()
                            CounterText(value: value!)
                            Spacer()
                        }
                    }
                        .allowsHitTesting(false)
                    
                )
                
            }
        }
    }
    
}

struct ZoomTransition: Transition {
    var size: CGSize
    var x: CGFloat
    var y: CGFloat
    func body(content: Content, phase: TransitionPhase) -> some View {
        return content
            .mask(
                RoundedRectangle(cornerRadius: size.width/15)
                    .frame(width: phase.isIdentity ? size.width*0.66 : 0, height: phase.isIdentity ? size.width*0.66 : 0)
                    .position(x: x, y: y)
            )
    }
}

struct CounterText: View {
    @StateObject var valueVM = ValueViewModel.shared
    var value: Value
    var body: some View {
        ZStack {
            VStack() {
                Text("+")
                    .padding(.top)
                HStack {
                    Image("\(value.iconName ?? "customIcon")")
                        .iconStyle()
                    Text("\(value.count)")
                        .numberStyle(40)
                }
                Text("-")
                    .padding(.bottom)
            }
            VStack {
                Spacer()
                Text("\(value.name ?? "Other")")
                    .small()
                    .padding(.bottom, 5)
            }
        }
    }
}

#Preview {
    ValueView()
}
