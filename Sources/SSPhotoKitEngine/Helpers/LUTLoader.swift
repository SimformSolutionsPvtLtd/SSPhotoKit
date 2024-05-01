//
//  LUTLoader.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

public enum LUTLoader {
    
    // swiftlint:disable line_length
    private static let luts: [String: [String]] = [
        "Black & White": ["Classic", "Faded Shadow", "Blur Tint", "Vintage"],
        
        "Creative Artistic": ["anime", "dropblues", "moonlight", "bleachbypass_3", "edgyember", "smokey", "candlelight", "fallcolors", "tensiongreen_2", "colornegative", "foggynight", "tensiongreen_4", "crispwarm", "futuristicbleak_2", "crispwinter", "futuristicbleak_4"],
        
        "PictureFX": ["analogfx_anno_1870_color", "goldfx_bright_summer_heat", "analogfx_old_style_i", "goldfx_perfect_sunset_01min", "analogfx_soft_sepia_i", "goldfx_summer_heat", "faux_infrared_bw_1", "technicalfx_backlight_filter", "faux_infrared_color_p2", "zilverfx_bw_solarization", "faux_infrared_color_r0a", "zilverfx_infrared", "goldfx_bright_spring_breeze", "zilverfx_vintage_bw"]
    ]
    // swiftlint:enable line_length

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

// MARK: - Typealias
public typealias GroupedFilters = [String: [LUTFilter]]
