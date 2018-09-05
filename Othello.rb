# (C) @yakata66

# 現状のboardを出力する
def board_now(board)
  puts "      board     "
  puts " １２３４５６７８"
  puts " ----------------"
  i = 1
  board.each do |line|
    tmp = []
    tmp << i
    line.each do |num|
      if num == 0
        tmp << "〇"
      elsif num == 1
        tmp << "●"
      else
        tmp << "　"
      end
    end
    puts tmp.join
    i += 1
  end
  puts " ----------------"
  b_num = "%#02d" % board.flatten.count(0)
  w_num = "%#02d" % board.flatten.count(1)
  puts "Black #{b_num}:#{w_num} White"
  puts
  puts
end

# ひっくり返るを定義する
def reverse(ranges,color,board)
  # rangeは[[x][y]]の順番が入っている
  ranges.each do |range|
    tmp = []
    range.each do |point|
      x = point[0]
      y = point[1]
      # 反対色が連続してありかつその先に同じ色がある時ひっくり返す
      case board[x][y]
      when color^1
        tmp << [x,y]
      when color
        tmp.each do |j|
          # p [board[j[0]][j[1]],color]
          board[j[0]][j[1]] = color
        end
        break
      when 2
        break
      end
    end
  end
end

# 石が置かれたときの石をひっくり返す処理を書く
def put_the_stone(x,y, color,board)
  # color: W or B
  board[x][y] = color
  # nilまたは同じ色で枝切り
  range = []
  # x,y方向
  range_plus_x = []
  range_plus_y = []
  range_minus_x = []
  range_minus_y = []
  range_plus_x_plus_y = []
  range_minus_x_plus_y = []
  range_plus_x_minus_y = []
  range_minus_x_minus_y = []


  ary_plus_x = ((x+1)..7).to_a
  ary_minus_x = (0..(y-1)).to_a.reverse
  ary_plus_y = ((y+1)..7).to_a
  ary_minus_y = (0..(x-1)).to_a.reverse
  ary_plus_x.each do |i|
    range_plus_x << [i,y]
  end
  ary_minus_x.each do |i|
    range_minus_x << [x,i]
  end
  ary_plus_y.each do |i|
    range_plus_y << [x,i]
  end
  ary_minus_y.each do |i|
    range_minus_y << [i,y]
  end

  8.times do |i|
    if x+i+1 <= 7 && x+i+1 >= 0 && y+i+1 <= 7 && y+i+1 >= 0
      range_plus_x_plus_y << [x+i+1,y+i+1]
    else
      break
    end
  end

  8.times do |i|
    if x+i+1 <= 7 && x+i+1 >= 0 && y-(i+1) <= 7 && y-(i+1) >= 0
      range_plus_x_minus_y << [x+i+1,y-i-1]
    else
      break
    end
  end

  8.times do |i|
    if x-(i+1) <= 7 && x-(i+1) >= 0 && y+i+1 <= 7 && y+i+1 >= 0
      range_minus_x_plus_y << [x-i-1,y+i+1]
    else
      break
    end
  end

  8.times do |i|
    if x-(i+1) <= 7 && x-(i+1) >= 0 && y-(i+1) <= 7 && y-(i+1) >= 0
      range_minus_x_minus_y << [x-i-1,y-i-1]
    else
      break
    end
  end

  ranges = [
    range_plus_x,
    range_minus_x,
    range_plus_y,
    range_minus_y,
    range_plus_x_plus_y,
    range_plus_x_minus_y,
    range_minus_x_plus_y,
    range_minus_x_minus_y,
  ]
  reverse(ranges,color,board)
end

# つぎに石を置くのが白か黒か判定する（未実装）
def sirokuro_hantei(board,color)
  # 0:kuro
  # 1:white
  for i in 0..7
    for j in 0..7
      if board[i][j] == " "
      end
    end
  end
end

#############
# 盤面を作る #
#############
# board[tate][yoko]で指定
# B:0
# W:1
board = Array.new
8.times do
  board << Array.new(8,2)
end
board[3][3] = 1
board[4][4] = 1
board[3][4] = 0
board[4][3] = 0


#############
# intro表示 #
#############
board_now(board)
puts "色　縦　横で指定してください（1order）"
puts "例： B 4 3"
puts "例： W 1 1"
# input
# 将来的にはwhile true
n = 60
n.times do |i|
  tmp = gets.chomp.split
  # p tmp
  x = tmp[1].to_i-1
  y = tmp[2].to_i-1
  puts
  if tmp[0] == "B"
    color = 0
  elsif tmp[0] == "W"
    color = 1
  elsif tmp == []
    puts("石をおいてください")
  elsif board[x][y] != " "
    puts("既に置かれているところには置けません")
  else
    puts("その操作は行えません")
  end
  put_the_stone(x, y, color,board)
  board_now(board)
  # if sirokuro_hantei(board,color) == "white"
  #   puts("次は白番です")
  # elsif sirokuro_hantei(board,color) == "black"
  #   puts("次は黒番です")
  # else
  #   puts("白も黒も置けないので終了です")
  #   break
  # end
end

# 枚数を数えてwinloseを出力
b_num = "%#02d" % board.flatten.count(0)
w_num = "%#02d" % board.flatten.count(1)
if b_num > w_num
  puts "#{b_num}-#{w_num} The black won!"
elsif b_num < w_num
  puts "#{b_num}-#{w_num} The white won!"
else
  puts "#{b_num}-#{w_num} Draw!"
end
