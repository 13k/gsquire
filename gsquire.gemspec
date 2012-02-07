# encoding: utf-8

$:.push File.expand_path("../lib", __FILE__)

require "gsquire/version"

Gem::Specification.new do |s|
  s.name        = "gsquire"
  s.version     = GSquire::VERSION
  s.authors     = ["Kiyoshi '13k' Murata"]
  s.email       = ["13k@linhareta.net"]
  s.homepage    = "http://commita.com/community"
  s.summary     = %q{A commandline and library squire to look for thy lordly Google Tasks.}
  s.description = %q{Back in the Age of Heroes, GSquire would carry thy armor
    and sword, would get thy lordship dressed and accompany in battle. He would
    fight side by side with those who stood brave against the toughest of the
    foes. These were good times to be alive.

    Then a swift, strange, wind blew upon this land and everything we knew was
    washed away and replaced by something new. All we used to know about
    living, eating, singing and smiling was made anew. Not everyone could
    handle that, many were forced into this. Those who were born during this
    time, never knew how was the world before.

    Some received this wind as a blessing from gods, others deemed it cursed.
    The only agreement was in calling it Web 2.0.}

  s.add_dependency 'oauth2', '~> 0.5.0'
  s.add_dependency 'thor', '~> 0.14.6'
  s.add_dependency 'hashie', '~> 1.1.0'

  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'awesome_print'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
