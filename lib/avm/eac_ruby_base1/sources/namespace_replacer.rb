# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class NamespaceReplacer
        TAB = '  '

        common_constructor :from, :to

        def concat_regex(regexes)
          r = regexes.first
          regexes[1..].each do |x|
            r = ::Regexp.new(r.source + x.source)
          end
          r
        end

        def from_result
          /\n#{from_open.source}(.+)#{from_close.source}/m
        end

        def from_open
          concat_regex(from.split('::')
            .map { |v| / *(?:class|module) +#{::Regexp.quote(v)} *\n/m })
        end

        def from_close
          concat_regex(from.split('::').count.times.map { / *end *\n/m })
        end

        def to_result
          "\n\n#{to_open}\\1#{to_close}"
        end

        # @return [String]
        def to_open
          s = ''
          to.split('::').each_with_index do |part, index|
            s += tab(index) + "module #{part}\n"
          end
          s
        end

        # @return [String]
        def to_close
          parts = to.split('::')
          s = ''
          parts.each_with_index do |_part, index|
            tabc = (parts.count - 1 - index)
            s += "#{tab(tabc)}end\n"
          end
          s
        end

        protected

        # @param count [Integer]
        # @return [String]
        def tab(count)
          TAB * count
        end
      end
    end
  end
end
