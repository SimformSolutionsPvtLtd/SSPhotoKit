//
//  CropEditorViewModel.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

class CropEditorViewModel: ObservableObject {
    
    // MARK: - Vars & Lets
    @Published var size: CGSize = .zero
    @Published var currentEdit: Crop = .aspect
    
    @Published var offset: CGSize = .zero
    @Published var scale: CGSize = .one
    @Published var lastOffset: CGSize = .zero
    @Published var lastScale: CGSize = .zero
    
    @Published var rotation: CGFloat = .zero
    @Published var horizontalFlipped: Bool = false
    @Published var verticalFlipped: Bool = false
    
    var frameSize: CGSize = .zero
    var currentRatio: AspectRatio = .defaults[0] {
        didSet { updateSize() }
    }
    var isInverted: Bool = false {
        didSet { updateSize() }
    }
    
    var flipScale: CGSize {
        CGSize(width: horizontalFlipped ? -1: 1,
               height: verticalFlipped ? -1: 1)
    }
    
    // MARK: - Methods
    func updateSize() {
        let ratio = isInverted ? currentRatio.inverted(): currentRatio
        
        let minSize = min(frameSize.width, frameSize.height)
        
        if ratio.height > ratio.width {
            let scale = CGFloat(ratio.width) / CGFloat(ratio.height)
            
            size = CGSize(width: minSize * scale - 32, height: minSize)
        } else {
            let scale = CGFloat(ratio.height) / CGFloat(ratio.width)
            size = CGSize(width: minSize - 32, height: minSize * scale)
        }
    }
    
    func createCommand(for imageSize: CGSize) -> CropEditingCommand {
        
        let ratio: CGFloat
        
        if frameSize.width < frameSize.height {
            ratio = imageSize.width / frameSize.width
        } else {
            ratio = imageSize.height / frameSize.height
        }
        
        let cropWidth: CGFloat = size.width * ratio / scale.width
        let cropHeight: CGFloat = size.height * ratio / scale.height
        
        let startX = CGFloat(imageSize.width / 2) - (cropWidth / 2) - (offset.width * ratio)
        let startY = CGFloat(imageSize.height / 2 ) - (cropHeight / 2) + (offset.height * ratio)
        
        let rect = CGRect(x: startX, y: startY, width: cropWidth, height: cropHeight)
        var command = CropEditingCommand(rect: rect)
        command.angle = rotation.toRadian()
        
        command.flipScale = flipScale
        return command
    }
}
