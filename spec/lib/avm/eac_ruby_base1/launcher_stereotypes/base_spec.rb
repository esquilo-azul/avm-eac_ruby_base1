# frozen_string_literal: true

require 'avm/eac_ruby_base1/launcher_stereotypes/base'

RSpec.describe ::Avm::EacRubyBase1::LauncherStereotypes::Base do
  describe '#load_gemspec' do
    let(:gemname) { 'avm-tools' }
    let(:self_gemspec) { ::File.join(ROOT_DIR, "#{gemname}.gemspec") }
    let(:stub_gemspec) { ::File.join(DUMMY_DIR, "#{gemname}_stub", "#{gemname}.gemspec") }
    let(:stub_expected_version) { '1.0.0.pre.stub' }

    it 'does not return same version for different gemspecs with same name' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      stub_spec = described_class.load_gemspec(stub_gemspec)
      expect(stub_spec.version).to eq(stub_expected_version)
      expect(stub_spec.name).to eq(gemname)

      self_spec = described_class.load_gemspec(self_gemspec)
      expect(self_spec.version).not_to eq(stub_expected_version)
      expect(self_spec.name).to eq(gemname)
    end
  end
end
