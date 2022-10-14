# frozen_string_literal: true

require 'avm/launcher/context'
require 'avm/launcher/instances/base'
require 'avm/eac_ruby_base1/launcher_stereotypes/base/publish'

RSpec.describe ::Avm::EacRubyBase1::LauncherStereotypes::Base::Publish do
  let(:context) do
    r = temp_launcher_context
    avm_eac_ruby_base1_source(target_path: r.root.real.to_pathname.join('ruby_gem_stub'))
    r
  end

  describe '#publish' do
    let(:instance) { context.instance('/ruby_gem_stub') }

    it 'dries run publish for Ruby Gems' do
      allow_any_instance_of(described_class).to receive(:gem_versions_uncached).and_return([]) # rubocop:disable RSpec/AnyInstance
      expect(instance).to be_a ::Avm::Launcher::Instances::Base
      context.publish_options = { confirm: false, new: true, stereotype: 'RubyGem' }
      described_class.new(instance).run
    end
  end
end
