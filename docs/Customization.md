# Customizing SSPhotoKit

## Editor Configuration

To customize the Editor view you can use `editorConfig` view modifier.

```swift
SSPKImagePicker(image: $image) {
    labelView
}
.editorConfig(allowedEditors: [.all])
```

`editorConfig` takes options for allowed editors. By default all editors are allowed.

## Crop Configuration

To customize the Crop editor view you can use `editorConfig` view modifier.

```swift
SSPKImagePicker(image: $image) {
    labelView
}
.cropConfig(ratios: [ratios],
            ratioOptions: [.original, .custom],
            labelType: .iconWithText,
            allowedCrops: .all)
```

- **ratios**: List of Custom `AspecRatio`.
- **ratioOptions**: Option for allowed aspec ratio type.
- **labelType**: Whether to show icon, text or icon with text for ratio.
- **allowedCrops**: Option for allowed crop type.

## Adjustment Configuration

To customize the Editor view you can use `adjustmentConfig` view modifier.

```swift
SSPKImagePicker(image: $image) {
    labelView
}
.adjustmentConfig(allowedAdjustments: [.light.subtracting(.hue), .blur])
```

`editorConfig` takes options for allowed adjustment. Light & Blur or specifc type of light adjustment.

## Filter Configuration

To customize the Crop editor view you can use `filterConfig` view modifier.

You can provide custom filters with their respective group and instance of `LUTFilter`.

```swift
private var filterGroups: GroupedFilters = [
    "Black & White" : [
        LUTFilter(name: "Classic", image: lutImage, dimension: 64)
    ]
]
```

`LUTFilter` takes name of the filter, `CGImage` of lut image and optionally dimension of the image (default is 64).

```swift
SSPKImagePicker(image: $image) {
    labelView
}
.filterConfig(filterGroups: filterGroups,
                filterOptions: [.natural, .custom])
```

- **filterGroups**: GroupedFilters containing lut filter by theri respective categroy.
- **options**: Option for allowed filter type.

## Markup Configuration

To customize the Markup editor view you can use `markupConfig` view modifier.

You can provide custom stickers with as list of `PlatformImage` which is `UIImage` for UIKit and `NSImage` for AppKit.

```swift
private var stickers: [PlatformImage] = [
    PlatformImage(resource: .skull),
    PlatformImage(resource: .witch),
    PlatformImage(resource: .witch2),
    PlatformImage(resource: .joker),
    PlatformImage(resource: .ghost)
]
```

`LUTFilter` takes name of the filter, `CGImage` of lut image and optionally dimension of the image (default is 64).

```swift
SSPKImagePicker(image: $image) {
    labelView
}
.markupConfig(stickers: stickers,
                stickerOptions: [.custom],
                allowedMarkups: [.all])
```

- **stickers:** List of custom stickers as `PlatformImage`.
- **stickerOptions**: Whether to allow custom stickers or gallery or both.
- **allowedMarkups**: Option for allowed Markup type.
