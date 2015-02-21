class MyCnf
  def self.parse(file_path)
    cnf = {}
    section = nil
    File.read(file_path).each_line do |line|
      line.gsub!(/#.*/, '')
      line.strip!

      next if line == ''

      if /\[(.+)\]/ =~ line
        section = $1.to_sym
        next
      end

      next if section.nil?
      next unless /^([^\=]+)\=?(.*)/ =~ line
      param, value = [ $1.strip, $2.strip ]
      param = param.gsub('-', '_').to_sym

      value = case value
      when /^\d+$/; value.to_i
      when /^true$/i; true
      when /^false$/i; false
      else value
      end

      cnf[section] ||= {}
      cnf[section][param] = value
    end
    cnf
  end

  def self.generate(hash)
    result = ''
    hash.each do |section, params|
      result << %Q[[#{section.to_s}]\n]
      params.each do |param, value|
        if value == ''
          result << %Q[#{param}\n]
        else
          result << %Q[#{param} = #{value}\n]
        end
      end
      result << %Q[\n]
    end
    result.chomp
  end

  def self.diff_files(*file_pathes)
    cnfs = file_pathes.map { |path| parse(path) }
    diff(*cnfs)
  end

  def self.diff(*cnf)
    compare = compare(*cnf)
    result = {}
    compare.each do |section, params|
      params.each do |param, values|
        if values.uniq.size != 1
          result[section] ||= {}
          result[section][param] = values
        end
      end
    end
    result
  end

  def self.compare_files(*file_pathes)
    cnfs = file_pathes.map { |path| parse(path) }
    compare(*cnfs)
  end

  def self.compare(*cnf)
    size = cnf.size
    result = {}
    cnf.each_with_index do |c, i|
      result = _compare(c, size, i, result)
    end
    result
  end

  private

  def self._compare(cnf, size, index, result)
    cnf.each do |section, params|
      result[section] ||= {}
      params.each do |param, value|
        result[section][param] ||= Array.new(size)
        result[section][param][index] = value
      end
    end
    result
  end
end
