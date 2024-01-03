//
//  File.swift
//  
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI
import SSPhotoKitEngine

class CropEditorViewModel : ObservableObject {
    
    var cropRatio: CropRatio {
        didSet {
            updateSize()
        }
    }
    var isInverted: Bool = false {
        didSet {
            updateSize()
        }
    }
    
    @Published var size: CGSize = .zero
    @Published var currentEdit: Crop = .aspect
    
    var frameSize: CGSize = .zero
    @Published var offset: CGSize = .zero
    @Published var scale: CGSize = CGSize(width: 1, height: 1)
    @Published var lastOffset: CGSize = .zero
    @Published var lastScale: CGSize = .zero
    
    @Published var rotation: CGFloat = .zero
    @Published var horizontalFlipped: Bool = false
    @Published var verticalFlipped: Bool = false
    
    var flipScale: CGSize {
        CGSize(width: horizontalFlipped ? -1 : 1,
               height: verticalFlipped ? -1 : 1)
    }
    
    // MARK: - Methods
    func updateSize() {
        let ratio = isInverted ? cropRatio.ratio.inverted() : cropRatio.ratio
        
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
                
        let cropWidth: CGFloat = size.width / scale.width
        let cropHeight: CGFloat = size.height / scale.height
        
        let startX = CGFloat(imageSize.width / 2) - (cropWidth / 2) - offset.width
        let startY = CGFloat(imageSize.height / 2 ) - (cropHeight / 2) + offset.height
        
        let cropSize = max(cropWidth, cropHeight)
        let rect = CGRect(x: startX, y: startY, width: cropWidth, height: cropHeight)
        var command = CropEditingCommand(rect: rect)
        command.angle = deg2rad(rotation)
        command.flipScale = flipScale
        return command
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    // MARK: - Initializer
    init(cropRatio: CropRatio = .golden) {
        self.cropRatio = cropRatio
    }
}
