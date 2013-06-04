class TemplatesParser
  def initialize(files)
    @files = files
  end

  def keys
    keys = @files.map do |template|
      file    = File.basename(template).gsub /^_?(.+?)\..+$/, '\1'
      dir     = template.split('/')[-2]
      context = "#{dir}.#{file}"

      File.readlines(template).map { |line| line_keys(line, context) }
    end

    keys.compact.flatten.compact.uniq
  end

  private

  def locale
    'pl'.freeze
  end

  def line_keys(line, context)
    line.scan(/\W+t(ranslate)?\s*\(?['"]([^#]+?)['"]/i).map do |m|
      arg = m[1]
      if arg != '.'
        arg[0] == '.' ? "#{locale}.#{context}#{arg}" : "#{locale}.#{arg}"
      end
    end
  end
end
