require_relative 'character'

module GosuGameJam6
    class Enemy < Character
        def initialize(**kw)
            super(
                animations: {
                    "idle" => OZ::Animation.placeholder(width, height, Gosu::Color::RED)
                },
                **kw
            )

            @next_fire_timer = rand(100..200)
        end

        def width
            30
        end

        def height
            30
        end

        def max_health
            50
        end

        def die
            unregister
        end

        def update
            super

            @next_fire_timer -= 1
            if @next_fire_timer <= 0
                bullet = Bullet.new(friendly: false, position: bounding_box.centre)
                bullet.rotation = Gosu.angle(bounding_box.centre.x, bounding_box.centre.y, Game.player.bounding_box.centre.x, Game.player.bounding_box.centre.y)
                bullet.register

                @next_fire_timer = rand(30..150)
            end
        end
    end
end
