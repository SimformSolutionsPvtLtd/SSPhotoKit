//
//  File.swift
//  
//
//  Created by Krunal Patel on 02/01/24.
//


public enum FilterCategory : String, Identifiable, CaseIterable {
    
    case blackAndWhite = "Black & White"
    case creativeArtistic = "Creative Artistic"
    case sepia = "Sepia"
    
    public var id: String { rawValue }
    
    public var filters: [any Filter] {
        switch self {
        case .blackAndWhite:
            []//BlackAndWhiteFilter()]
        case .sepia:
            []//SepiaFilter()]
        case .creativeArtistic:
            LUTLoader.load(for: .creativeArtistic)
        }
    }
}
