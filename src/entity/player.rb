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
                    "idle" => OZ::Animation.static(Gosu::Image.new(File.join(RES_DIR, "player/idle.png"))),
                    "walk" => OZ::Animation.new(
                        (0..3).map { |i| Gosu::Image.new(File.join(RES_DIR, "player/walk#{i}.png")) },
                        7,
                    )
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
                bullet = Bullet.new(
                    friendly: true,
                    position: bounding_box.centre,
                    speed: 20,
                    damage: 20,
                )
            
                cursor_world_pos = OZ::Input.cursor - Game.offset
                bullet.rotation = Gosu.angle(bounding_box.centre.x, bounding_box.centre.y, cursor_world_pos.x, cursor_world_pos.y)
                bullet.register
            end
        end

        def update_movement
            # Handle movement and wall checking in both X and Y directions
            # Means you can still slide along a horizontal wall when holding W+D, for example

            very_original_position = position.dup

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

            if very_original_position != position
                self.animation = "walk"
            else
                self.animation = "idle"
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
