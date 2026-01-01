local push = require "push"

local gameWidth, gameHeight = 640, 360 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth * .8, windowHeight * .8 --make the window a bit smaller than the screen itself

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true, pixelperfect = true})

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
end

function love.update(dt)
end

function love.draw()
    push:start()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", CardWidth, CardHeight, CardWidth, CardHeight)
    love.graphics.draw(CardsImage, Cards[RandomNumber], CardWidth, CardHeight)
    -- for i = 1, 4 do
    --     for j = 1, 8 do
    --         love.graphics.rectangle("fill", j * CardWidth, i * CardHeight, CardWidth, CardHeight)
    --         love.graphics.draw(CardsImage, Cards[(i - 1) * 9 + j], j * CardWidth, i * CardHeight)
    --     end
    -- end
    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end