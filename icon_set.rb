class IconSet
  attr_accessor :name, :path

  def initialize(name, path)
    @name = name
    @path = path
  end

  def to_s
    @name
  end

  def icons
    Dir.chdir(path) do
      Dir.glob("**/*.svg").sort.map { |path| Icon.new(path, group(path)) }
    end
  end

  def group(icon_path)
    icon_dir = File.dirname(icon_path)
    if icon_dir == '.'
      nil
    else
      icon_dir.split('/').last
    end
  end
end


class Icon
  attr_accessor :path, :group

  def initialize(path, group = nil)
    @path = path
    @group = group
  end

  def name
    File.basename(path, File.extname(path)).gsub(/[_-]/, ' ')
  end

  def to_s
    name
  end
end
