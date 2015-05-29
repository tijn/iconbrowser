require 'memoist'

class IconSet
  extend Memoist
  attr_accessor :name, :path

  def initialize(name, path)
    @name = name
    @path = path
  end

  def to_s
    @name
  end

  memoize def icons
    Dir.chdir(path) do
      Dir.glob("**/*.svg").map { |path| Icon.new(path) }
    end
  end
end


class Icon
  attr_accessor :path

  def initialize(path)
    @path = path
  end

  def name
    File.basename(path, File.extname(path)).gsub(/[_-]/, ' ')
  end

  def to_s
    name
  end
end
