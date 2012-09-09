require_rel "core/client"
class ClientCreateCommand < Command

	def initialize
		super("create")
		@client=Client.new
		build_parser
	end
	def execute(str_args)

			
		begin
			@parser.parse(str_args)
			Ctxt.logger.debug("client #{@client.to_s}")
			client=AdminLink.new.createClient(@client)
			str="[DP2] Client succesfully created\n#{client}\n"	
			puts str
		rescue Exception => e
			 
			Ctxt.logger.debug(e)
			puts "\n[DP2] ERROR: #{e.message}\n\n"

			puts to_s 
		end
	end
	def help
		return @parser.help
	end
	def to_s
		return "#{@name}\t\t\t\tShows the detailed status for a single job"	
	end
	def build_parser
		
		@parser=OptionParser.new do |opts|
			opts.on("-i CLIENTID","--id CLIENTID","Client id") do |v|
				@client.id =v
			end
			opts.on("-r ROLE","--role ROLE",Client::ROLES,Client::ROLES,"Client role") do |v|
				@client.role=v
			end
			opts.on("-c CONTACT","--contact CONTACT","Client contact e-mail") do |v|
				@client.contact=v
			end
			opts.on("-s SECRET","--secret SECRET","Client secret") do |v|
				@client.secret=v
			end
		end
		@parser.banner="dp2admin "+ @name + " [options] "
	end
end
