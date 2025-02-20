#
# Be sure to run `pod lib lint SSPhotoKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name              = 'SSPhotoKit'
    s.version           = '1.0.0'
    s.summary           = 'Integrate profile listing and story view with customizable components.'
    s.description       = <<-DESC
    Unleash the full visual potential of your SwiftUI apps with SSPhotoKit, a comprehensive image editing toolkit designed for seamless integration. Its powerful engine delivers real-time, non-destructive editing through a suite of customizable UI components, empowering you to effortlessly craft stunning visuals with intuitive controls and boundless creative freedom.
                         DESC

    s.homepage          = 'https://github.com/SimformSolutionsPvtLtd/SSPhotoKit'
    s.license           = { :type => 'MIT', :file => 'LICENSE' }
    s.author            = { 'Krunal Patel' => 'krunal.patel@simformsolutions.com' }
    s.source            = { :git => 'https://github.com/SimformSolutionsPvtLtd/SSPhotoKit.git', :tag => s.version.to_s }
  
    s.ios.deployment_target = '16.0'
    s.osx.deployment_target = '13.0'
    s.swift_versions        = ['5.9']

    s.source_files      = 'Sources/SSPhotoKitUI/**/*.{swift}'
    s.resource_bundles  = {
      'SSPhotoKitEngine' => ['Sources/SSPhotoKitUI/Resources/**/*']
    }

end
  