# Change Log

## [v2.0.0](https://github.com/Icinga/puppet-icingaweb2/tree/v2.0.0) (2017-04-12)
[Full Changelog](https://github.com/Icinga/puppet-icingaweb2/compare/1.0.6...v2.0.0)

**Implemented enhancements:**

- Add release guide [\#111](https://github.com/Icinga/puppet-icingaweb2/issues/111)
- Add contributing guide [\#109](https://github.com/Icinga/puppet-icingaweb2/issues/109)
- Support icinga2 API command transport [\#74](https://github.com/Icinga/puppet-icingaweb2/issues/74)
- Use RSpec helper rspec-puppet-facts [\#70](https://github.com/Icinga/puppet-icingaweb2/issues/70)
- Support LDAP auth\_backend [\#69](https://github.com/Icinga/puppet-icingaweb2/issues/69)
- Manage icingaweb2 user [\#68](https://github.com/Icinga/puppet-icingaweb2/issues/68)
- Updating graphite with more config [\#66](https://github.com/Icinga/puppet-icingaweb2/issues/66)
- Adding monitoring module [\#65](https://github.com/Icinga/puppet-icingaweb2/issues/65)
- \[dev.icinga.com \#9243\] add ldaps to resource\_ldap.pp [\#56](https://github.com/Icinga/puppet-icingaweb2/issues/56)
- Updating monitoring transports [\#75](https://github.com/Icinga/puppet-icingaweb2/pull/75) ([lazyfrosch](https://github.com/lazyfrosch))
- Update module base [\#73](https://github.com/Icinga/puppet-icingaweb2/pull/73) ([lazyfrosch](https://github.com/lazyfrosch))
- Refactoring repository management [\#72](https://github.com/Icinga/puppet-icingaweb2/pull/72) ([lazyfrosch](https://github.com/lazyfrosch))
- Using rspec-puppet-facts for new spec [\#71](https://github.com/Icinga/puppet-icingaweb2/pull/71) ([lazyfrosch](https://github.com/lazyfrosch))

**Fixed bugs:**

- Fixing config files permissions [\#67](https://github.com/Icinga/puppet-icingaweb2/issues/67)
- \[dev.icinga.com \#11876\] Path for mysql-command is missing [\#60](https://github.com/Icinga/puppet-icingaweb2/issues/60)
- \[dev.icinga.com \#11584\] what is the standard password set by initialize.pp? [\#58](https://github.com/Icinga/puppet-icingaweb2/issues/58)
- \[dev.icinga.com \#11507\] installing icinga web2  [\#57](https://github.com/Icinga/puppet-icingaweb2/issues/57)
- Package managers handle dependencies. [\#87](https://github.com/Icinga/puppet-icingaweb2/pull/87) ([tdb](https://github.com/tdb))
- deployment: Correct directory management [\#76](https://github.com/Icinga/puppet-icingaweb2/pull/76) ([lazyfrosch](https://github.com/lazyfrosch))

**Merged pull requests:**

- Fixing testing issues [\#81](https://github.com/Icinga/puppet-icingaweb2/pull/81) ([lazyfrosch](https://github.com/lazyfrosch))
- Update URLs to GitHub [\#62](https://github.com/Icinga/puppet-icingaweb2/pull/62) ([bobapple](https://github.com/bobapple))
- testing: Updating travis settings [\#51](https://github.com/Icinga/puppet-icingaweb2/pull/51) ([lazyfrosch](https://github.com/lazyfrosch))
- remove dependency on concat module [\#50](https://github.com/Icinga/puppet-icingaweb2/pull/50) ([lbischof](https://github.com/lbischof))
- substituting non existing parameter [\#49](https://github.com/Icinga/puppet-icingaweb2/pull/49) ([attachmentgenie](https://github.com/attachmentgenie))
- Fix permissions [\#30](https://github.com/Icinga/puppet-icingaweb2/pull/30) ([petems](https://github.com/petems))
- Change sql\_schema\_location if using git [\#29](https://github.com/Icinga/puppet-icingaweb2/pull/29) ([petems](https://github.com/petems))

## [1.0.6](https://github.com/Icinga/puppet-icingaweb2/tree/1.0.6) (2015-11-10)
[Full Changelog](https://github.com/Icinga/puppet-icingaweb2/compare/1.0.5...1.0.6)

## [1.0.5](https://github.com/Icinga/puppet-icingaweb2/tree/1.0.5) (2015-08-04)
[Full Changelog](https://github.com/Icinga/puppet-icingaweb2/compare/1.0.4...1.0.5)

## [1.0.4](https://github.com/Icinga/puppet-icingaweb2/tree/1.0.4) (2015-06-24)
[Full Changelog](https://github.com/Icinga/puppet-icingaweb2/compare/1.0.3...1.0.4)

**Merged pull requests:**

- Add support for Scientific Linux in Yum repo [\#16](https://github.com/Icinga/puppet-icingaweb2/pull/16) ([joshbeard](https://github.com/joshbeard))

## [1.0.3](https://github.com/Icinga/puppet-icingaweb2/tree/1.0.3) (2015-05-07)
[Full Changelog](https://github.com/Icinga/puppet-icingaweb2/compare/1.0.2...1.0.3)

## [1.0.2](https://github.com/Icinga/puppet-icingaweb2/tree/1.0.2) (2015-05-07)
[Full Changelog](https://github.com/Icinga/puppet-icingaweb2/compare/1.0.1...1.0.2)

## [1.0.1](https://github.com/Icinga/puppet-icingaweb2/tree/1.0.1) (2015-05-07)
[Full Changelog](https://github.com/Icinga/puppet-icingaweb2/compare/1.0.0...1.0.1)

## [1.0.0](https://github.com/Icinga/puppet-icingaweb2/tree/1.0.0) (2015-05-07)
**Implemented enhancements:**

- \[dev.icinga.com \#9158\] Add module graphite [\#55](https://github.com/Icinga/puppet-icingaweb2/issues/55)
- \[dev.icinga.com \#9153\] Add module businessprocess [\#52](https://github.com/Icinga/puppet-icingaweb2/issues/52)
- Fix authentication configuration [\#8](https://github.com/Icinga/puppet-icingaweb2/pull/8) ([lazyfrosch](https://github.com/lazyfrosch))

**Merged pull requests:**

- Don't put blank host/service filters in roles.ini [\#13](https://github.com/Icinga/puppet-icingaweb2/pull/13) ([jamesweakley](https://github.com/jamesweakley))
- Moving away from templates to usign inifile from Puppetlabs/inifile [\#7](https://github.com/Icinga/puppet-icingaweb2/pull/7) ([smbambling](https://github.com/smbambling))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*