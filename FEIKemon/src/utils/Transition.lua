local Transition = {
    alpha = 0,
    state = "none",
    speed = 3,
    callback = nil
}

function Transition.start(speed, callback)
    Transition.speed = speed or 3
    Transition.callback = callback
    Transition.state = "out"
end

function Transition.update(dt)
    if Transition.state == "out" then
        Transition.alpha = math.min(Transition.alpha + Transition.speed * dt, 1)
        if Transition.alpha >= 1 then
            if Transition.callback then Transition.callback() end
            Transition.state = "in"
        end
    elseif Transition.state == "in" then
        Transition.alpha = math.max(Transition.alpha - Transition.speed * dt, 0)
        if Transition.alpha <= 0 then
            Transition.state = "none"
        end
    end
end

function Transition.draw()
    if Transition.alpha > 0 then
        love.graphics.setColor(0, 0, 0, Transition.alpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return Transition