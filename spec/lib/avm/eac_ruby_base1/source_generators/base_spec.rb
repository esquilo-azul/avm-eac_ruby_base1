# frozen_string_literal: true

require 'avm/eac_ruby_base1/source_generators/base'
require 'avm/source_generators/runner'

RSpec.describe ::Avm::EacRubyBase1::SourceGenerators::Base do
  let(:targets_root) { ::Pathname.new('base_spec_files').expand_path(__dir__) }

  %w[mygem dashed-mygem].each do |gem_name|
    context "when runner is executed for #{gem_name}" do
      let(:stereotype) { 'EacRubyBase1' }
      let(:target_dir) { targets_root.join(gem_name) }
      let(:temp_dir) { ::EacRubyUtils::Fs::Temp.directory }
      let(:gem_path) { temp_dir.join(gem_name) }
      let(:argv) do
        %w[--option eac-ruby-utils-version:0.35.0 --option eac-ruby-gem-support-version:0.2.0] +
          [stereotype, gem_path.to_path]
      end

      before do
        ::Avm::SourceGenerators::Runner.run(argv: argv)
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
      [fs_object_basename(child), fs_object_to_h(child)]
    end.to_h
  end

  # @return [String]
  def fs_object_basename(obj)
    r = obj.basename.to_path
    r = '.gitignore' if r == '_gitignore'
    r
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
