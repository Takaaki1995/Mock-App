require "csv"

# CSVデータの読み込み
def load_csv(csv=nil)
  res = []
  return res unless File.exists?(csv)
  csv_data = CSV.read(csv) rescue []
  columns =  csv_data.shift
  # カラムバリデーション
  if columns == nil or
      !(columns.instance_of?(Array) and columns.length > 0)
    return res
  end
  csv_data.each_with_index do |row,index|
    if row.length > 0
      res.push(Hash[*[columns,row].transpose.flatten])
    end
  end
  return res
end

# データをCSVに書き込み
def write_csv(hash_array,path,file)
  csv_rows = hash_array.map{|r|
    <<STR
#{r.values.map{|v|next '"'+"#{v.to_s.gsub(/"/,'""')}"+'"'}.join(",")}
STR
  }.join("")
  csv_rows= <<"STR".strip
#{hash_array[0].keys.map{|r|
  '"'+r.gsub(/"/,'""')+'"'}.join(",")}
#{csv_rows}
STR
  # ファイルを新規作成
  FileUtils.mkdir_p(path) unless Dir.exists?(path)
  File.open("#{path}/#{file}", "w+"){|f|
    f.puts(csv_rows)
  }
end