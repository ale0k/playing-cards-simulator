-- local push = require "push"

-- local gameWidth, gameHeight = 640, 360 --fixed game resolution
-- local windowWidth, windowHeight = love.window.getDesktopDimensions()
-- windowWidth, windowHeight = windowWidth * .8, windowHeight * .8 --make the window a bit smaller than the screen itself

-- push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true, pixelperfect = true})

Card = {}
Card.__index = Card

function Card:init(x, y, width, height, face, back)
   self = setmetatable({}, Card)
   self.x = x
   self.y = y
   self.width = width
   self.height = height
   self.face = face
   self.back = back
   self.state = {
        drag = {
            on = false,
            mouseOffset = {
                x = 0,
                y = 0
            }
        },
        flip = {
            on = false,
            debounceTime = 0.1,
            nextAvailableTime = 0
        }
    }
   return self
end

function Card:isHovering(mouseX, mouseY)
    local hovering = false
    if mouseX > self.x and mouseX < self.x + self.width then
        if mouseY > self.y and mouseY < self.y + self.height then
            hovering = true
        end
    end
    return hovering
end

function Card:drag(mouseX, mouseY)
    if self.state.drag.on then
        self.x = mouseX + self.state.drag.mouseOffset.x
        self.y = mouseY + self.state.drag.mouseOffset.y
    else
        self.state.drag.mouseOffset.x = self.x - mouseX
        self.state.drag.mouseOffset.y = self.y - mouseY
        self.state.drag.on = true
    end
end

function Card:flip()
    local currentTime = love.timer.getTime()
    if currentTime > self.state.flip.nextAvailableTime then
        self.state.flip.on = not self.state.flip.on
    end

    self.state.flip.nextAvailableTime = currentTime + self.state.flip.debounceTime
    print(currentTime,self.state.flip.nextAvailableTime)
end

function Card:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 2, 2)
    if self.state.flip.on then
        love.graphics.draw(self.back, self.x, self.y)
    else
        love.graphics.draw(CardsImage, self.face, self.x, self.y)
    end
end

CardsImage = love.graphics.newImage("BaseCards-Sheet.png")
CardBackImage = love.graphics.newImage("CardBack.png")
CardWidth = 53
CardHeight = 71
CardSets = 4
Cards = {}

function love.load()
    for i = 0, 3 do
        for j = 0, 8 do
            local face = love.graphics.newQuad(j * CardWidth, i * CardHeight, CardWidth, CardHeight, CardsImage)
            local card = Card:init((j + 1) * 75, (i + 1) * 100, CardWidth, CardHeight, face, CardBackImage)
            table.insert(Cards, card)
        end
    end
    Shuffle(Cards)
end

function love.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    for _, card in pairs(Cards) do
        if love.mouse.isDown(1) and card:isHovering(mouseX, mouseY) then
            card:drag(mouseX, mouseY)
        elseif love.mouse.isDown(2) and card:isHovering(mouseX, mouseY) then
            card:flip()
        else
            card.state.drag.on = false
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == 's' then
        Shuffle(Cards)
    end
end

function love.draw()
    -- push:start()
    love.graphics.setColor(1, 1, 1, 1)
    for _, card in pairs(Cards) do
        card:draw()
    end
    -- push:finish()
end

function love.resize(w, h)
    -- push:resize(w, h)
end

function Shuffle(cards)
    for i = #cards, 2, -1 do
        local j = love.math.random(1, i)
        cards[i], cards[j] = cards[j], cards[i]
        cards[i].x, cards[j].x = cards[j].x, cards[i].x
        cards[i].y, cards[j].y = cards[j].y, cards[i].y
    end
end