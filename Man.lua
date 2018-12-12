Man = Class{}

function Man:init(paddle, ball)
  self.paddle = paddle
  self.ball = ball
end

function Man:move()
  if love.keyboard.isDown(self.paddle.pad[1]) then
    self.paddle.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown(self.paddle.pad[2]) then
    self.paddle.dy = PADDLE_SPEED
  else
      self.paddle.dy = 0
  end
end

--[[function Man:update()
  if self.paddle.dy < 0 then
    self.paddle.y = math.max(0, self.paddle.y + self.paddle.dy * dt)
  else
    self.paddle.y = math.min(VIRTUAL_HEIGHT - self.paddle.h, self.paddle.y + self.paddle.dy * dt)
  end
end

function Man:move()
  --implement up
  if self.ball.x > VIRTUAL_WIDTH / 2 + 50 then
    if self.ball.y < VIRTUAL_HEIGHT / 2 then
      self.player.dy = -self.ball.y - self.player.y
    elseif self.ball.y > VIRTUAL_HEIGHT / 2 then
      self.player.dy = self.ball.y - self.player.y
    else
        self.player.dy = 0
    end
  end
end
]]
