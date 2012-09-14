require_rel "./commands/id_based_command"

class DeleteCommand < IdBasedCommand 

	def initialize
		super("delete")
		build_parser
	end

	def execute(str_args)
			
		begin
			getId!(str_args)	
			res=PipelineLink.new.delete_job(@id)
			str="The job wasn't deleted"
			if res 
				str="Job #{@id} has been deleted\n" 
				str+= "\n"
			end
			CliWriter::ln str
		rescue Exception => e
			 
			Ctxt.logger.debug(e)
			CliWriter::err "#{e}\n\n"
			puts to_s 
		end
	end
	def help
		return @parser.help
	end
	def to_s
		return "#{@name}\t\t\t\tDeletes a job"	
	end
	def build_parser

		@parser=OptionParser.new do |opts|
			addLastId(opts)
		end
		@parser.banner="dp2 "+ @name + " JOBID"
	end
end
