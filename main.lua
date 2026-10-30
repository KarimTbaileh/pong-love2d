function love.load()
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    player1 = {
        x = 50,
        y = 250,
        width = 10,
        height = 100,
        speed = 400
    }

    player2 = {
        x = 740,
        y = 250,
        width = 10,
        height = 100,
        speed = 400
    }
end

function love.update(dt)
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

    if player1.y < 0 then 
        player1.y = 0 
    end
    if player1.y + player1.height > 600 then 
        player1.y = 600 - player1.height 
    end

    if player2.y < 0 then 
        player2.y = 0 
    end
    if player2.y + player2.height > 600 then 
        player2.y = 600 - player2.height 
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', player1.x, player1.y, player1.width, player1.height)
    love.graphics.rectangle('fill', player2.x, player2.y, player2.width, player2.height)
end