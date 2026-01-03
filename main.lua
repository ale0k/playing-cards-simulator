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
    self.x = mouseX - (self.width / 2)
    self.y = mouseY - (self.height / 2)
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
            table.insert(Cards, love.graphics.newQuad(j * CardWidth, i * CardHeight, CardWidth, CardHeight, CardsImage))
        end
    end
    RandomNumber = love.math.random(1, NumCards)
    local cardImage = Cards[RandomNumber]
    print(cardImage)
    NewCard = Card:init(0, 0, CardWidth, CardHeight, cardImage)
end

function love.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    if NewCard:isHovering(mouseX, mouseY) and love.mouse.isDown(1) then
        NewCard:drag(mouseX, mouseY)
    end
end

function love.draw()
    -- push:start()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", NewCard.x, NewCard.y, CardWidth, CardHeight)
    love.graphics.draw(CardsImage, NewCard.quad, NewCard.x, NewCard.y)
    love.graphics.print("Card Position: " .. NewCard.x .. ", " .. NewCard.y)
    -- push:finish()
end

function love.resize(w, h)
    -- push:resize(w, h)
end