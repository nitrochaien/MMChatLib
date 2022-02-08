Pod::Spec.new do |s|
  s.name = 'MMChatLib'
  s.version = '0.0.14'
  s.license = 'GNU'
  s.summary = 'Custom Mattermost chat framework for Grooo.'
  s.homepage = 'https://grooo.vn/'
  s.authors = { 'NamDV' => 'namdv@hiworld.com.vn' }
  s.source = { :git => 'https://git.grooo.vn/mattermost/ioschatlib.git', :tag => s.version }
  s.documentation_url = 'https://git.grooo.vn/mattermost/ioschatlib/'

  s.ios.deployment_target = '13.0'

  s.swift_versions = ['5.1', '5.2', '5.3', '5.4', '5.5']
  s.source_files  = "MMChatLib/**/*.swift", "MMChatLib/**/**/*.swift"
end
