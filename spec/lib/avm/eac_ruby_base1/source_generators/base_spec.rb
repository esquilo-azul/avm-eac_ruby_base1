# frozen_string_literal: true

require 'avm/tools/runner'

RSpec.describe ::Avm::EacRubyBase1::SourceGenerators::Base do
  let(:targets_root) { ::Pathname.new('base_spec_files').expand_path(__dir__) }

  %w[mygem dashed-mygem].each do |gem_name|
    context "when runner is executed for #{gem_name}" do
      let(:target_dir) { targets_root.join(gem_name) }
      let(:temp_dir) { ::EacRubyUtils::Fs::Temp.directory }
      let(:gem_path) { temp_dir.join(gem_name) }
      let(:argv) do
        %w[ruby gems generate --eac-ruby-utils-version=0.35.0
           --eac-ruby-gem-support-version=0.2.0] + [gem_path.to_path]
      end

      before do
        ::Avm::Tools::Runner.run(argv: argv)
      end

      after do
        temp_dir.remove
      end

      it do
        expect(directory_to_h(gem_path)).to eq(directory_to_h(target_dir))
      end
    end
  end

  def directory_to_h(dir)
    dir.children.map do |child|
      [child.basename.to_path, fs_object_to_h(child)]
    end.to_h
  end

  def fs_object_to_h(obj)
    if obj.file?
      file_to_h(obj)
    elsif obj.directory?
      directory_to_h(obj)
    else
      raise "Unknown filesystem object \"#{obj}\""
    end
  end

  def file_to_h(file)
    return "TRUNCATED\n" if file.basename.to_path == 'Gemfile.lock'

    file.read
  end
end
