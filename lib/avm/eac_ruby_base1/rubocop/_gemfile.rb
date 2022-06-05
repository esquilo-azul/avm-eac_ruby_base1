# frozen_string_literal: true

require 'avm/patches/eac_ruby_gems_utils/gem'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacRubyBase1
    class Rubocop
      def gemfile_rubocop_command
        return nil unless rubocop_gemfile?

        rubocop_command_by_gemfile_path(mygem.root)
      end

      def rubocop_command_by_gemfile_path(path)
        ::EacRubyGemsUtils::Gem.new(path).bundle('exec', 'rubocop').chdir_root
      end

      def rubocop_gemfile?
        return false if mygem.blank?

        mygem.bundle('install').execute!
        mygem.gemfile_lock_gem_version('rubocop').present?
      end

      private

      def mygem_uncached
        find_gem(::Pathname.new(base_path).expand_path)
      end

      def find_gem(path)
        r = ::EacRubyGemsUtils::Gem.new(path)
        return r if r.gemfile_path.exist?
        return find_gem(path.dirname) unless path.root?
      end
    end
  end
end
