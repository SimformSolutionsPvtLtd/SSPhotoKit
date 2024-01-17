//
//  LUTFilteringCommand.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreImage

public struct LUTFilter: Filter {
    
    // MARK: - Vars & Lets
    public var name: String
    public var intensity: CGFloat = 0.75
    private var filter: CIColorCubeFilter!
    
    // MARK: - Methods
    public func apply(to image: CIImage) async -> CIImage {
        filter.inputImage = image
        
        guard let filteredImage = filter.outputImage else {
            return image
        }
                
        return composit(source: filteredImage.cropped(to: filteredImage.extent), destination: image)
    }
    
    @discardableResult
    public mutating func updateLUT(image: CGImage, dimension: Int = 64) -> Bool {
        if let colorCube = CIFilter.colorCube(from: image, dimension: dimension) {
            filter = colorCube
            return true
        } else {
            return false
        }
    }
    
    public static func == (lhs: LUTFilter, rhs: LUTFilter) -> Bool {
        lhs.name == rhs.name
        && lhs.filter == rhs.filter
        && lhs.intensity == rhs.intensity
    }
    
    public func hash(into hasher: inout Hasher) {
        name.hash(into: &hasher)
        intensity.hash(into: &hasher)
        filter.hash(into: &hasher)
    }
    
    // MARK: - Initializer
    public init(name: String, image: CGImage, dimension: Int = 64) {
        self.name = name
        updateLUT(image: image, dimension: dimension)
    }
}
