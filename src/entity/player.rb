require_relative 'bullet'
require_relative 'character'

module GosuGameJam6
    class Player < Character
        SPEED = 5

        def initialize(weapon_sprite:, weapon_cooldown:, weapon_is_automatic:, weapon_spread:, **kw)
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

            @weapon_sprite = weapon_sprite

            @weapon_is_automatic = weapon_is_automatic
            @weapon_cooldown = weapon_cooldown
            @weapon_spread = weapon_spread
            @weapon_cooldown_remaining = 0
        end

        def max_health
            100
        end

        def update
            super
            
            update_movement

            @weapon_cooldown_remaining -= 1 if @weapon_cooldown_remaining > 0

            # Determine whether the weapon should fire this tick
            if @weapon_is_automatic
                firing = Gosu.button_down?(Gosu::MS_LEFT)
            else
                firing = (OZ::TriggerCondition.watch(Gosu.button_down?(Gosu::MS_LEFT)) == :on)
            end
            firing &&= (@weapon_cooldown_remaining <= 0)
            if firing
                bullet = Bullet.new(
                    friendly: true,
                    position: bounding_box.centre,
                    speed: 20,
                    damage: 20,
                )
            
                cursor_world_pos = OZ::Input.cursor - Game.offset
                bullet.rotation = Gosu.angle(bounding_box.centre.x, bounding_box.centre.y, cursor_world_pos.x, cursor_world_pos.y)
                bullet.rotation += rand(-@weapon_spread .. @weapon_spread)
                bullet.register

                @weapon_cooldown_remaining = @weapon_cooldown
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

        def draw
            cursor_world_pos = OZ::Input.cursor - Game.offset
            self.mirror_x = cursor_world_pos.x < centre_position.x

            super

            # Draw weapon too, rotated to face cursor
            weapon_origin = OZ::Point[
                position.x + image.width / 2,
                position.y + (image.height / 5) * 3,
            ]
            angle = Gosu.angle(weapon_origin.x, weapon_origin.y, cursor_world_pos.x, cursor_world_pos.y) - 90
            @weapon_sprite.draw_rot(weapon_origin.x, weapon_origin.y, 0, angle, 0.5, 0.5, 1, mirror_x ? -1 : 1)
        end
    end
end
