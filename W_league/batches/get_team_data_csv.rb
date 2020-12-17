require 'mechanize'
require 'pp'
require 'json'
require_relative "./csv"
require_relative "./parse_param"

#
#チームデータ取得処理
#
def get_team_data(url)
  agent = Mechanize.new
  res = agent.get(url)

  target = res.search(".team-color-table th")
  columns = target.map do |r|
    r.to_s.gsub(/<.+?>/i,"")
  end

  target = res.search(".team-color-table td")
  ignore_flag = true
  datas = target.map do |r|
    #タグを除去
    r.to_s.gsub(/<.+?>/i,"")
  end.select{|r|
    #チームスコア以降の行はいらないので削除
    if r == "チームスコア"
      ignore_flag = false
    end
    ignore_flag
  }

  #カラムごとにデータを整理
  data_hashes =[]
  while datas.length > 0
    row = datas.slice!(0,columns.length)
    hash = {}
    columns.each_with_index do |column,i|
      hash[column] = row[i]
    end
    data_hashes.push(hash)
  end
  return data_hashes
end

ret = {
    "ret" => false,
    "datas" => [],
    "error" => "",
}

begin
  raise "plz specify url after -u option"  if
      (url = get_param(delimiter:["-u","--url"], default:nil,split:" ")).nil?
  ret["datas"] = get_team_data(url)
  ret["ret"] = true
rescue => e
  ret["error"] = e.message,e.backtrace.to_s
end

puts JSON.generate(ret)