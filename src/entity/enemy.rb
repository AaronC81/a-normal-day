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
        end

        def die
            unregister
        end

        def angle_to_player
            Gosu.angle(bounding_box.centre.x, bounding_box.centre.y, Game.player.bounding_box.centre.x, Game.player.bounding_box.centre.y)
        end

        def vector_to_player
            OZ::Point[Gosu.offset_x(angle_to_player, 1), Gosu.offset_y(angle_to_player, 1)]
        end

        def fire_at_player(spread:, **kw)
            bullet = Bullet.new(friendly: false, position: bounding_box.centre, **kw)
            bullet.rotation = angle_to_player + rand(-spread .. spread)
            bullet.register(Game::GAME)

            bullet
        end

        def take_damage(amount)
            super
            Sounds::ENEMY_HIT.play(0.7)
        end
    end
end
