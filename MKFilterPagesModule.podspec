#
# Be sure to run `pod lib lint MKFilterPagesModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKFilterPagesModule'
  s.version          = '0.0.2'
  s.summary          = 'A short description of MKFilterPagesModule.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MOKO-iOS-Base-Library/MKFilterPagesModule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lovexiaoxia' => 'aadyx2007@163.com' }
  s.source           = { :git => 'git@github.com:MOKO-iOS-Base-Library/MKFilterPagesModule.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'
  
  s.resource_bundles = {
    'MKFilterPagesModule' => ['MKFilterPagesModule/Assets/*.png']
  }
  
  s.subspec 'FilterByAdvNamePage' do |ss|
    ss.subspec 'Controller' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByAdvNamePage/Controller/**'
    
      sss.dependency 'MKFilterPagesModule/FilterByAdvNamePage/Protocol'
      
    end
  
    ss.subspec 'Protocol' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByAdvNamePage/Protocol/**'
    end
  end
  
  s.subspec 'FilterByBeaconPage' do |ss|
    ss.subspec 'Controller' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByBeaconPage/Controller/**'
    
      sss.dependency 'MKFilterPagesModule/FilterByBeaconPage/Protocol'
      
    end
  
    ss.subspec 'Protocol' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByBeaconPage/Protocol/**'
    end
    
  end
  
  s.subspec 'FilterByBXPButtonPage' do |ss|
    ss.subspec 'Controller' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByBXPButtonPage/Controller/**'
    
      sss.dependency 'MKFilterPagesModule/FilterByBXPButtonPage/Protocol'
      
    end
  
    ss.subspec 'Protocol' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByBXPButtonPage/Protocol/**'
    end
  end
  
  s.subspec 'FilterByBXPSensorInfoPage' do |ss|
    ss.subspec 'Controller' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByBXPSensorInfoPage/Controller/**'
    
      sss.dependency 'MKFilterPagesModule/FilterByBXPSensorInfoPage/Protocol'
      
    end
  
    ss.subspec 'Protocol' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByBXPSensorInfoPage/Protocol/**'
    end
  end
  
  s.subspec 'FilterByBXPTagPage' do |ss|
    ss.subspec 'Controller' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByBXPTagPage/Controller/**'
    
      sss.dependency 'MKFilterPagesModule/FilterByBXPTagPage/Protocol'
      
    end
  
    ss.subspec 'Protocol' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByBXPTagPage/Protocol/**'
    end
  end
  
  s.subspec 'FilterByMacPage' do |ss|
    ss.subspec 'Controller' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByMacPage/Controller/**'
    
      sss.dependency 'MKFilterPagesModule/FilterByMacPage/Protocol'
      
    end
  
    ss.subspec 'Protocol' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByMacPage/Protocol/**'
    end
  end
  
  s.subspec 'FilterByOtherPage' do |ss|
    ss.subspec 'Controller' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByOtherPage/Controller/**'
    
      sss.dependency 'MKFilterPagesModule/FilterByOtherPage/Protocol'
      
    end
  
    ss.subspec 'Protocol' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByOtherPage/Protocol/**'
    end
  end
  
  s.subspec 'FilterByPirPage' do |ss|
    ss.subspec 'Controller' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByPirPage/Controller/**'
    
      sss.dependency 'MKFilterPagesModule/FilterByPirPage/Protocol'
      
    end
  
    ss.subspec 'Protocol' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByPirPage/Protocol/**'
    end
  end
  
  s.subspec 'FilterByTofPage' do |ss|
    ss.subspec 'Controller' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByTofPage/Controller/**'
    
      sss.dependency 'MKFilterPagesModule/FilterByTofPage/Protocol'
      
    end
  
    ss.subspec 'Protocol' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByTofPage/Protocol/**'
    end
  end
  
  s.subspec 'FilterByTLMPage' do |ss|
    ss.subspec 'Controller' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByTLMPage/Controller/**'
    
      sss.dependency 'MKFilterPagesModule/FilterByTLMPage/Protocol'
      
    end
  
    ss.subspec 'Protocol' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByTLMPage/Protocol/**'
    end
  end
  
  s.subspec 'FilterByUIDPage' do |ss|
    ss.subspec 'Controller' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByUIDPage/Controller/**'
    
      sss.dependency 'MKFilterPagesModule/FilterByUIDPage/Protocol'
      
    end
  
    ss.subspec 'Protocol' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByUIDPage/Protocol/**'
    end
  end
  
  s.subspec 'FilterByURLPage' do |ss|
    ss.subspec 'Controller' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByURLPage/Controller/**'
    
      sss.dependency 'MKFilterPagesModule/FilterByURLPage/Protocol'
      
    end
  
    ss.subspec 'Protocol' do |sss|
      sss.source_files = 'MKFilterPagesModule/Classes/FilterByURLPage/Protocol/**'
    end
  end
  
      
  s.dependency 'MKBaseModuleLibrary'
  s.dependency 'MKCustomUIModule'
  
  s.dependency 'MLInputDodger'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
