puts "シードデータを投入中"

exercises_data = [
  {
    name: "ウォーキング",
    category: :walk,
    description: <<~TEXT
      両手を肩に置いて、肘で大きな円を描くように回します。
      肩甲骨を寄せるイメージで、ゆっくり20秒間続けましょう。
      デスクワークで固まった肩周りをほぐすのに最適です。
    TEXT
  },
  {
    name: "スロースクワット",
    category: :muscle_training,
    description: <<~TEXT
      足を肩幅に開き、5秒かけてゆっくり腰を下ろします。
      膝が爪先より前に出ないように意識してください。
      下半身の血流を良くして、脳をリフレッシュさせましょう。
    TEXT
  }
]

exercises_data.each do |data|
  # find_or_create_byでseedの重複を避ける
  Exercise.find_or_create_by!(name: data[:name]) do |e|
    e.category = data[:category]
    e.description = data[:description]
  end
end

puts "完了！"