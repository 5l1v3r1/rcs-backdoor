#
# Configuration parser
#

# RCS::Common
require 'rcs-common/trace'
require 'rcs-common/crypt'

module RCS
  
class Config
  include Crypt
  include RCS::Tracer
  @content = ""
  
  def initialize(backdoor, buff)
    @backdoor = backdoor
    @content = buff
    trace :info, "Configuration size is #{@content.length}"
  end
  
  def dump_to_file
    
    # dump the configuration still encrypted
    str = './' + @backdoor.id + "_config.enc"
    f = File.new(str, File::CREAT | File::TRUNC | File::RDWR, 0644)
    f.write @content
    f.close
    trace :debug, str + " created."
    
    # dump the configuration in clear
    str = './' + @backdoor.id + "_config.dec"
    f = File.new(str, File::CREAT | File::TRUNC | File::RDWR, 0644)
    f.write aes_decrypt(@content, @backdoor.conf_key)
    f.close
    trace :debug, str + " created."
    
  end
  
end

end # RCS::
