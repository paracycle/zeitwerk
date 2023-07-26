# frozen_string_literal: true
begin
  gem "syntax_tree", ">= 6.0.0"
rescue Gem::LoadError
  warn "Zeitwerk::SyntaxTreeInflector requires the syntax_tree gem, version 6.0.0 or later."
end

module Zeitwerk
  class SyntaxTreeInflector < Inflector
    # @sig (String, String) -> [String]
    def camelize(basename, abspath)
      if File.directory?(abspath)
        super
      else
        index = SyntaxTree.index_file(abspath)
        index.map do |entry|
          next unless [
            SyntaxTree::Index::ModuleDefinition,
            SyntaxTree::Index::ClassDefinition,
            SyntaxTree::Index::ConstantDefinition
          ].include?(entry.class)

          entry.name.to_sym
        end.compact
      end
    end
  end
end
