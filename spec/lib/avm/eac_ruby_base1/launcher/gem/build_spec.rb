# frozen_string_literal: true

require 'active_support/core_ext/object'
require 'avm/eac_ruby_base1/launcher/gem/build'

RSpec.describe ::Avm::EacRubyBase1::Launcher::Gem::Build do
  describe '#output_file' do
    let(:gem_dir) do
      avm_eac_ruby_base1_source(target_path: temp_dir.join('ruby_gem_stub'))
        .path.to_path
    end

    it 'builds .gem file' do # rubocop:disable RSpec/ExampleLength
      expect(::File.directory?(gem_dir)).to eq true
      build = described_class.new(gem_dir)

      # Open/close
      assert_closed(build)
      build.build
      assert_open(build)
      build.close
      assert_closed(build)

      # Reopen/reclose
      build.build
      assert_open(build)
      build.close
      assert_closed(build)
    end

    private

    def assert_closed(build)
      expect(build.output_file.blank?).to eq true
      expect(build.builded?).to eq false
    end

    def assert_open(build) # rubocop:disable Metrics/AbcSize
      expect(build.output_file.present?).to eq true
      expect(build.builded?).to eq true
      expect(::File.exist?(build.output_file)).to eq true
      expect(::File.size(build.output_file)).to be_positive
      expect(::File.basename(build.output_file)).to eq('ruby_gem_stub-0.0.0.gem')
    end
  end
end
