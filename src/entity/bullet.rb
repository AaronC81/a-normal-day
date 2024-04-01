module GosuGameJam6
    class Bullet < OZ::Entity
        SCREEN_PADDING = 50

        def initialize(friendly:, **kw)
            super(
                animations: {
                    "idle" => OZ::Animation.placeholder(width, height, Gosu::Color::BLUE)
                },
                **kw
            )
            @friendly = friendly
        end

        def friendly?
            @friendly
        end

        def width
            5
        end

        def height
            30
        end

        def speed
            20
        end

        def damage
            20
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

            # Check if this hit an enemy
            if friendly?
                if (enemy = Game::ENEMIES.items.find { |enemy| colliding_with?(enemy.bounding_box) })
                    enemy.hit_by(self)
                    unregister
                    return
                end
            else
                if colliding_with?(Game.player.bounding_box)
                    Game.player.hit_by(self)
                    unregister
                    return
                end
            end

            # Check if this hit a wall, or went out of an open area
            if Game::WALLS.items.any? { |wall| colliding_with?(wall.bounding_box) } || !Game::OPEN_AREAS.items.any? { |area| colliding_with?(area.full_bounding_box) }
                # TODO: "fizzle" animation
                unregister
                return
            end
        end

        def front_point
            # Align to the centre of the bullet
            OZ::Point[
                position.x + Gosu.offset_x(self.rotation + 90, width / 2),
                position.y + Gosu.offset_y(self.rotation + 90, width / 2),
            ]
        end

        def back_point
            fp = front_point
            OZ::Point[
                fp.x + Gosu.offset_x(self.rotation, -height),
                fp.y + Gosu.offset_y(self.rotation, -height),
            ]
        end

        def mid_point
            fp = front_point
            bp = back_point
            OZ::Point[
                (fp.x + bp.x) / 2,
                (fp.y + bp.y) / 2,
            ]
        end

        def colliding_with?(box)
            # Test three different points to check whether there's been a collision
            # Should help make for more accurate collisions at high speed
            box.point_inside?(front_point) || box.point_inside?(back_point) || box.point_inside?(mid_point)
        end
    end
end
