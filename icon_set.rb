class Object
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

  def present?
    !blank?
  end

  def presence
    self if present?
  end
end

class IconSet
  attr_accessor :name, :path, :license, :license_hint

  def initialize(name, path, options = {})
    puts name, path, options
    @name = name
    @path = path
    @license = options[:license].presence
    @license_hint = options[:license_hint].presence || 'license'
  end

  def to_s
    @name
  end

  def icons
    Dir.chdir(path) do
      Dir.glob("**/*.svg").map { |path| Icon.new(path) }.sort
    end
  end

  def groups
    icons.group_by(&:group)
  end
end

class Icon
  attr_accessor :path, :group

  def initialize(path)
    @path = path
    @group = fetch_group
  end

  def fetch_group(icon_path = @path)
    icon_dir = File.dirname(icon_path)
    return nil if icon_dir == '.'
    icon_dir.split('/').last
  end

  def name
    File.basename(path, File.extname(path)).gsub(/[_-]/, ' ')
  end

  def to_s
    [group, name].compact.join(' - ')
  end

  def <=>(other)
    if group.to_s == other.group.to_s
      path <=> other.path
    else
      group.to_s <=> other.group.to_s
    end
  end
end
