require_relative 'bullet'
require_relative 'character'

module GosuGameJam6
    class Player < Character
        MUZZLE_FLASHES = [
            Gosu::Image.new(File.join(RES_DIR, "weapon/flash0.png")),
            Gosu::Image.new(File.join(RES_DIR, "weapon/flash1.png")),
            Gosu::Image.new(File.join(RES_DIR, "weapon/flash2.png")),
            Gosu::Image.new(File.join(RES_DIR, "weapon/flash3.png")),
        ]

        UPGRADES = [
            ["Fire faster", ->{
                Game.player.weapon_cooldown = (Game.player.weapon_cooldown * 0.75).floor.to_i
            }],
            ["More weapon damage", ->{
                Game.player.weapon_damage = (Game.player.weapon_damage * 1.25).ceil.to_i
            }],
            ["Move faster", ->{
                Game.player.speed = (Game.player.speed * 1.15).ceil.to_i
            }],
            ["Longer immunity after getting hit", ->{
                Game.player.invinciblity_time = (Game.player.invinciblity_time * 1.5).ceil.to_i
            }],
            ["Disable automatic fire, but triple damage", ->{
                Game.player.weapon_is_automatic = false
                Game.player.weapon_damage *= 3
            }],
            ["Better accuracy", ->{
                Game.player.weapon_spread -= 2
                Game.player.weapon_spread = 0 if Game.player.weapon_spread < 0
            }]
        ]

        def initialize(weapon_sprite:, weapon_sound:, weapon_cooldown:, weapon_is_automatic:, weapon_spread:, weapon_damage:, **kw)
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
            @weapon_sound = weapon_sound

            @weapon_is_automatic = weapon_is_automatic
            @weapon_cooldown = weapon_cooldown
            @weapon_spread = weapon_spread
            @weapon_cooldown_remaining = 0
            @weapon_damage = 2

            @muzzle_flash_counter = 0
            @muzzle_flash_sprite = nil

            @speed = 5

            @invinciblity_time = 45
            @invinciblity_time_remaining = 0
        end

        attr_accessor :weapon_cooldown, :weapon_spread, :weapon_is_automatic, :weapon_damage, :speed, :invinciblity_time

        def max_health
            10
        end

        def update
            super
            
            update_movement

            @invinciblity_time_remaining -= 1 if @invinciblity_time_remaining > 0
            @weapon_cooldown_remaining -= 1 if @weapon_cooldown_remaining > 0

            # Determine whether the weapon should fire this tick
            if @weapon_is_automatic
                firing = Gosu.button_down?(Gosu::MS_LEFT)
            else
                firing = (OZ::TriggerCondition.watch(Gosu.button_down?(Gosu::MS_LEFT)) == :on)
            end
            firing &&= (@weapon_cooldown_remaining <= 0)
            if firing
                @weapon_sound.play(0.3)

                bullet = Bullet.new(
                    friendly: true,
                    position: bounding_box.centre,
                    speed: 20,
                    damage: @weapon_damage,
                )
            
                cursor_world_pos = OZ::Input.cursor - Game.offset
                bullet.rotation = Gosu.angle(bounding_box.centre.x, bounding_box.centre.y, cursor_world_pos.x, cursor_world_pos.y)
                bullet.rotation += rand(-@weapon_spread .. @weapon_spread)

                # Move the bullet a bit past the player, so it doesn't appear to spawn inside them
                bullet.position.x += Gosu.offset_x(bullet.rotation, image.width)
                bullet.position.y += Gosu.offset_y(bullet.rotation, image.width)

                bullet.register(Game::GAME)

                @weapon_cooldown_remaining = @weapon_cooldown
                @muzzle_flash_counter = 3
                @muzzle_flash_sprite = MUZZLE_FLASHES.sample
            end
        end

        def take_damage(amount)
            if @invinciblity_time_remaining > 0
                return
            end

            super
            @invinciblity_time_remaining = @invinciblity_time
            Sounds::PLAYER_HIT.play
        end

        def update_movement
            # Handle movement and wall checking in both X and Y directions
            # Means you can still slide along a horizontal wall when holding W+D, for example

            very_original_position = position.dup

            old_position = position.dup
            position.x -= @speed if Gosu.button_down?(Gosu::KB_A)
            position.x += @speed if Gosu.button_down?(Gosu::KB_D)
            unless valid_position?
                # Cancel move if it means we hit a wall
                self.position = old_position
            end

            old_position = position.dup
            position.y -= @speed if Gosu.button_down?(Gosu::KB_W)
            position.y += @speed if Gosu.button_down?(Gosu::KB_S)
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

            self.opacity = (@invinciblity_time_remaining > 0 ? 0.4 : 1)

            # Draw weapon too, rotated to face cursor
            weapon_origin = centre_position
            angle = Gosu.angle(weapon_origin.x, weapon_origin.y, cursor_world_pos.x, cursor_world_pos.y)
            @weapon_sprite.draw_rot(weapon_origin.x, weapon_origin.y, 0, angle  - 90, 0.5, 0.5, 1, mirror_x ? -1 : 1, Gosu::Color.argb(opacity * 255, 255, 255, 255))

            if @muzzle_flash_counter > 0
                @muzzle_flash_counter -= 1
                flash_position = weapon_origin.dup
                flash_position.x += Gosu.offset_x(angle, image.width * 0.75)
                flash_position.y += Gosu.offset_y(angle, image.width * 0.75)
                @muzzle_flash_sprite.draw_rot(flash_position.x, flash_position.y, 0, angle)
            end
        end
    end
end
