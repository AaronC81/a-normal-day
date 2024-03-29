require_relative 'bullet'

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
            position.x -= SPEED if Gosu.button_down?(Gosu::KB_A)
            position.x += SPEED if Gosu.button_down?(Gosu::KB_D)
            position.y -= SPEED if Gosu.button_down?(Gosu::KB_W)
            position.y += SPEED if Gosu.button_down?(Gosu::KB_S)

            if OZ::TriggerCondition.watch(Gosu.button_down?(Gosu::MS_LEFT)) == :on
                bullet = Bullet.new(position: centre_position)
                bullet.rotation = Gosu.angle(centre_position.x, centre_position.y, OZ::Input.cursor.x, OZ::Input.cursor.y)
                bullet.register
            end
        end

        def centre_position
            OZ::Point[
                position.x + image.width / 2,
                position.y + image.height / 2,
            ]
        end
    end
end
