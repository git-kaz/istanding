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
      1. 肘を90°に曲げます
      2. 手のひらを自分の方に向けながら、腕をくっつけます
      3. 手のひらを外に向けながら胸を開きます（肩甲骨を寄せるように）
      4. 2~3を繰り返しましょう

      長く座っていると背中が丸くなっていませんか？
      肩甲骨をどんどん動かそう！
    TEXT
  },
   {
    name: "胸の壁ストレッチ",
    category: :stretch,
    cloudinary_public_id: "pectoralis",
    description: <<~TEXT
      1. 肘から手のひらを壁につけます
      2. そのまま体を開いていきます
      3. 胸を開いて前側が伸びるように
      4. 腕の高さによって伸びる場所が変わるので、調整してみましょう

      胸の硬さは『THE 猫背』の象徴です
      顔のむくみがスッキリすることも
    TEXT
  },
   {
    name: "お尻のストレッチ",
    category: :stretch,
    cloudinary_public_id: "gluteus",
    description: <<~TEXT
      1. 
      2. そのまま体を開いていきます
      3. 胸を開いて前側が伸びるように
      4. 腕の高さによって伸びる場所が変わるので、調整してみましょう

      胸の硬さは『THE 猫背』の象徴です
      顔のむくみがスッキリすることも
    TEXT
  },
   {
    name: "外側の全身ストレッチ",
    category: :stretch,
    cloudinary_public_id: "lateral_line",
    description: <<~TEXT
      1. 片手をテーブルや背もたれにつきます
      2. 反対の足を前からクロスします
      3. もう一方の手をバンザイして横に倒れていきましょう
      4. 脇腹からお尻までが伸びるのを感じながら深呼吸

      反対側も同様に行いましょう！
      全身につながる『筋膜』を伸ばしていきます
    TEXT
  },
  {
    name: "肩のストレッチ",
    category: :stretch,
    cloudinary_public_id: "shoulder",
    description: <<~TEXT
      1. 両手を後ろで組みます（立って行ってもOK）
      2. お辞儀をしながら手を天井の方へ伸ばしていきます
      3. 肩甲骨を寄せながら、肩周りを伸ばしていきましょう
      4. 首も下をむくとより伸びが感じられます

      肩を痛めないようにゆっくり無理せず
      息が止まらないように注意して行いましょう
    TEXT
  },
  {
    name: "後面の全身ストレッチ",
    category: :stretch,
    cloudinary_public_id: "back_line",
    description: <<~TEXT
      1. 両手をテーブルや背もたれにつきます
      2. 背中はまっすぐのまま股関節から体を曲げていきましょう
      3. 頭は両腕の間に入れるようにします
      4. 背中から足までが伸びるのを感じます

      辛い方は膝を少し曲げても大丈夫です
      全身につながる『筋膜』を伸ばしていきます
    TEXT
  },
  {
    name: "背骨のひねりストレッチ",
    category: :stretch,
    cloudinary_public_id: "thorax_rotation",
    description: <<~TEXT
      1. 座ったまま胸の前で腕を交叉します
      2. 上半身を捻っていきましょう
      3. 息を吐きながら捻っていきます
      4. 背中が丸くならないように気をつけます

      左右交互に行いましょう！
      背骨を動かすことで自律神経にも働きかけます
    TEXT
  },
  {
    name: "背中のストレッチ",
    category: :stretch,
    cloudinary_public_id: "latissimus",
    description: <<~TEXT
      1. 床に膝立ちになり、両肘を椅子につきます
      2. 顔を両腕の間に入れるように正座していきます
      3. 背中が伸びるのを感じながらキープします
      4. 肩を痛めないように無理せず行いましょう

      デスクワークで丸まりがちな背中を伸ばしていきましょう
      背骨が動くと自律神経にも良い影響があります
    TEXT
  },
  {
    name: "首のストレッチ",
    category: :stretch,
    cloudinary_public_id: "neck_side",
    description: <<~TEXT
      1. 片手で頭の反対側を抑えます
      2. そのまま首を横に倒していきましょう
      3. 首から肩にかけて伸びるのを感じます
      4. 肩がすくまない様に注意

      首は痛めやすいので強くやりすぎないように
      首が硬くなると頭痛や眼精疲労の原因にも
    TEXT
  },
]

exercises_data.each do |data|
  # find_or_create_byでseedの重複を避ける
  Exercise.find_or_create_by!(name: data[:name]) do |e|
    e.category = data[:category]
    e.cloudinary_public_id = data[:cloudinary_public_id]
    e.description = data[:description]
  end
end

puts "完了！"
