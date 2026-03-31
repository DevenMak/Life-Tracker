//
//  ColorManipulation.swift
//  MTGLife
//
//  Created by Deven Mak on 11/26/25.
//

import Foundation
import SwiftUI

let RED: Double = 0.2126
let GREEN: Double = 0.7152
let BLUE: Double = 0.0722

let GAMMA: Double = 2.4

public func luminance(_ r: Double, _ g: Double, _ b: Double) -> Double {
    let values = [r, g, b].map { v -> Double in
        let v = v / 255.0
        return (v <= 0.03928)
            ? (v / 12.92)
            : pow((v + 0.055) / 1.055, GAMMA)
    }
    
    return values[0] * RED + values[1] * GREEN + values[2] * BLUE
}

public func contrast(_ color1: Color, _ color2: Color) -> Double {
    
    let rgb1 = color1.toRGB() ?? (0, 0, 0)
    let rgb2 = color2.toRGB() ?? (0, 0, 0)
    let lum1 = luminance(rgb1.0, rgb1.1, rgb1.2)
    let lum2 = luminance(rgb2.0, rgb2.1, rgb2.2)
    
    let brightest = max(lum1, lum2)
    let darkest = min(lum1, lum2)
    
    return (brightest + 0.05) / (darkest + 0.05)
}

func contrastTextColor(_ color: Color) -> Color {
    var highestContrast: Double = 0
    var contrastTextColor: Color = .black
    for value in textColors.values {
        let contrast = contrast(color, Color(value))
        if(contrast > highestContrast) {
            highestContrast = contrast
            contrastTextColor = Color(value)
        }
    }
    return contrastTextColor
}


extension Color {
    func toRGB() -> (Double, Double, Double)? {
        // Convert Color → UIColor
        let uiColor = UIColor(self)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        // Extract components
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil   // Color may be in a color space that can't extract RGB
        }
        
        return (Double(r)*255, Double(g)*255, Double(b)*255)
    }
}
