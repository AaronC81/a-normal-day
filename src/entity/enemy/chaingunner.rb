require_relative '../enemy'

module GosuGameJam6
    class Chaingunner < Enemy
        def initialize(**kw)
            super(
                animations: {
                    "idle" => OZ::Animation.static(Gosu::Image.new(File.join(RES_DIR, "enemy/chaingunner.png")))
                },
                **kw
            )
            @next_fire_timer = rand(200..400)
            @firing_timer = 0
        end

        def max_health
            5
        end

        def speed
            1.6
        end

        def update
            super

            los = Game.line_of_sight?(position, max_distance: 1200)

            @next_fire_timer -= 1
            if @next_fire_timer <= 0
                if los
                    @firing_timer = rand(15..35)
                end

                @next_fire_timer = 120
            end

            if @firing_timer > 0
                @firing_timer -= 1
                if @firing_timer % 3 == 0
                    Sounds::LASER_QUICK.play(0.5)
                    fire_at_player(
                        speed: 10,
                        damage: 1,
                        spread: 5
                    )
                end
            end

            if los
                old_position = position.dup
                self.position += vector_to_player * speed
                unless valid_position?
                    self.position = old_position
                end

                self.mirror_x = (vector_to_player.x > 0)
            end
        end
    end
end
