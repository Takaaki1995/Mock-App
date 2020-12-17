require 'mechanize'
require 'pp'
require 'json'
require_relative "./csv"
require_relative "./parse_param"


#
#チームデータ取得処理
#

ret = {
    "ret" => false,
    "error" => "",
}

URL="https://www.wjbl.org"
FILE_NAME="team_data.csv"

begin
  path = get_param(delimiter:["-p","--path"], default:File.expand_path(__dir__))
  agent = Mechanize.new
  res = agent.get("#{URL}/team/list_html/")

  #チーム名を取得
  team_names = res.search(".team_block h3 em").map do |r|
    r.to_s.gsub(/<.+?>/i,"")
  end

  #チームのページのリンクを取得
  team_urls = res.search(".fr li a").map do |r|
    # href属性を取得 参考
    # https://qiita.com/shizuma/items/d04facaa732f606f00ff
    "#{URL}#{r.get_attribute(:href)}"
  end.select do |r|
    r.include?("stats_html")
  end

  team_datas = []
  (0..team_names.length).each do |i|
    res = JSON.parse(`ruby get_team_data_csv.rb --url #{team_urls[i]}`) rescue {}
    unless res["datas"].nil?
      datas = res["datas"].map{|r|
        r["team_name"] = team_names[i]
        r
      }
      team_datas.concat(datas)
    end
  end
  write_csv(team_datas,path,FILE_NAME)
  ret["ret"] = true
rescue => e
  e.message
  ret["error"] = e.message,e.backtrace.to_s
end

puts JSON.generate(ret)