# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{subprocess}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bram Swenson"]
  s.date = %q{2010-03-14}
  s.description = %q{* Subprocess provides a clean wrapper class around the Kernel.exec method.}
  s.email = ["bram@craniumisajar.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = [".README.rdoc.swp", "History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "features/development.feature", "features/popen.feature", "features/step_definitions/common_steps.rb", "features/step_definitions/popen_steps.rb", "features/support/common.rb", "features/support/env.rb", "features/support/matchers.rb", "lib/subprocess.rb", "lib/subprocess/.popen.rb.swp", "lib/subprocess/popen.rb", "script/console", "script/destroy", "script/generate", "spec/spec.opts", "spec/spec_helper.rb", "spec/subprocess/popen_spec.rb", "spec/subprocess_spec.rb", "tasks/rspec.rake"]
  s.homepage = %q{http://github.com/bramswenson/subprocess}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{subprocess}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{* Subprocess provides a clean wrapper class around the Kernel.exec method.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>, [">= 2.0.0.beta.3"])
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<gemcutter>, [">= 0.5.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.5.0"])
    else
      s.add_dependency(%q<rspec>, [">= 2.0.0.beta.3"])
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<gemcutter>, [">= 0.5.0"])
      s.add_dependency(%q<hoe>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.0.0.beta.3"])
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<gemcutter>, [">= 0.5.0"])
    s.add_dependency(%q<hoe>, [">= 2.5.0"])
  end
end
