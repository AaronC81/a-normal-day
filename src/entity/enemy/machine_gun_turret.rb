require_relative '../enemy'

module GosuGameJam6
    class MachineGunTurret < Enemy
        def initialize(**kw)
            super(**kw)
            @next_fire_timer = rand(200..300)
            @firing_timer = 0
        end

        def width
            30
        end

        def height
            30
        end

        def max_health
            80
        end

        def update
            super

            @next_fire_timer -= 1
            if @next_fire_timer <= 0
                if Game.line_of_sight?(position)
                    @firing_timer = 30
                end

                @next_fire_timer = 120
            end

            if @firing_timer > 0
                @firing_timer -= 1
                if @firing_timer % 5 == 0
                    bullet = Bullet.new(friendly: false, position: bounding_box.centre)
                    bullet.rotation = Gosu.angle(bounding_box.centre.x, bounding_box.centre.y, Game.player.bounding_box.centre.x, Game.player.bounding_box.centre.y)
                    bullet.register    
                end
            end
        end
    end
end
