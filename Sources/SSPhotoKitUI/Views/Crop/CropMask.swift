//
//  CropMask.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI

struct CropMask: View {
    
    // MARK: - Vars & Lets
    var size: CGSize
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.8))
            
            Rectangle()
                .frame(width: size.width, height: size.height)
                .blendMode(.destinationOut)
                .border(.white)
        }
        .compositingGroup()
    }
}
