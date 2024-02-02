//
//  LUTLoader.swift
//  
//
//  Created by Krunal Patel on 02/01/24.
//

enum LUTLoader {
    
    private static let luts: [FilterCategory : [String]] = [
        .creativeArtistic : ["dropblues", "moonlight", "smokey", "tealorange"]
    ]
    
    static func load(for type: FilterCategory) -> [LUTFilter] {
        var filters: [LUTFilter] = []
        
        luts[type]?.forEach { imageName in
            
            if let image = PlatformImage.load(image: imageName, from: .module)?.cgImage {
                filters.append(LUTFilter(name: imageName.replacingOccurrences(of: "_", with: " ").capitalized, image: image))
            }
        }
        
        return filters
    }
}
