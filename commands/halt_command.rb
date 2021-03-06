require_rel "./commands/command"
require 'tmpdir'
class HaltCommand < Command

	def initialize
		super("halt")
		build_parser
	end

	def execute(str_args)
			
		begin
			@parser.parse(str_args)
			PipelineLink.new.halt(get_key)
			CliWriter::ln "The daisy pipeline 2 WS has been halted"
		rescue Exception => e
			 
			Ctxt.logger.debug(e)
			CliWriter::err "#{e}\n\n"
			puts help
                        return -1
		end
                return 0
	end
	def help
		return @parser.help
	end
	def to_s
		return "#{@name}\t\t\t\tStops the WS"	
	end
	def build_parser
		@parser=OptionParser.new 
		@parser.banner="#{Ctxt.conf[Conf::PROG_NAME]} "+ @name 
	end

	def get_key
		keyfile=Dir.tmpdir+File::SEPARATOR+"dp2key.txt"
		key=0
		File.open(keyfile, "r") do |infile|
			key=infile.gets
		end
		return key	
	end
		
end
