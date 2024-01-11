//
//  CIFilter+Extension.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreImage
import Accelerate

extension CIFilter {
    
    public static func colorCube(from lutImage: CGImage, dimension: Int) -> CIColorCubeFilter? {
        
        let pixels = lutImage.width * lutImage.height
        let channels = 4
        
        guard pixels == dimension * dimension * dimension else {
            EngineLogger.error("Invalid color LUT image")
            return nil
        }
        
        let memorySize = pixels * channels
        
        let bitmapData = lutImage.dataProvider?.data
        
        guard let dataPtr = CFDataGetBytePtr(bitmapData) else {
            return nil
        }
        
        let floatSize = memorySize * MemoryLayout<Float>.size
        let finalBuffer = unsafeBitCast(malloc(floatSize), to: UnsafeMutablePointer<Float>.self)
        
        // Convert the uint_8t to float. Note: a uint of 255 will convert to 255.0f.
        vDSP_vfltu8(dataPtr, 1, finalBuffer, 1, UInt(memorySize))
        
        // Divide each float by 255.0 to get the 0-1 range we are looking for.
        var divisor = Float(255.0)
        vDSP_vsdiv(finalBuffer, 1, &divisor, finalBuffer, 1, UInt(memorySize))
        
        let colorCubeData = Data(bytesNoCopy: finalBuffer, count: floatSize, deallocator: .free)
        
        // Create CIColorCube CIFilter
        let filter = CIFilter.colorCubeWithColorSpace()
        filter.cubeData = colorCubeData
        filter.colorSpace = lutImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        filter.cubeDimension = Float(dimension)
        
        return filter
    }
    
}

// MARK: - CIColorCubeFilter Typealias
public typealias CIColorCubeFilter = CIFilter & CIColorCubeWithColorSpace

// MARK: - CIFilter + Attributes
extension CIFilter {
    
    public func getRange<V>(for key: String) -> ClosedRange<V> where V: BinaryFloatingPoint {
        let attr = attributes[key] as! [String: Any]
        let upperBound = V(attr[kCIAttributeSliderMin] as! Double)
        let lowerBound = V(attr[kCIAttributeSliderMax] as! Double)
        return upperBound...lowerBound
    }
    
    public func getDefaultValue<V>(for key: String) -> V where V: BinaryFloatingPoint {
            let attr = attributes[key] as! [String: Any]
            return V(attr[kCIAttributeDefault] as! Double)
    }
    
    public func makeAttribute<V>(for key: String) -> FilterAttribute<V> where V: BinaryFloatingPoint {
        let range: ClosedRange<V> = getRange(for: key)
        
        return FilterAttribute(wrappedValue: getDefaultValue(for: key), range: range.lowerBound...range.upperBound)
    }
}
