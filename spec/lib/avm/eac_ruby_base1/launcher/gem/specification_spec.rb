# frozen_string_literal: true

require 'avm/eac_ruby_base1/launcher/gem/specification'

RSpec.describe Avm::EacRubyBase1::Launcher::Gem::Specification do
  let(:source_version) { '1.0.0.pre.stub' }
  let(:source) do
    r = avm_eac_ruby_base1_source(target_path: temp_dir.join('ruby_gem_stub'))
    r.version = source_version
    r
  end
  let(:gemspec_file) { source.gemspec_path.to_path }
  let(:version_file) { source.version_file.path.to_path }
  let(:instance) { described_class.new(gemspec_file) }

  describe '#parse_version_file' do
    it 'parses valid version file' do # rubocop:disable RSpec/MultipleExpectations
      file = version_file
      expect(File.exist?(file)).to be true
      version = described_class.parse_version_file(file)
      expect(version).to eq('1.0.0.pre.stub')
    end

    it 'does not parse invalid version file' do # rubocop:disable RSpec/MultipleExpectations
      file = __FILE__
      expect(File.exist?(file)).to be true
      version = described_class.parse_version_file(file)
      expect(version).to be_nil
    end
  end

  describe '#name' do
    it 'returns gemspec name' do
      expect(instance.name).to eq('ruby_gem_stub')
    end
  end

  describe '#version' do
    it 'returns gemspec version' do
      expect(instance.version).to eq('1.0.0.pre.stub')
    end
  end

  describe '#full_name' do
    it 'returns gem full name' do
      expect(instance.full_name).to eq('ruby_gem_stub-1.0.0.pre.stub')
    end
  end
end
