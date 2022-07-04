# frozen_string_literal: true

require 'avm/eac_ruby_base1/sources/base'

::RSpec.describe ::Avm::EacRubyBase1::Sources::Base do
  let(:mygem_path) { ::Pathname.new(__dir__).join('bundler_spec_files', 'mygem') }
  let(:mygem) { described_class.new(mygem_path) }

  describe '#bundle' do
    specify do
      expect(mygem.bundle('exec', 'myrunner').execute!).to include('My Runner')
    end
  end

  describe '#rake' do
    specify do
      expect(mygem.rake('mygem:stub').execute!).to include('Stub!')
    end
  end
end
