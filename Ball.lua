Ball = Class{}

function Ball:init(x, y, width, height)
  self.y = y
  self.x = x

  self.h = height
  self.w = width

  self.dy = math.random(2) == 1 and -100 or 100
  self.dx = math.random(-50, 50) == 1 and math.random(-80, -100) or math.random(80, 100)
end

function Ball:reset(p)
  self.y = VIRTUAL_HEIGHT / 2 - 2
  self.x = VIRTUAL_WIDTH / 2 - 2

  self.dy = math.random(-50, 50)

  if p == 1 then
    self.dx = 100
  elseif p == 2 then
    self.dx = -100
  else
    self.dx = math.random(2) == 1 and 100 or -100
  end
end

function Ball:update(dt)
  self.x = self.x + (self.dx * 1.5) * dt
  self.y = self.y + (self.dy * 1.5) * dt
end

function Ball:render()
  love.graphics.rectangle('fill', ball.x, ball.y, ball.w, ball.h)
end

function Ball:collides(paddle)
  if self.x > paddle.paddle.x + paddle.paddle.w or paddle.paddle.x > self.x + self.w then
    return false
  end

  if self.y > paddle.paddle.y + paddle.paddle.h or paddle.paddle.y > self.y + self.h then
    return false
  end
  return true
end
