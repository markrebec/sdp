require 'etc'
require 'sdp/description_field'

class SDP::DescriptionFields
  class OriginField < SDP::DescriptionField

    # TODO: The origin <username> MUST NOT contain spaces.
    # TODO: Its
    #      usage is up to the creating tool, so long as <sess-version> is
    #      increased when a modification is made to the session data.  Again,
    #      it is RECOMMENDED that an NTP format timestamp is used.
    def initialize value=nil
      @sdp_type = 'o'
      @ruby_type = :origin
      @required = true

      @value = {
        :username => Etc.getlogin,
        :session_id => Time.now.to_i,
        :session_version => Time.now.to_i,
        :net_type => :IN,
        :address_type => :IP4,
        :unicast_address => get_local_ip
      }

      unless value.nil?
        super
        map_values
      end
    end

    # Redefines value assingment to allow for changing parameters separately.
    #
    # @param [Hash] new_value Key must be an existing @value key or pair.
    def value=(new_value)
      @value.each_pair do |k,v|
        if new_value.has_key?(k)
          @value[k] = new_value[k]
        end
      end
    end

    # If a values string was passed in, the parent class broken those up
    # to an Array.  This maps those values to the value Hash.
    def map_values
      @value[:username]         = @parsed_values[0]
      @value[:session_id]       = @parsed_values[1]
      @value[:session_version]  = @parsed_values[2]
      @value[:net_type]         = @parsed_values[3]
      @value[:address_type]     = @parsed_values[4]
      @value[:unicast_address]  = @parsed_values[5]
    end
    
    # Gets current local IP address.
    # 
    # @return [String] The IP address as a String.
    def get_local_ip
      orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

      UDPSocket.open do |s|
        s.connect '74.125.224.17', 1
        s.addr.last
      end
    ensure
      Socket.do_not_reverse_lookup = orig
    end
  end
end
