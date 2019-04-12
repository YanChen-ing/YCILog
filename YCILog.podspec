Pod::Spec.new do |s|
  s.name             = 'YCILog'
  s.version          = '0.1.0'
  s.summary          = '日志收集上报。支持目标地扩展，崩溃收集，无埋点追踪'

  s.description      = <<-DESC
  日志组件
  1.支持分级调试日志
  2.支持全埋点式操作，业务日志收集
  3.支持移动平台目的地，并可扩展收集到目的地
  4.崩溃日志收集
                       DESC

  s.homepage         = 'https://github.com/YanChen-ing/YCILog'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'YanChen-ing' => 'workforyc@163.com' }
  s.source           = { :git => 'https://github.com/YanChen-ing/YCILog.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.swift_version = '4.1'
  
  s.subspec 'Core' do |ss|

    ss.dependency 'YCIDeviceId'
    
    ss.source_files = 'YCILog/Core'
  end
  
  s.subspec 'AutoTrack' do |ss|
    
    ss.dependency 'YCILog/Core'
    
    ss.source_files = 'YCILog/AutoTrack'
  end
  
  s.subspec 'CrashReporter' do |ss|
    
    ss.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO'}
    
    ss.ios.vendored_frameworks = 'YCILog/CrashReporter/CrashReporter.framework'
    
    ss.dependency 'YCILog/Core'
    
    ss.source_files = 'YCILog/CrashReporter/*.{swift,h,m}'
  end
  
  s.subspec 'Destinations' do |ss|
    
    ss.dependency 'YCILog/Core'
    
    ss.source_files = 'YCILog/Destinations'
  end
  

end
