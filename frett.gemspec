# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{frett}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["johannes-kostas goetzinger"]
  s.date = %q{2012-07-03}
  s.description = %q{the goal of frett is to provide a much quicker search functionality than ack on large projects.
it's built on top of the 'ferret' and 'listen' gems.}
  s.email = ["dbldots@gmail.com"]
  s.executables = ["frett", "frett_service"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "bin/frett", "bin/frett_service", "lib/frett.rb", "lib/frett/adapter.rb", "lib/frett/cli.rb", "lib/frett/config.rb", "lib/frett/indexer.rb", "lib/frett/search.rb", "script/console", "test/test_frett.rb", "test/test_frett_cli.rb", "test/test_helper.rb", ".gemtest"]
  s.homepage = %q{http://github.com/dbldots/frett}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{frett}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{the goal of frett is to provide a much quicker search functionality than ack on large projects}
  s.test_files = ["test/test_frett.rb", "test/test_frett_cli.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<daemons>, [">= 1.1.8"])
      s.add_runtime_dependency(%q<ferret>, [">= 0.11.8.4"])
      s.add_runtime_dependency(%q<listen>, [">= 0.4.7"])
      s.add_runtime_dependency(%q<ptools>, [">= 1.2.2"])
      s.add_runtime_dependency(%q<colorize>, [">= 0.5.8"])
      s.add_runtime_dependency(%q<mime-types>, [">= 1.19"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_development_dependency(%q<newgem>, [">= 1.5.3"])
      s.add_development_dependency(%q<hoe>, ["~> 3.0"])
    else
      s.add_dependency(%q<daemons>, [">= 1.1.8"])
      s.add_dependency(%q<ferret>, [">= 0.11.8.4"])
      s.add_dependency(%q<listen>, [">= 0.4.7"])
      s.add_dependency(%q<ptools>, [">= 1.2.2"])
      s.add_dependency(%q<colorize>, [">= 0.5.8"])
      s.add_dependency(%q<mime-types>, [">= 1.19"])
      s.add_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_dependency(%q<newgem>, [">= 1.5.3"])
      s.add_dependency(%q<hoe>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<daemons>, [">= 1.1.8"])
    s.add_dependency(%q<ferret>, [">= 0.11.8.4"])
    s.add_dependency(%q<listen>, [">= 0.4.7"])
    s.add_dependency(%q<ptools>, [">= 1.2.2"])
    s.add_dependency(%q<colorize>, [">= 0.5.8"])
    s.add_dependency(%q<mime-types>, [">= 1.19"])
    s.add_dependency(%q<rdoc>, ["~> 3.10"])
    s.add_dependency(%q<newgem>, [">= 1.5.3"])
    s.add_dependency(%q<hoe>, ["~> 3.0"])
  end
end
