push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Pong')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)

    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- create game objects
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    servingPlayer = 1

    -- set game state
    gameState = 'start'
end

function love.update(dt)
    if gameState == 'serve' then 
        ball.dy = math.random(-50, 50)

        if servingPlayer == 1 then 
            ball.dx = math.random(140, 200)
        else 
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then 
        -- collision with left (player 2 score)
        if ball.x + ball.width < player1.x then 
            servingPlayer = 1
            player2.score = player2.score + 1
            ball:reset()
            gameState = 'serve'
        end

        -- collision with right (player 1 score)
        if ball.x > player2.x + player2.width then 
            servingPlayer = 2
            player1.score = player1.score + 1
            ball:reset()
            gameState = 'serve'
        end

        if ball:collides(player1) then 
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + player1.width

            if ball.dy < 0 then 
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end
        end
        if ball:collides(player2) then 
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - ball.width

            if ball.dy < 0 then 
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end
        end

        -- collision with top of screen
        if ball.y <= 0 then 
            ball.y = 0
            ball.dy = -ball.dy
        end

        -- collision with bottom of screen
        if ball.y + ball.height >= VIRTUAL_HEIGHT then 
            ball.y = VIRTUAL_HEIGHT - ball.height 
            ball.dy = -ball.dy 
        end
    end

    if love.keyboard.isDown('w') then 
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then 
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then 
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then 
        player2.dy = PADDLE_SPEED 
    else
        player2.dy = 0
    end

    if gameState == 'play' then 
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    elseif key == 'enter' or key == 'return' then 
        if gameState == 'start' then 
            gameState = 'serve'
        elseif gameState == 'serve' then 
            gameState = 'play'
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then 
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. ' to serve', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    -- draw scores
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1.score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2.score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    player1:render()
    player2:render()
    ball:render()

    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end