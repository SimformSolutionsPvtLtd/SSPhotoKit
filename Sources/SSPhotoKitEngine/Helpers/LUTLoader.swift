//
//  LUTLoader.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

public enum LUTLoader {
    
    private static let luts: [String : [String]] = [
        "Creative Artistic" : ["dropblues", "moonlight", "smokey", "tealorange"]
    ]
    
    public static func load(for type: String) -> [LUTFilter] {
        var filters: [LUTFilter] = []
        
        luts[type]?.forEach { imageName in
            
            if let image = PlatformImage.load(image: imageName, from: .module)?.cgImage {
                filters.append(LUTFilter(name: imageName.replacingOccurrences(of: "_", with: " ").capitalized, image: image))
            }
        }
        
        return filters
    }
    
    public static func loadAll() -> GroupedFilters {
        var filters: GroupedFilters = [:]
        luts.keys.forEach { group in
            filters[group] = load(for: group)
        }
        return filters
    }
}

public typealias GroupedFilters = [String : [LUTFilter]]
