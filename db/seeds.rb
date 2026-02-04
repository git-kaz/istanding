puts "シードデータを投入中"

exercises_data = [
  {
    name: "ウォーキング",
    category: :walk,
    cloudinary_public_id: "walk",
    description: <<~TEXT
      外に出て歩きましょう！
      理想は20分以上とされていますが、まずは5分からでも大丈夫です。
      - 効果的な方法
      1. やや歩幅を広げる
      2. ペースも少し早めに
      3. 軽く息が上がるくらいが効果的

      ちゃんと戻ってきてくださいね！
    TEXT
  },
  {
    name: "スクワット",
    category: :training,
    cloudinary_public_id: "squat",
    description: <<~TEXT
      1. 足を肩幅に開き、ゆっくり腰を下ろします。
      2. 膝が爪先より前に出すぎないように意識してください。
      3. 膝が90°まで曲がるとより効果的ですが、浅くても大丈夫です！
      
      下半身の血流を良くして、脳をリフレッシュさせましょう。
    TEXT
  },
   {
    name: "踵上げ",
    category: :training,
    cloudinary_public_id: "heel_raise",
    description: <<~TEXT
      1. 立ち上がり椅子やテーブルに軽く捕まりましょう
      2. 足の指に力を入れながら踵を上げていきます
      3. 下ろす時をゆっくり行うとより効果的です
      4. 踵をつかないように続けるとさらに負荷が上がりますよ！

      ふくらはぎは『第2の心臓』なので、全身の血流が良くなります
    TEXT
  },
   {
    name: "ヒップエクステンション",
    category: :training,
    cloudinary_public_id: "hip_extension",
    description: <<~TEXT
      1. 壁や机に手をついて姿勢を安定させる。(余裕があれば手を離してもOK)
      2. 膝を伸ばしたまま、片脚を後ろにゆっくり蹴り出す。
      3. お尻の力で脚を上げ、ゆっくり元の位置に戻す
      4. 体が前に倒れないように注意！

      座り続けるとお尻の筋肉が固まってくるので、とても効果的です
    TEXT
  },
   {
    name: "肩甲骨の運動",
    category: :training,
    cloudinary_public_id: "scapula",
    description: <<~TEXT
      
    TEXT
  },
   {
    name: "スクワット",
    category: :training,
    cloudinary_public_id: "squat",
    description: <<~TEXT
      足を肩幅に開き、ゆっくり腰を下ろします。
      膝が爪先より前に出すぎないように意識してください。
      膝が90°まで曲がるとより効果的ですが、浅くても大丈夫です！
      下半身の血流を良くして、脳をリフレッシュさせましょう。
    TEXT
  },
]

exercises_data.each do |data|
  # find_or_create_byでseedの重複を避ける
  Exercise.find_or_create_by!(name: data[:name]) do |e|
    e.category = data[:category]
    e.description = data[:description]
  end
end

puts "完了！"
