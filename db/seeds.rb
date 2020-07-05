categories = [
  {level1: "森・木", level2: ["森林", "樹海", "竹林", "樹木", "枝・葉", "紅葉"]},
  {level1: "花・植物", level2: ["桜", "向日葵", "薔薇", "花畑", "花", "植物"]},
  {level1: "山", level2: ["山", "富士山", "山脈", "高原", "登山", "雲海", "紅葉"]},
  {level1: "大地", level2: ["草原", "丘", "土", "石・岩", "砂漠・砂丘"]},
  {level1: "海・湖", level2: ["海", "海中", "砂浜", "海岸", "湖", "池・沼"]},
  {level1: "川・滝", level2: ["川", "滝", "渓谷"]},
  {level1: "空", level2: ["青空", "太陽", "雲", "虹", "夕焼け", "夜空", "オーロラ"]},
  {level1: "雪", level2: ["雪", "雪原", "雪山", "樹氷", "氷河・流氷"]}
]

categories.each.with_index(1) do |category,i|
  level1_var="@categories#{i}"
  level1_val= Category.create(name:"#{category[:level1]}")
  eval("#{level1_var} = level1_val")

  category[:level2].each do |level2_val|
     eval("#{level1_var}.children.create(name:level2_val)")
  end
end