require_relative 'bullet'
require_relative 'character'

module GosuGameJam6
    class Player < Character
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

        def max_health
            100
        end

        def update
            super
            
            update_movement

            if OZ::TriggerCondition.watch(Gosu.button_down?(Gosu::MS_LEFT)) == :on
                bullet = Bullet.new(friendly: true, position: bounding_box.centre)
            
                cursor_world_pos = OZ::Input.cursor - Game.offset
                bullet.rotation = Gosu.angle(bounding_box.centre.x, bounding_box.centre.y, cursor_world_pos.x, cursor_world_pos.y)
                bullet.register
            end
        end

        def update_movement
            # Handle movement and wall checking in both X and Y directions
            # Means you can still slide along a horizontal wall when holding W+D, for example

            old_position = position.dup
            position.x -= SPEED if Gosu.button_down?(Gosu::KB_A)
            position.x += SPEED if Gosu.button_down?(Gosu::KB_D)
            unless valid_position?
                # Cancel move if it means we hit a wall
                self.position = old_position
            end

            old_position = position.dup
            position.y -= SPEED if Gosu.button_down?(Gosu::KB_W)
            position.y += SPEED if Gosu.button_down?(Gosu::KB_S)
            unless valid_position?
                # Cancel move if it means we hit a wall
                self.position = old_position
            end
        end

        def valid_position?
            !Game::WALLS.items.any? { |wall| wall.bounding_box.overlaps?(bounding_box) } \
                && Game::OPEN_AREAS.items.any? { |area| area.bounding_box.overlaps?(bounding_box) }
        end

        def centre_position
            OZ::Point[
                position.x + image.width / 2,
                position.y + image.height / 2,
            ]
        end
    end
end
