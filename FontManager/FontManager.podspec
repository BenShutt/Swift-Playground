Pod::Spec.new do |s|
  s.name = 'FontManager'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Simplify font management in iOS apps'
  s.homepage = 'https://github.com/BenCShutt/FontManager'
  s.authors = { 'Ben Shutt' => 'shuttbenjamin@gmail.com' }
  s.source = { :git => 'https://github.com/BenCShutt/FontManager.git', :tag => s.version }
  s.documentation_url = s.homepage

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.3']
  s.source_files = 'Sources/**/*.swift'
end
