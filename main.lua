--[[
Author: Myckhel
]]
push = require 'push'
Class = require 'class'
require 'Ball'
require 'Paddle'
require 'Com'
require 'Man'

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

PADS = {{'w', 's'}, {'o', 'l'}}

function love.load()
  math.randomseed(os.time())
  love.graphics.setDefaultFilter('nearest', 'nearest')
  smallFont = love.graphics.newFont('font.ttf', 8)
  love.graphics.setFont(smallFont)
  scoreFont = love.graphics.newFont('font.ttf', 32)
  love.graphics.setFont(smallFont)
  --love.graphics.setTitle('My Pong')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  love.window.setTitle('My Pong')

  sounds = {
    ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
  }

  com = true
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
  player1 = Man(Paddle(0, 30, 8, 40, PADS[1]), ball)
  --player1.paddle.setPad(PADS[1])
  tmp = Paddle(VIRTUAL_WIDTH - 8, VIRTUAL_HEIGHT - 40, 8, 40, PADS[2])
  if not com then
    player2 = Man(tmp, ball)
    --player2.paddle.setPad(PADS[2])
  else
    player2 = Com(tmp, ball)
  end

  gameState = 'start'
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  player1:move()
  if not com then
    player2:move()
  else
    --com here
    player2:move()
  end

  if gameState == 'play' then
    if ball.x < 0 then
      sounds['score']:play()
      player2.paddle.score = player2.paddle.score + 1
      if player2.paddle.score == 10 then
        gameState = 'winner2'
      else
      gameState = 'serve1'
      end
      ball:reset(1)
    end

    if ball.x > VIRTUAL_WIDTH then
      sounds['score']:play()
      player1.paddle.score = player1.paddle.score + 1
      if player1.paddle.score == 10 then
        gameState = 'winner1'
      else
      gameState = 'serve2'
      end
      ball:reset(2)
    end
    if ball:collides(player1) then
      ball.dx = -ball.dx * 1.03
      ball.x = player1.paddle.x + player1.paddle.w

      if ball.dy < 0 then
          ball.dy = -math.random(10, 150)
      else
          ball.dy = math.random(10, 150)
      end
      sounds['paddle_hit']:play()
    end

    if ball:collides(player2) then
      ball.dx = -ball.dx + 1.03
      ball.x = player2.paddle.x - player2.paddle.w

      if ball.dy < 0 then
          ball.dy = -math.random(10, 150)
      else
          ball.dy = math.random(10, 150)
      end
      sounds['paddle_hit']:play()
    end

    if ball.y <= 0 then
      ball.y = 0
      ball.dy = -ball.dy
      sounds['wall_hit']:play()
    end

    -- -4 to account for the ball's size
    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.y = VIRTUAL_HEIGHT - 4
        ball.dy = -ball.dy
        sounds['wall_hit']:play()
    end

    ball:update(dt)
  end

  player1.paddle:update(dt)
  --com or not
  if not com then
    player2.paddle:update(dt)
  else
    --com here
    player2:update(dt)
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end

  if key == 'enter' or key == 'return' then
    if gameState == 'start' or gameState == 'serve1' or gameState == 'serve2' then
      gameState = 'play'
    elseif gameState == 'winner1' or gameState == 'winner2' then
      gameReset()
      gameState = 'play'
    else
      gameState = 'start'

      ball:reset()

    end
  end
end

function love.draw()
  -- body...
  push:apply('start')
    love.graphics.clear(40,50,255,255)
    love.graphics.setFont(smallFont)
    love.graphics.setColor(20,20, 0, alpha)
    if gameState == 'start' then
        love.graphics.printf('Press Enter Key To Start!', 0, 20, VIRTUAL_WIDTH, 'center')
      elseif gameState == 'serve1' then
        love.graphics.printf('Player1 to Serve', 0, 20, VIRTUAL_WIDTH, 'center')
      elseif gameState == 'serve2' then
        love.graphics.printf('Player2 to Serve', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Playing!', 0, 20, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.setColor(250,0, 0, alpha)
    if gameState == 'winner1' then
      love.graphics.printf('Player 1 Won!', 0, 30, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'winner2' then
      love.graphics.printf('Player 2 Won!', 0, 30, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.setColor(0,255, 255, 255)
    love.graphics.printf('Hello Pong', 0, 4, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(scoreFont)
    love.graphics.setColor(255,255, 0, 255)
    love.graphics.printf(tostring(player1.paddle.score), 50, VIRTUAL_HEIGHT / 2 - 15, VIRTUAL_WIDTH / 2, 'center')
    love.graphics.printf(tostring(player2.paddle.score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 - 15, VIRTUAL_WIDTH / 2, 'center')
    player1.paddle:render()
    love.graphics.setColor(255,18, 0, 255)
    player2.paddle:render()
    love.graphics.setColor(22,255, 0, 255)
    ball:render()

    displayFPS()
  push:apply('end')
end

function gameReset()
  winner = 0
  player1.paddle.score = 0
  player2.paddle.score = 0
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
