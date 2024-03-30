module GosuGameJam6
    class Bullet < OZ::Entity
        SCREEN_PADDING = 50

        def initialize(**kw)
            super(
                animations: {
                    "idle" => OZ::Animation.placeholder(width, height, Gosu::Color::BLUE)
                },
                **kw
            )
        end

        def width
            5
        end

        def height
            30
        end

        def speed
            30
        end

        def draw
            super
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

            if Game::WALLS.items.any? { |wall| colliding_with?(wall.bounding_box) }
                # TODO: "fizzle" animation
                unregister
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

        def colliding_with?(box)
            # Test two different points to check whether there's been a collision - each end of the
            # projectile
            # Should help make for more accurate collisions at high speed
            box.point_inside?(front_point) || box.point_inside?(back_point)
        end
    end
end
