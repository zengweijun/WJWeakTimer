

Pod::Spec.new do |s|

  s.name         = "WJWeakTimer" 
  s.version      = "0.0.2"       
  s.license      = "MIT"          
  s.summary      = "WJWeakTimer是一个避免循环引用的Timer组件.包含NSTimer、CGDTimer和CADisplayLink的封装" 

  s.homepage     = "https://github.com/ZengWeiJun/WJWeakTimer"
  s.source       = { :git => "https://github.com/ZengWeiJun/WJWeakTimer.git", :tag => s.version }
  s.source_files = "WJWeakTimer/Classes/**/*" 
  s.requires_arc = true 
  s.platform     = :ios, "8.0" 

  # s.frameworks   = "UIKit", "Foundation"
  
  # User
  s.author           = { '曾维俊' => 'niuszeng@163.com' }
  s.social_media_url   = "https://github.com/ZengWeiJun"

end
