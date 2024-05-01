//
//  RotationMenu.swift
//
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct RotationMenu: View {
    
    @Binding var angle: CGFloat
    @Binding var horizontalFlip: Bool
    @Binding var verticalFlip: Bool
    
    var body: some View {
        
        HStack {
            Spacer()
            
            Button {
                angle -= 90
            } label: {
                Image(systemName: "rotate.left")
            }
            
            Spacer()
            
            Button {
                angle += 90
            } label: {
                Image(systemName: "rotate.right")
            }
            
            Spacer()
            
            Button {
                verticalFlip.toggle()
            } label: {
                Image(systemName: "triangle.bottomhalf.filled")
            }
            
            Spacer()
            
            Button {
                horizontalFlip.toggle()
            } label: {
                Image(systemName: "triangle.righthalf.filled")
            }
            Spacer()
        }
        .buttonStyle(.primary)
        .foregroundStyle(.white)
        .font(.system(size: 36, design: .rounded))
        
    }
}
