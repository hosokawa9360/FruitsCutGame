-- 呪文　fruits モジュール  ...はこのファイルのこと
module(..., package.seeall)

-- ランダムの種を時間に設定する
math.randomseed( os.time() )

-- 物理エンジンを導入
physics = require "physics"

-- 画像フォルダ
IMAGE_DIR = "images/"
-- 効果音フォルダ
SE_DIR = "se/"

-- 効果音を読み込む
local SE_Cut1 = audio.loadSound(SE_DIR.."SE_Cut1.mp3")
local SE_Cut2 = audio.loadSound(SE_DIR.."SE_Cut2.mp3")

-- グループを作成
local myGroup = display.newGroup()

-- スコア
local score=0
-- スコアの初期設定をする
function setScore()
  --scoreで与えられた得点と表示させる
  tfScoreDisplay = display.newText(score,
    display.contentWidth -50 , display.contentHeight*0.05,native.systemFont,30)
  tfScoreDisplay.align = "right"
  return  tfScoreDisplay
end
-- スコアを加算し表示する
function addScore(point)
  -- print(point)
  score = score + point
  tfScoreDisplay.text = score
  return score
end




--　果物を消す
local function removeFruit(event)

  local params = event.source.params
  local fruit = params.fruit

  -- 移動などのアニメーションを停止する
  transition.cancel(fruit.L)
  transition.cancel(fruit.R)

-- 自分自身を削除する
  display.remove(fruit)
  fruit = nil


end

-- 果物をタッチした時の動作
function onFruit(event)
  -- タッチし終えたとき
  if("ended" == event.phase) then
    -- タッチしたスプライトを取得する
    local fruit = event.target 
    
    if fruit ~= nil and fruit.type == 16 then
      score = math.floor(score / 2)
      tfScoreDisplay.text = score
      print("爆弾どーんどーんどーんどーん")
      
    end  
    
    -- 斬った残像エフェクトの表示
    -- 右と左のりんごを割れたように回転させる
--    transition.to(fruit.L,{time = 500,rotation=-25,alpha=0.8 })
--    transition.to(fruit.R,{time = 500,rotation= 25,alpha=0.8 })
--    -- 右と左のりんごを左右に飛ばす
--    transition.to(fruit.L,{time = 500,alpha=0.0,x=-100,delay=100})
--    transition.to(fruit.R,{time = 500,alpha=0.0,x= 100,delay=100})


    transition.to(fruit.L,{time = 500,rotation=-25,alpha=0.8 ,x=-100})
    transition.to(fruit.R,{time = 500,rotation= 25,alpha=0.8 ,x=100})
--  
    effect = display.newImageRect(IMAGE_DIR.."effectCut.png",64,64)


    effect.x = fruit.x
    effect.y = fruit.y

    effect.rotation = math.random(60) -30 

    transition.to(effect,{time = 500,xScale=3,yScale=3 })

    transition.to(effect,{time = 500,alpha=0.0 ,delay=500})

-- 2種類の効果音をランダムに鳴らす
    if(math.random(1,2) == 1) then
      audio.play(SE_Cut1)
    else
      audio.play(SE_Cut2)
    end
    --　点数を加える
    addScore(10)
    --イベントに反応しないようにする
    fruit:removeEventListener("touch",onFruit)


    -- 大体の処理が終わったころ大体2000ms後に消去する
    tm = timer.performWithDelay(2000,removeFruit)
    tm.params = { fruit = event.target }

  end   
end

--剛体グループの生成 果物はグループ番号2,果物が干渉する剛体は1と4
physicsGroupFruit = {categoryBits = 2, maskBits = 5}


-- 座標(x,y)に果物を生成する関数
function newFruit()

  fruit = display.newGroup()
  --◆x軸0.1から0.35の間で発射
  fruit.x = display.contentWidth * 0.1 + display.contentWidth * 0.05 * math.random(0, 5)
  fruit.y = display.contentHeight

  local type = math.random(14,16)
-- 果物の種類
  fruit.type = type

  local left = IMAGE_DIR..string.format("fruit%d.png",type*2-1)
  local right = IMAGE_DIR..string.format("fruit%d.png",type*2)
--◆ランダムで画像出す。（左右の画像をそれぞれ出す）
  fruit.L = display.newImageRect(fruit,left,32,64)
  fruit.R = display.newImageRect(fruit,right,32,64)

  fruit.L.anchorX,fruit.L.anchorY = 1, 0.5
  fruit.R.anchorX,fruit.R.anchorY = 0, 0.5

  fruit.L.x, fruit.L.y = x, y
  fruit.R.x, fruit.R.y = x, y

  --円の剛体をボールに
  physics.addBody(fruit,{radius = 10, filter = physicsGroupFruit})
  --ベクトル速度
  fruit:setLinearVelocity( math.random(30, 50),-1 * math.random(450, 500))

  -- 果物をタッチしたら onFruitが呼び出される
  fruit:addEventListener("touch",onFruit)

  -- myGroupにmyImageを挿入
  myGroup:insert(fruit)
  print (myGroup.numChildren)

  return fruit
end

-- 1秒ごとに実行される関数　　
function update(event)
  for i=1,myGroup.numChildren do
    local child = myGroup[i]
    if child~=nil and (child.x > display.contentWidth or child.y > display.contentHeight ) then
      -- アニメーションを停止する
      transition.cancel(child.L)
      transition.cancel(child.R)
      -- 自分自身を削除する
      display.remove(child)
      child = nil
      print("remove ? "..i.."")
    end
  end 
end   
-- 500秒ごとにupdate関数を実行する
tm = timer.performWithDelay(100,update,0) 
