# 引数の取得
# delimiterは配列で複数指定可能
def get_param(argv:ARGV, delimiter:[], default:"", split:"=")
  ret = default
  argv = argv.map{|r|r.split(split)}.flatten.select{|r|r!=split}
  delimiter = [delimiter] unless delimiter.kind_of?(Array)
  delimiter.each{|d|
    unless (inx=argv.index(d)).nil?
      ret = argv[inx+1] unless argv[inx+1].nil?
      break
    end
  }
  return ret
end

# 正規表現パターンでのパラメータ検索
def get_match_params(argv:ARGV,match:"",default:{})
  ret = default
  argv = argv.map{|r|r.split("=")}.flatten.select{|r|r!="="}
  argv.each{|args|
    next if (matches = args.match(match) rescue nil).nil?
    ret[matches[0]] = get_param(argv:argv, delimiter:matches[0], default:default)
  }
  return ret
end

# 引数があるかチェック
def is_param(argv:ARGV,delimiter:[],default:false)
  ret = default
  delimiter = [delimiter] unless delimiter.kind_of?(Array)
  delimiter.each{|d|
    ret |= !argv.index(d).nil?
  }
  return ret
end
