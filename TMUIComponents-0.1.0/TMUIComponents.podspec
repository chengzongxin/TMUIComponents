Pod::Spec.new do |s|
  s.name = "TMUIComponents"
  s.version = "0.1.0"
  s.summary = "A short description of TMUIComponents."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"chengzongxin"=>"joe.cheng@corp.to8to.com"}
  s.homepage = "https://github.com/chengzongxin/TMUIComponents"
  s.description = "TODO: Add long description of the pod here."
  s.source = { :path => '.' }

  s.ios.deployment_target    = '10.0'
  s.ios.vendored_framework   = 'ios/TMUIComponents.framework'
end
