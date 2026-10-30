function love.load()
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    love.window.setTitle('Pong Game')

    smallFont = love.graphics.newFont(15)
    scoreFont = love.graphics.newFont(40)
    titleFont = love.graphics.newFont(60)

    gameState = 'menu'

    player1 = {
        x = 10, y = 250, width = 15, height = 100, speed = 400, score = 0
    }

    player2 = {
        x = 775, y = 250, width = 15, height = 100, speed = 400, score = 0
    }

    ball = {
        x = 395, y = 295, width = 10, height = 10, dx = 300, dy = 200
    }

    servingPlayer = 1
    winningPlayer = 0
    base_ball_speed = 300
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'enter' or key == 'return' then
        if gameState == 'menu' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
            ball.dx = (servingPlayer == 1 and 1 or -1) * base_ball_speed
            ball.dy = love.math.random(-200, 200)
        elseif gameState == 'done' then
            gameState = 'serve'
            player1.score = 0
            player2.score = 0
            servingPlayer = 1
            base_ball_speed = 300
        end
    end
end

function love.update(dt)
    if gameState ~= 'play' and gameState ~= 'serve' then
        return
    end

    if love.keyboard.isDown('w') then
        player1.y = player1.y - player1.speed * dt
    elseif love.keyboard.isDown('s') then
        player1.y = player1.y + player1.speed * dt
    end

    if love.keyboard.isDown('up') then
        player2.y = player2.y - player2.speed * dt
    elseif love.keyboard.isDown('down') then
        player2.y = player2.y + player2.speed * dt
    end

    if player1.y < 0 then player1.y = 0 end
    if player1.y + player1.height > 600 then player1.y = 600 - player1.height end
    if player2.y < 0 then player2.y = 0 end
    if player2.y + player2.height > 600 then player2.y = 600 - player2.height end

    if gameState == 'serve' then
        ball.dx = 0
        ball.dy = 0
        if servingPlayer == 1 then
            ball.x = player1.x + player1.width + 5
            ball.y = player1.y + player1.height / 2 - ball.height / 2
        else
            ball.x = player2.x - ball.width - 5
            ball.y = player2.y + player2.height / 2 - ball.height / 2
        end
        return
    end

    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    end
    if ball.y + ball.height >= 600 then
        ball.y = 600 - ball.height
        ball.dy = -ball.dy
    end

    if checkCollision(ball, player1) then
        ball.x = player1.x + player1.width
        local relativeIntersectY = (player1.y + player1.height / 2) - (ball.y + ball.height / 2)
        local normalizedRelIntersectY = relativeIntersectY / (player1.height / 2)
        local bounceAngle = normalizedRelIntersectY * (5 * math.pi / 12)
        
        local speed = math.sqrt(ball.dx * ball.dx + ball.dy * ball.dy) * 1.05
        if speed > 800 then speed = 800 end
        
        ball.dx = speed * math.cos(bounceAngle)
        ball.dy = -speed * math.sin(bounceAngle)
    end

    if checkCollision(ball, player2) then
        ball.x = player2.x - ball.width
        local relativeIntersectY = (player2.y + player2.height / 2) - (ball.y + ball.height / 2)
        local normalizedRelIntersectY = relativeIntersectY / (player2.height / 2)
        local bounceAngle = normalizedRelIntersectY * (5 * math.pi / 12)
        
        local speed = math.sqrt(ball.dx * ball.dx + ball.dy * ball.dy) * 1.05
        if speed > 800 then speed = 800 end
        
        ball.dx = -speed * math.cos(bounceAngle)
        ball.dy = -speed * math.sin(bounceAngle)
    end

    if ball.x < 0 then
        player2.score = player2.score + 1
        resetBall(2)
    elseif ball.x > 800 then
        player1.score = player1.score + 1
        resetBall(1)
    end

    if player1.score >= 5 or player2.score >= 5 then
        winningPlayer = player1.score > player2.score and 1 or 2
        gameState = 'done'
    end
end

function resetBall(lastServer)
    base_ball_speed = base_ball_speed + 20
    if base_ball_speed > 600 then base_ball_speed = 600 end

    ball.x = 395
    ball.y = 295
    ball.dx = 0
    ball.dy = 0
    
    servingPlayer = (lastServer == 1) and 2 or 1
    gameState = 'serve'
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

function love.draw()
    love.graphics.setFont(scoreFont)

    if gameState == 'menu' then
        love.graphics.setFont(titleFont)
        love.graphics.printf('PONG', 0, 200, 800, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to Start', 0, 320, 800, 'center')
        love.graphics.printf('Press Esc to Quit', 0, 350, 800, 'center')
        return
    end

    if gameState == 'done' then
        love.graphics.setFont(titleFont)
        love.graphics.printf('Player ' .. winningPlayer .. ' Wins!', 0, 200, 800, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to Restart', 0, 350, 800, 'center')
        love.graphics.setFont(scoreFont)
        love.graphics.print(tostring(player1.score), 320, 50)
        love.graphics.print(tostring(player2.score), 460, 50)
        return
    end

    if gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Player " .. servingPlayer .. "'s serve", 0, 10, 800, 'center')
        love.graphics.printf("Press Enter to serve", 0, 30, 800, 'center')
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1.score), 320, 50)
    love.graphics.print(tostring(player2.score), 460, 50)

    love.graphics.setColor(1, 1, 1, 0.6)
    for i = 0, 590, 20 do
        love.graphics.rectangle('fill', 398, i, 4, 12)
    end
    love.graphics.setColor(1, 1, 1)

    love.graphics.rectangle('fill', player1.x, player1.y, player1.width, player1.height)
    love.graphics.rectangle('fill', player2.x, player2.y, player2.width, player2.height)
    love.graphics.rectangle('fill', ball.x, ball.y, ball.width, ball.height)
end