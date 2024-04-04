require_relative '../enemy'

module GosuGameJam6
    class MachineGunTurret < Enemy
        def initialize(**kw)
            super(
                animations: {
                    "idle" => OZ::Animation.static(Gosu::Image.new(File.join(RES_DIR, "enemy/machine_gun_turret.png")))
                },
                **kw
            )
            @next_fire_timer = rand(200..300)
            @firing_timer = 0
        end

        def width
            50
        end

        def height
            50
        end

        def max_health
            120
        end

        def update
            super

            @next_fire_timer -= 1
            if @next_fire_timer <= 0
                if Game.line_of_sight?(position, max_distance: 800)
                    @firing_timer = 30
                end

                @next_fire_timer = 120
            end

            if @firing_timer > 0
                @firing_timer -= 1
                if @firing_timer % 5 == 0
                    fire_at_player(
                        speed: 10,
                        damage: 10,
                        spread: 5
                    )
                end
            end
        end
    end
end
