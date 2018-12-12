Paddle = Class{}
--pad = {}
function Paddle:init(x, y, w, h, pad)
  self.x = x
  self.y = y

  self.w = w
  self.h = h

  self.dy = 0

  self.score = 0

  self.pad = pad
end

function Paddle:setPad(pad)
  self.pad = pad
end

function Paddle:update(dt)
  if self.dy < 0 then
    self.y = math.max(0, self.y + self.dy * dt)
  else
    self.y = math.min(VIRTUAL_HEIGHT - self.h, self.y + self.dy * dt)
  end
end

function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end
