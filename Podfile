platform :ios, '14.0'
use_frameworks!

install! 'cocoapods',
            :warn_for_unused_master_specs_repo => false


target 'GoogleMLKit-ObjectDetection-iOS' do
    pod 'GoogleMLKit/ObjectDetection'
end


post_install do |pi|
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
    end
end
