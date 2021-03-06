require_rel "./commands/id_based_command"

class JobCommand < IdBasedCommand

	def initialize
		super("status")
		@showMsgs=false
		@showRes=false
		build_parser
	end
	def execute(str_args)
			
		begin
			getId!(str_args)	
			raise RuntimeError,"JOBID is mandatory" if @id.empty?
			job=PipelineLink.new.job_status(@id,0)
			str="No such job"
			if job != nil 
				str="Job Id:#{job.id}\n" 
				
				str+="\t Name: #{job.nicename}\n" if job.nicename!=nil
				str+="\t Status: #{job.status}\n" 
				str+="\t Priority: #{job.priority}\n" 
				str+="\t Script: #{job.script.id}\n"
				job.messages.each{|msg| str+=msg.to_s+"\n"} if @showMsgs
				str+=job.results.to_s if @showRes

				str+= "\n"
			end
			CliWriter::ln str
		rescue Exception => e
			 
			Ctxt.logger.debug(e)
			CliWriter::err "#{e.message}\n\n"

			puts help 
                        return -1
		end
                return 0
	end
	def help
		return @parser.help
	end
	def to_s
		return "#{@name}\t\t\t\tShows the detailed status for a single job"	
	end
	def build_parser

		@parser=OptionParser.new do |opts|
			opts.on("-v","Shows the job's log messages") do |v|
				@showMsgs=true
			end
			opts.on("-r","Shows the job's detailed result description") do |v|
				@showRes=true
			end
			addLastId(opts)
		end
		@parser.banner="#{Ctxt.conf[Conf::PROG_NAME]} "+ @name + " [options] JOBID"
	end
end
