
class SVNHelper
  
  attr_accessor :revision, :date, :last_changed, :info
 
  def initialize(info)
    @revision         = info[:revision] 
    @date             = Time.parse(info[:last_changed_date])
    @last_changed     = info[:last_changed_rev]
    @info             = info
  end
  alias rev revision
  
 #  mac$ svn info
 #  Path: .
 #  URL: svn+ssh://server/path/to/repo
 #  Repository Root: svn+ssh://server/code/repo
 #  Repository UUID: 92465c46-2311-0410-8e48-c621c597944e
 #  Revision: 6864
 #  Node Kind: directory
 #  Schedule: normal
 #  Last Changed Author: wsk
 #  Last Changed Rev: 6845
 #  Last Changed Date: 2009-07-17 11:02:20 +0800 (Fri, 17 Jul 2009)
 #  
 
  MARKERS = {
    :url                  => 'URL',
    :repository_root      => 'Repository Root',
    :repository_uuid      => 'Repository UUID',
    :revision             => 'Revision',
    :node_kind            => 'Node Kind',
    :schedule             => 'Schedule',
    :last_changed_author  => 'Last Changed Author',
    :last_changed_rev     => 'Last Changed Rev',
    :last_changed_date    => 'Last Changed Date'
  }
  
  def self.version(root)
    raise "Specified Application root: #{root} does not exist, can not get the revision information." unless File.exists?(root)
    begin 
      #get the return result of command: svn info
      svn_info = %x{svn info #{root}} 
      info = {}
      MARKERS.each do |name, mark| 
        line = svn_info.match(/^#{mark}:\s(.*)/)
        info[name] = line[1]
      end
      version = self.new(info) 
    rescue
      # in case of a change of svn info command or the application is not using svn, just return 'no_svn' and we will look back here.
      version = self.new({:revision=>'NO_SVN'})     
    end
   
   version.freeze
   
 end
 
 def to_s
   rev
 end
 def rev_with_date
   %{#{rev} [#{date.strftime("%y%m%d.%H%M%S")}]}
 end
 
end  
