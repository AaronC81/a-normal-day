require_relative 'character'

module GosuGameJam6
    class Enemy < Character
        def initialize(**kw)
            super(**kw)
        end

        def die
            unregister
        end

        def angle_to_player
            my_centre = bounding_box.centre
            player_centre = Game.player.bounding_box.centre
            Gosu.angle(my_centre.x, my_centre.y, player_centre.x, player_centre.y)
        end

        def vector_to_player
            angle = angle_to_player
            OZ::Point[Gosu.offset_x(angle, 1), Gosu.offset_y(angle, 1)]
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
