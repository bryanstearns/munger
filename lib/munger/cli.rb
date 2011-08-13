require 'rubygems'
require 'ruby-debug'
require 'optparse'

module Munger
  class CLI
    def self.run!(*args)
      return self.new(*args).run
    end

    def initialize(*args)
      @args = args
      parse_args
    end

    def parse_args
      @content = OptionParser.new do |opts|
        opts.banner = "Usage: munge <options> CONTENT"
        opts.on("--before PATTERN", "Insert before the line matching PATTERN") {|@pattern| set_mode(:before) }
        opts.on("--after PATTERN", "Insert after the line matching PATTERN") {|@pattern| set_mode(:after) }
        opts.on("--replace PATTERN", "Replace the line matching PATTERN") {|@pattern| set_mode(:replace) }
        opts.on("--append", "Append to the file") { set_mode(:append) }
        opts.on("--replace-or-append PATTERN", "Replace the line matching PATTERN, or append if not found") {|@pattern| set_mode(:replace_or_append) }

        opts.on("--tag TAG", "Mark our insertion with this TAG") {|@tag|}
        opts.on("--input INPUT", "The filename to read; '-' for stdin") \
                {|@input_path|}
        opts.on("--output OUTPUT", "The filename to write; '-' for stdout") {|@output_path|}
        opts.on("--content CONTENT", "A file from which to read the content to insert; '-' for stdin") \
                {|@content_path|}
        opts.on("-v", "--verbose", "Increase verbosity") {|@verbose|}
      end.parse!(@args).first

      set_mode(:append) unless @mode
      abort "No --input path specified" unless @input_path
      abort "No --output path specified" unless @output_path
      abort "Can't specify --content with CONTENT" if (@content != nil && @content_path != nil)
      abort "No content specified" unless (@content || @content_path)

      @options = Munger::Munge::OPTIONS.inject({}) do |h, option|
        h[option] = instance_variable_get("@#{option}") rescue nil
        h
      end
    end

    def run
      Munger::munge(@options)
    end

    def set_mode(new_mode)
      abort("Only one --before|--after|--replace|--append allowed") if @mode
      @mode = new_mode
    end
  end
end
