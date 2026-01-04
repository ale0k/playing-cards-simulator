-- local push = require "push"

-- local gameWidth, gameHeight = 640, 360 --fixed game resolution
-- local windowWidth, windowHeight = love.window.getDesktopDimensions()
-- windowWidth, windowHeight = windowWidth * .8, windowHeight * .8 --make the window a bit smaller than the screen itself

-- push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true, pixelperfect = true})

Card = {}
Card.__index = Card

function Card:init(x, y, width, height, quad)
   self = setmetatable({}, Card)
   self.x = x
   self.y = y
   self.width = width
   self.height = height
   self.quad = quad
   self.state = {
        drag = {
            on = false,
            mouseOffset = {
                x = 0,
                y = 0
            }
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
        print("DRAG: ", self.state.drag.on)
    end
end

CardsImage = love.graphics.newImage("BaseCards-Sheet.png")
CardWidth = 53
CardHeight = 71
CardSets = 4
NumCards = CardSets * 9
Cards = {}

function love.load()
    for i = 0, 3 do
        for j = 0, 8 do
            local quad = love.graphics.newQuad(j * CardWidth, i * CardHeight, CardWidth, CardHeight, CardsImage)
            local card = Card:init((j + 1) * 100, (i + 1) * 100, CardWidth, CardHeight, quad)
            table.insert(Cards, card)
        end
    end
    RandomNumber = love.math.random(1, NumCards)
end

function love.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    for _, card in pairs(Cards) do
        if love.mouse.isDown(1) and card:isHovering(mouseX, mouseY) then
            card:drag(mouseX, mouseY)
        else
            card.state.drag.on = false
        end
    end
end

function love.draw()
    -- push:start()
    love.graphics.setColor(1, 1, 1, 1)
    for _, card in pairs(Cards) do
        love.graphics.rectangle("fill", card.x, card.y, card.width, card.height)
        love.graphics.draw(CardsImage, card.quad, card.x, card.y)
    end
    -- push:finish()
end

function love.resize(w, h)
    -- push:resize(w, h)
end