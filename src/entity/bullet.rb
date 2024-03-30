module GosuGameJam6
    class Bullet < OZ::Entity
        SCREEN_PADDING = 50

        def initialize(**kw)
            super(
                animations: {
                    "idle" => OZ::Animation.placeholder(5, 30, Gosu::Color::BLUE)
                },
                **kw
            )
        end

        def speed
            30
        end

        def update
            super

            # Movement
            position.x += Gosu.offset_x(self.rotation, speed)
            position.y += Gosu.offset_y(self.rotation, speed)

            # If this is far enough off the screen, remove it
            if position.x < -SCREEN_PADDING ||
               position.x > (GosuGameJam6::Game::WIDTH + SCREEN_PADDING) ||
               position.y < -SCREEN_PADDING ||
               position.y > (GosuGameJam6::Game::HEIGHT + SCREEN_PADDING)
                unregister
            end

            # TODO: also destroy when this hits a wall. `bounding_box` doesn't work with rotation,
            #       probably want to check points on each side instead
        end
    end
end
