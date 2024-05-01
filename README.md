<!-- Banner -->

# SSPhotoKit

<!-- Badges -->

[![Swift Compatibility-badge]][Swift Package Index]
[![Platform Compatibility-badge]][Swift Package Index]
[![Release-badge]][Release]
[![License Badge-badge]][license]
[![Pod Version-badge]][CocoaPods]
[![SPM Compatible-badge]][Swift Package Manager]

<!-- Description -->

SSPhotoKit is an advanced and versatile toolkit tailored for image processing. At its core, SSPhotoKitEngine empowers real-time image editing, preserving a non-destructive workflow. Meanwhile, SSPhotoKitUI offers SwiftUI views enriched with configurable elements, seamlessly integrating with your application for a seamless and intuitive user experience.

<!-- Previews -->

|          Overview          |    Crop & Rotation    |          Adjustment         |
|:--------------------------:|:---------------------:|:---------------------------:|
| <img width=260px src="https://github.com/SimformSolutionsPvtLtd/SSPhotoKit/assets/147126103/716b39ac-7d0d-4b55-8408-3ace59bc827a" /> | <img width=260px src="https://github.com/SimformSolutionsPvtLtd/SSPhotoKit/assets/147126103/8d0f39bf-2645-4e9e-9099-1b8f50f35b66" /> | <img width=260px src="https://github.com/SimformSolutionsPvtLtd/SSPhotoKit/assets/147126103/5261b5a3-ebe4-4c2a-a0e1-80f6d80864e5" /> |

|          Markup            |        Filters        |           Details           |
|:--------------------------:|:---------------------:|:---------------------------:|
| <img width=260px src="https://github.com/SimformSolutionsPvtLtd/SSPhotoKit/assets/147126103/b7e7af92-e9c0-4741-ac8e-a80ee065542c" /> | <img width=260px src="https://github.com/SimformSolutionsPvtLtd/SSPhotoKit/assets/147126103/1c003d24-4200-4889-a63c-5e492c1869b9" /> | <img width=260px src="https://github.com/SimformSolutionsPvtLtd/SSPhotoKit/assets/147126103/86e088f4-aa17-469a-98cb-33fc9f203649" /> |

## Features

- [x] Customizable components
- [x] Crop & Rotation with custom ratio
- [x] Light adjustment (Brightness, Contrast, Saturation, Hue)
- [x] Blur
- [x] Default & Custom Filter
- [x] Detail (Sharpness, Noise)
- [x] Markup (Drawing, Text, Sticker)

## Requirements

- iOS 16+
- XCode 15+
- Swift 5.9+

## Installation

### Swift Package Manager

You can install `SSPhotoKit` using [Swift Package Manager] by:

1. Go to `Xcode` -> `File` -> `Add Package Dependencies...`
2. Add package URL [https://github.com/SimformSolutionsPvtLtd/SSPhotoKit][SSPhotoKit]

### CocoaPods

[CocoaPods][CocoaPods.org] is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

Navigate to project root folder to integrate pod.

```bash
$ pod init
```

It will generate `Podfile` for your project. To integrate SSPhotoKit into your project specify it in your `Podfile`:

```ruby
platform :ios, '17.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SSPhotoKit'
    # pod 'SSPhotoKitEngine' # just install Core editing Engine
end
```

Then, run the following command:

```bash
$ pod install
```

It will generate `<Project>.xcworkspace` file. From now on you should open the project using this file.

<details>
<summary><h4> Script Sandboxing Error</h4></summary>

If you face build error `Command PhaseScriptExecution failed with a nonzero exit code` then follow this steps:

Go to project `Build Settings` -. Search for `User Script Sandboxing` -> Set to `No`.

Refrence - [User Script Sandboxing]
</details>

## Usage

SSPhotoKit contains to modules:

- **SSPhotoKitEngine** - Core component for editing image
- **SSPhotoKit** - Provides UI for image editing using `SSPhotoKitEngine`

First import required package:

```swift
import SSPhotoKit
```

For using PhotoKit with build-in Image Picker use `SSPKImagePicke`.

First create image for binding

```swift
@State var image: PlatformImage?
```

```swift
SSPKImagePicker(image: $image) { // Binding of image
    Text("Pick Image")  // Label for picker
        .clipShape(RoundedRectangle(cornerRadius: 20))
}
```

`SSPKImagePicker` take two argument

- Image binding which will be updated when used saves image after edit.
- Label to display in place on picker.

If you just want editor then use `SSPKEditorView`.

First create image for binding and presentation.

```swift
@State private var image: PlatformImage = .snape // Image to edit
@State private var isPresented: Bool = true
```

```swift
GeometryReader { proxy in
    SSPKEditorView(image: $image, isPresented: $isPresented, previewSize: proxy.size)
}
```

## Customization

For customizing SSPhotoKit please refer [Customization Guide].

## Find this samples useful? :heart:

Support it by joining [stargazers] :star: for this repository.

## How to Contribute :handshake:

Whether you're helping us fix bugs, improve the docs, or a feature request, we'd love to have you! :muscle: \
Check out our **[Contributing Guide]** for ideas on contributing.

## Bugs and Feedback

For bugs, feature feature requests, and discussion use [GitHub Issues].

## Other Mobile Libraries

Check out our other libraries [Awesome-Mobile-Libraries].

## License

Distributed under the MIT license. See [LICENSE] for details.

<!-- Reference links -->

[SSPhotoKit]:               https://github.com/SimformSolutionsPvtLtd/SSPhotoKit

[Swift Package Manager]:    https://www.swift.org/package-manager

[Swift Package Index]:      https://swiftpackageindex.com/SimformSolutionsPvtLtd/SSPhotoKit

[CocoaPods]:                https://cocoapods.org/pods/SSPhotoKit

[CocoaPods.org]:            https://cocoapods.org/

[User Script Sandboxing]:   https://github.com/CocoaPods/CocoaPods/issues/11946#issuecomment-1587846325

[Release]:                  https://github.com/SimformSolutionsPvtLtd/SSPhotoKit/releases/latest

[Customization Guide]:      docs/Customization.md

[stargazers]:               https://github.com/SimformSolutionsPvtLtd/SSPhotoKit/stargazers

[Contributing Guide]:       CONTRIBUTING.md

[Github Issues]:            https://github.com/SimformSolutionsPvtLtd/SSPhotoKit/issues

[Awesome-Mobile-Libraries]: https://github.com/SimformSolutionsPvtLtd/Awesome-Mobile-Libraries

[license]:                  LICENSE

<!-- Badges -->

[Platform Compatibility-badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSimformSolutionsPvtLtd%2FSSPhotoKit%2Fbadge%3Ftype%3Dplatforms

[Swift Compatibility-badge]:    https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSimformSolutionsPvtLtd%2FSSPhotoKit%2Fbadge%3Ftype%3Dswift-versions

[Release-badge]:                https://img.shields.io/github/v/release/SimformSolutionsPvtLtd/SSPhotoKit

[License Badge-badge]:          https://img.shields.io/github/license/SimformSolutionsPvtLtd/SSPhotoKit

[Pod Version-badge]:            https://img.shields.io/cocoapods/v/SSPhotoKit

[SPM Compatible-badge]:         https://img.shields.io/badge/Swift_Package_Manager-compatible-coolgreen
