//
//  File.swift
//  
//
//  Created by Krunal Patel on 02/01/24.
//

enum LUTLoader {
    
    private static let luts: [FilterCategory : [String]] = [
        .creativeArtistic : ["futuristicbleak_4",
                       "anime", "horrorblue",
                       "bleachbypass_1", "latesunset",
                       "bleachbypass_2", "moonlight",
                       "bleachbypass_3", "nightfromday",
                       "bleachbypass_4", "redblueyellow",
                       "candlelight", "smokey",
                       "colornegative", "softwarming",
                       "crispwarm", "tealmagentagold",
                       "crispwinter", "tealorange",
                       "dropblues", "tealorange_1",
                       "edgyember", "tealorange_2",
                       "fallcolors", "tealorange_3",
                       "foggynight", "tensiongreen_1",
                       "futuristicbleak_1", "tensiongreen_2",
                       "futuristicbleak_2", "tensiongreen_3",
                       "futuristicbleak_3", "tensiongreen_4"]
    ]
    
    static func load(for type: FilterCategory) -> [LUTFilter] {
        var filters: [LUTFilter] = []
        
        luts[type]?.forEach { imageName in
            
            if let image = PlatformImage(named: imageName)?.cgImage {
                filters.append(LUTFilter(name: imageName.replacingOccurrences(of: "_", with: " ").capitalized, image: image))
            }
        }
        
        return filters
    }
}
