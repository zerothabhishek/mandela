module Mandela
  module Utils

    def self.log(klass, action, *args)

      suffix = if action
        "#{klass} #{action}"
      else
        "#{klass}"
      end

      width = 25

      if suffix.size >= 25
        parts = suffix.split(" ")
        suffix = parts[0..-2].join(" ")
        args.unshift(parts[-1])
      end

      suffix = "[#{suffix}]"
      suffix = sprintf("%-#{width}s", suffix)

      str = ([suffix] + args).join(' ')
      puts str
    end
  end
end