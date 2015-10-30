Pod::Spec.new do |s|
s.name     = 'Persistent-Settings'
s.version  = '0.1'
s.license  = 'MIT'
s.summary  = "This lets you conveniently store values associated with settings or any small amount of data that needs to be persisted. "
s.homepage = 'http://chrismanahan.com'
s.authors  = { 'Chris Manahan' =>
'chrismanahan.dev@gmail.com' }
s.social_media_url = "https://twitter.com/chrismanahan"
s.source   = { :git => 'https://github.com/chrismanahan/Persistent-Settings.git', :tag => 'master' }
s.source_files = 'Persistent Settings/PersistentSettings/PSTSettings.{h,m}'
end