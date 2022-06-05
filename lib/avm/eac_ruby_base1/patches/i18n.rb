# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'i18n'

::I18n.load_path += __dir__.to_pathname.expand_path.parent_n(4).join('locale').glob('*.yaml')
                      .map(&:to_path)
