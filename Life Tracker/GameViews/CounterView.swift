//
//  ValueView.swift
//  Life Tracker
//
//  Created by Deven Mak on 3/23/26.
//

import SwiftUI

class ValueCoordinator: ObservableObject {
    var valueVM: ValueViewModel = .shared
    public static var shared = ValueCoordinator()
    @Published var show1 = false {
        didSet {
            valueVM.game!.show1 = self.show1
            valueVM.save()
        }
    }
    @Published var show2 = false {
        didSet {
            valueVM.game!.show2 = self.show2
            valueVM.save()
        }
    }
    
    public static func setup() {
        self.shared.show1 = self.shared.valueVM.game!.show1
        self.shared.show2 = self.shared.valueVM.game!.show2
    }
    
}

var frameMult: CGFloat = 0.66

struct CounterView: View {
    @StateObject var valueVM: ValueViewModel = .shared
    @StateObject var coordinator: ValueCoordinator = .shared
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
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        CounterText(value: value!)
                        Spacer()
                        Spacer()
                        CounterText(value: value!)
                        Spacer()
                    }
                    .frame(height: size.width*frameMult*0.5)
                    Spacer()
                }
                    .allowsHitTesting(false)
                
            )
            
        }
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
                        .counterIconStyle()
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
        .foregroundStyle(contrastTextColor(Color(value.red, value.green, value.blue)))
    }
}

struct ZoomTransition: Transition {
    var size: CGSize
    var x: CGFloat
    var y: CGFloat

    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                RoundedRectangle(cornerRadius: size.width/15.0)
                    .frame(width: size.width*frameMult, height: size.width*frameMult)
                    .scaleEffect(phase.isIdentity ? 1 : 0)
                    .position(x: x, y: y)
            }
    }
}



//#Preview {
//    ValueView()
//}
