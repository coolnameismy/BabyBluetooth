Pod::Spec.new do |s|


  s.name         = "BabyBluetooth"
  s.version      = "0.3.0"
  s.summary      = "bluetooth library on ios/osx"

  s.description  = <<-DESC
                   he easiest way to use Bluetooth (BLE)in ios,even bady can use . 一个非常容易使用的蓝牙库.
                   DESC

  s.homepage     = "https://github.com/coolnameismy/BabyBluetooth"
  # s.screenshots  = "http://images.jumppo.com/uploads/BabyBluetooth_logo.png", ""

  s.license      = "MIT" 
  s.author             = { "liuyanwei" => "coolnameismy@hotmail.com" }
  s.source       = { :git => "https://github.com/coolnameismy/BabyBluetooth.git", :tag => "0.3.0" }

  s.platform     = :ios, "7.0"
  s.requires_arc = true
  
  s.source_files  = "Classes", "Classes/objc/*.{h,m}"

end
