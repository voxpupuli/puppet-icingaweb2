require 'puppet'

Facter.add(:icingaweb2_roles) do
  setcode do

    ini = Hash.new
    cur = String.new
    
    if FileTest.directory?("/etc/icingaweb2")
      confdir = "/etc/icingaweb2"
      if FileTest.exists?("#{confdir}/roles.ini")
        File.open("#{confdir}/roles.ini").each do |line|
          if line =~ /^\s*\[(.*)\]\s*$/
            ini["#{$1}"] = {}
            cur = "#{$1}"
          elsif ! ini.empty? and line =~/^\s*(.+)\s*=\s*(.*)$/
            ini[cur]["#{$1}"] = "#{$2}".tr('"', '').split(%r{\s*,\s*})
          end
        end
        ini
      else
        'true'
      end
    else
      'false'
    end

  end
end
