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
      param, value = [$1.strip.to_sym, $2.strip]

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
end
