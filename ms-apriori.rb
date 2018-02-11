$sdc = 0
$must_have = []
$cannot_be_together = []
def parse_input_file(file_path)
  t_s = []
  File.open(file_path, "r") do |f|
    f.each_line do |l|
      l.chomp!
      line = l.split(/{|,|}/)
      line.each do |x|
        x.strip!.to_i
      end
      line.shift
      t_s.push line
    end
  f.close
  end
  t_s
end

def parse_parameter_file(file_path)
  i_s = []
  mis = Hash.new
  File.open(file_path, "r") do |f|
    f.each_line do |l|
      if l.include? "MIS"
        x1 = l.match(/\([0-9]+\)/).to_s.sub!("(", "").sub!(")", "").to_i
        x2 = l.split('=')[1].strip().to_f
        mis[x1] = x2
        i_s.push(x1)
      elsif l.include? "SDC"
        $sdc = l.split('=')[1].strip().to_f
      elsif l.include? "must-have"
        x1 = l.split(':')[1].split('or')
        x1.each do |x|
          $must_have.push(x.strip().to_i)
        end
      elsif l.include? "cannot_be_together"
        x1 = l.scan(/\{(.*?)\}/)
        x1.each do |x|
          x2 = x[0].split(',')
          x2.each do |e|
            e.strip!.to_i
          end
          $cannot_be_together.push(x2)
        end
      end
    end
  end
  return i_s, mis
end

transaction_set = parse_input_file("input-data.txt")
item_set, minimum_item_suport = parse_parameter_file("parameter-file.txt")
