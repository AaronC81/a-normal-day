module GosuGameJam6
    class Player < OZ::Entity
        WIDTH = 30
        HEIGHT = 30

        SPEED = 5

        def initialize(**kw)
            super(
                animations: {
                    "idle" => OZ::Animation.placeholder(WIDTH, HEIGHT, Gosu::Color::RED)
                },
                **kw
            )
        end

        def update
            super

            # Movement
            self.position.x -= SPEED if Gosu.button_down?(Gosu::KB_A)
            self.position.x += SPEED if Gosu.button_down?(Gosu::KB_D)
            self.position.y -= SPEED if Gosu.button_down?(Gosu::KB_W)
            self.position.y += SPEED if Gosu.button_down?(Gosu::KB_S)
        end
    end
end
