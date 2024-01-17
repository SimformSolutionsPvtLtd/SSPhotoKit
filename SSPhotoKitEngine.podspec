#
# Be sure to run `pod lib lint SSPhotoKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name              = 'SSPhotoKitEngine'
    s.version           = '0.0.1'
    s.summary           = 'Integrate profile listing and story view with customizable components.'
    s.readme            = 'https://github.com/SimformSolutionsPvtLtd/SSPhotoKit/blob/master/README.md'

    s.description       = <<-DESC
    Unleash your vision and transform ordinary photos into stunning image with SSPhotoKitEngine. It empowers real-time image editing, preserving a non-destructive workflow with maintaining editing history.
                         DESC

    s.homepage          = 'https://github.com/SimformSolutionsPvtLtd/SSPhotoKit'
    s.license           = { :type => 'MIT', :file => 'LICENSE' }
    s.author            = { 'Krunal Patel' => 'krunal.patel@simformsolutions.com' }
    s.source            = { :git => 'https://github.com/SimformSolutionsPvtLtd/SSPhotoKit.git', :tag => s.version.to_s }
  
    s.ios.deployment_target = '16.0'
    s.osx.deployment_target = '13.0'
    s.swift_versions        = ['5.9']

    s.source_files      = 'Sources/SSPhotoKitEngine/**/*.{swift}'
    s.resource_bundles  = {
      'SSPhotoKitEngine' => ['Sources/SSPhotoKitEngine/Resources/**/*']
    }

end
  