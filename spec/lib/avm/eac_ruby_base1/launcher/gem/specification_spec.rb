# frozen_string_literal: true

RSpec.describe ::Avm::EacRubyBase1::Launcher::Gem::Specification do
  let(:gemspec_file) { ::File.join(DUMMY_DIR, 'ruby_gem_stub', 'ruby_gem_stub.gemspec') }
  let(:instance) { described_class.new(gemspec_file) }

  describe '#parse_version_file' do
    it 'parses valid version file' do # rubocop:disable RSpec/MultipleExpectations
      file = ::File.join(DUMMY_DIR, 'ruby_gem_stub', 'lib', 'ruby_gem_stub', 'version.rb')
      expect(::File.exist?(file)).to eq true
      version = described_class.parse_version_file(file)
      expect(version).to eq('1.0.0.pre.stub')
    end

    it 'does not parse invalid version file' do # rubocop:disable RSpec/MultipleExpectations
      file = __FILE__
      expect(::File.exist?(file)).to eq true
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
