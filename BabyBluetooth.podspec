Pod::Spec.new do |s|  
  s.name             = "BabyBluetooth"  
  s.version          = "0.0.0"  
  s.license          = 'MIT'  
  s.summary          = "bluetooth library on iOS."  
  s.description      = <<-DESC  
                       The easiest way to use Bluetooth (BLE )in ios,even bady can use . 一个非常容易使用的蓝牙库。  

  s.homepage         = "https://github.com/coolnameismy/BabyBluetooth"  
  # s.screenshots      = "", ""  
 
  s.author           = { "王中周" => "wzzvictory_tjsd@163.com" }  
  s.source           = { :git => "https://github.com/wangzz/WZMarqueeView.git", :tag => s.version.to_s }  
  # s.social_media_url = 'https://twitter.com/NAME'  
  
  # s.platform     = :ios, '6.0'  
  s.ios.deployment_target = '6.0'  
  # s.osx.deployment_target = '10.7'  
  s.requires_arc = true  
  
  s.source_files = 'BabyBluetooth/BabyBluetooth.h'
  s.public_header_files = 'BabyBluetooth/*.h'
  # s.resources = 'Assets'  

  # s.ios.exclude_files = 'Classes/osx'  
  # s.osx.exclude_files = 'Classes/ios'  
  # s.public_header_files = 'Classes/**/*.h'  
  # s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'  
  
end 