# frozen_string_literal: true

require 'avm/eac_ruby_base1/file_formats/base'

::RSpec.describe ::Avm::EacRubyBase1::FileFormats::Base do
  include_examples 'avm_file_formats_with_fixtures', __FILE__
  include_examples 'avm_file_format_file_resource_name', {
    'app/models/mynamespace/the_class.rb' => 'Mynamespace::TheClass',
    'lib/ruby/lib/cliutils/eac_redmine_base0/activity.rb' => 'Cliutils::EacRedmineBase0::Activity',
    'a_non_library_file.rb' => 'a_non_library_file.rb'
  }
end
