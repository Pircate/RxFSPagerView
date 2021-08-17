
Pod::Spec.new do |s|
  s.name             = 'RxFSPagerView'
  s.version          = '0.2.1'
  s.summary          = 'A short description of RxFSPagerView.'
  s.homepage         = 'https://github.com/Pircate/RxFSPagerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pircate' => 'gao497868860@163.com' }
  s.source           = { :git => 'https://github.com/Pircate/RxFSPagerView.git', :tag => s.version.to_s }
  s.swift_version = '5.2'
  s.ios.deployment_target = '10.0'
  s.source_files = 'RxFSPagerView/Classes/**/*'
  s.dependency 'RxCocoa'
end
