local fruits = require("fruits")

local IMAGE_DIR = "images/"

--■■BGM音声を再生するAPI■■  タイトル
local title_bgm = media.playSound("bgm/bgm2.wma")

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
-- 物理エンジンをスタート
physics.start()
--●重力を設定●
physics.setGravity(0,9)
-- 物理エンジンを一時停止
physics.pause()
-- 物理エンジンの表示モード
--physics.setDrawMode("normal")
physics.setDrawMode("hybrid")
--physics.setDrawMode("debug")

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

function scene:create( event )

-- Called when the scene's view does not exist.
-- 
-- INSERT code here to initialize the scene
-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

local sceneGroup = self.view
--■●■背景と芝生を設定する関数（o▽n）■●■
  function setbackground()
-- create a grey rectangle as the backdrop
background = display.newImageRect( IMAGE_DIR.."bg.png", screenW, screenH )
background.anchorX = 0
background.anchorY = 0
  background.x = 0
background.y = 0 --画像の原点のお話

-- create a grass object and add physics (with custom shape)
  grass = display.newImageRect( IMAGE_DIR.."grass.png", screenW, 82 )
grass.anchorX = 0
grass.anchorY = 1
grass.x, grass.y = 0, display.contentHeight --芝生の画像を左下に合わせてる

-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
  --■★■ちゅうもおおおおおおおおおおおおおおおっっく！■★■　パネポン！
local grassShape = { -halfW,-grass.contentHeight/2, halfW,-grass.contentHeight/2, halfW,grass.contentHeight/2, -halfW,grass.contentHeight/2}
  --                      ↑四隅の頂点を列挙↑
--physics.addBody( grass, "static" , { friction=0.3, shape=grassShape } )
  --↑物理   ↑剛体    ↑剛体対象↑付けないと落ちてく   ↑↑摩擦       ↑↑指定した大きさ
end
setbackground()
--◆o◆左右の透明なかべ◆o◆
function setwall()
  w1 = display.newRect(0, display.contentHeight / 2, 5, display.contentHeight)
  w1:setFillColor(255, 0, 0)
  w2 = display.newRect(display.contentWidth, display.contentHeight / 2, 5, display.contentHeight)
  w2:setFillColor(255, 0, 0)
  
  --physics.addBody(w1,"static")
  --physics.addBody(w2,"static")
  return setwall
  end
local wall = setwall()

 --score表示の初期設定
 fruits.setScore()
 
  
  -- all display objects must be inserted into group
sceneGroup:insert( background )
sceneGroup:insert( grass)

  
end

--local t = os.date('*t')

--生成された果物を管理
--local fruitsTable = {}

 -- 1秒ごとに実行される関数　　
  function update(event)
    --print(os.clock())
    
    --ランダムなx位置に出現
    local fruit = fruits.newFruit()
--    table.insert(fruitsTable, fruit)
    
    --　生成された果物の数を表示する　#はテーブルの中のオブジェクトの数
--    print(#fruitsTable)
end
  -- 1.5秒ごとにupdate関数を実行する
 tm = timer.performWithDelay(1500,update,0) 


function scene:show( event )
local sceneGroup = self.view
local phase = event.phase

if phase == "will" then
-- Called when the scene is still off screen and is about to move on screen
elseif phase == "did" then
-- Called when the scene is now on screen
-- 
-- INSERT code here to make the scene come alive
-- e.g. start timers, begin animation, play audio, etc.
physics.start()
end
end

function scene:hide( event )
local sceneGroup = self.view

local phase = event.phase

if event.phase == "will" then
-- Called when the scene is on screen and is about to move off screen
--
-- INSERT code here to pause the scene
-- e.g. stop timers, stop animation, unload sounds, etc.)
physics.stop()
elseif phase == "did" then
-- Called when the scene is now off screen
end	

end

function scene:destroy( event )

-- Called prior to the removal of scene's "view" (sceneGroup)
-- 
-- INSERT code here to cleanup the scene
-- e.g. remove display objects, remove touch listeners, save state, etc.
local sceneGroup = self.view

package.loaded[physics] = nil
physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene