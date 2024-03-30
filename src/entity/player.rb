require_relative 'bullet'

module GosuGameJam6
    class Player < OZ::Entity
        WIDTH = 30
        HEIGHT = 30

        SPEED = 5

        def initialize(**kw)
            super(
                animations: {
                    "idle" => OZ::Animation.placeholder(WIDTH, HEIGHT, Gosu::Color::GREEN)
                },
                **kw
            )
        end

        def update
            super
            
            update_movement

            if OZ::TriggerCondition.watch(Gosu.button_down?(Gosu::MS_LEFT)) == :on
                bullet = Bullet.new(position: centre_position)
                bullet.rotation = Gosu.angle(centre_position.x, centre_position.y, OZ::Input.cursor.x, OZ::Input.cursor.y)
                bullet.register
            end
        end

        def update_movement
            # Handle movement and wall checking in both X and Y directions
            # Means you can still slide along a horizontal wall when holding W+D, for example

            old_position = position.dup
            position.x -= SPEED if Gosu.button_down?(Gosu::KB_A)
            position.x += SPEED if Gosu.button_down?(Gosu::KB_D)
            if Game::WALLS.items.any? { |wall| wall.bounding_box.overlaps?(bounding_box) }
                # Cancel move if it means we hit a wall
                self.position = old_position
            end

            old_position = position.dup
            position.y -= SPEED if Gosu.button_down?(Gosu::KB_W)
            position.y += SPEED if Gosu.button_down?(Gosu::KB_S)
            if Game::WALLS.items.any? { |wall| wall.bounding_box.overlaps?(bounding_box) }
                # Cancel move if it means we hit a wall
                self.position = old_position
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
