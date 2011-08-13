module Munger
  def self.munge(options={})
    content = Munger.raw_or_path(options, :content, :content_path)
    input = Munger.raw_or_path(options, :input, :input_path)
    munge = Munger::Munge.new(options)
    output = munge.run(input, content)
    Munger.raw_or_path(options, :output, :output_path, output)
  end

  class Munge
    OPTIONS = [:mode, :pattern, :tag, :content, :content_path, :input,
               :input_path, :output, :output_path, :path, :verbose]
    attr_accessor *(OPTIONS + [:start_tag, :end_tag])

    def initialize(options)
      self.mode = options[:mode] || :append
      self.pattern = Regexp.compile(options[:pattern]) unless mode == :append
      self.tag = options[:tag] || ''
      self.verbose = options[:verbose]

      if verbose
        settings = OPTIONS.map {|attr| "#{attr} = #{eval "#{attr}.inspect"}" }
        puts settings.join(', ')
      end
    end

    def run(input, content)
      startTag = tag + " (munge start)"
      endTag = tag + " (munge end)"
      content = [startTag, content.rstrip, endTag].join("\n")

      result = []
      skipping = nil
      needMatch = [:before, :replace, :after, :replace_or_append].include? mode
      input.split("\n").each do |l|
        if skipping
          if l == endTag
            puts "Done skipping: #{l}" if verbose
            skipping = nil
            if [:replace, :replace_or_append].include?(mode)
              puts "Inserting content" if verbose
              result << content
            end
          else
            puts "Skipping: #{l}" if verbose
          end
        elsif l == startTag
          puts "Start skipping: #{l}" if verbose
          skipping = true
          needMatch = nil
        else
          matched = needMatch && pattern.match(l)
          if mode == :before && matched
            puts "Matched (before): inserting before #{l}" if verbose
            result << content
            needMatch = nil
          end
          if [:replace, :replace_or_append].include?(mode) && matched
            puts "Matched (#{mode}): replacing #{l}" if verbose
            result << content
            needMatch = nil
          else
            puts "Using existing line #{l}" if verbose
            result << l
          end
          if mode == :after && matched
            puts "Matched (after): inserting after #{l}" if verbose
            result << content
            needMatch = nil
          end
        end
      end

      if mode == :append or (mode == :replace_or_append && needMatch)
        puts "Appending..." if verbose
        result << content
      end

      result << "" # make sure we end with a newline
      result.join("\n")
    end
  end

private
  def self.raw_or_path(options, raw_sym, path_sym, data_to_write=nil)
    raw_value = options.delete(raw_sym)
    path = options.delete(path_sym)
    path ||= options[:path]
    if data_to_write # we're writing
      if path == '-'
        STDOUT.write(data_to_write)
      elsif path
        File.open(path, 'w') {|f| f.write(data_to_write) }
      else
        data_to_write # just return it.
      end
    else # we're reading
      if raw_value
        raw_value
      elsif path == '-'
        STDIN.read
      else
        File.read(path)
      end
    end
  end
end
