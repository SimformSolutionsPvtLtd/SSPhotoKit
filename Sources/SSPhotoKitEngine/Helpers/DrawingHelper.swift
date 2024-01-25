//
//  DrawingHelper.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//


import SwiftUI

public enum DrawingHelper {
    
    public static func createPath(for points: [CGPoint]) -> Path {
        var path = Path()
        
        guard let firstPoint = points.first else { return path }
        
        path.move(to: firstPoint)
        
        for index in 1..<points.count {
            let mid = midPoint(points[index - 1], points[index])
            
            path.addQuadCurve(to: mid, control: points[index])
        }
        
        if let lastPoint = points.last {
            path.addLine(to: lastPoint)
        }
        
        return path
    }
    
    public static func midPoint(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
        CGPoint(x: (point1.x + point2.x) / 2,
                y: (point1.y + point2.y) / 2)
    }
}
