require_relative '../enemy'

module GosuGameJam6
    class Blaster < Enemy
        def initialize(**kw)
            super(
                animations: {
                    "idle" => OZ::Animation.static(Gosu::Image.new(File.join(RES_DIR, "enemy/blaster.png")))
                },
                **kw
            )
            @next_fire_timer = rand(200..300)
        end

        def max_health
            10
        end

        def speed
            0.8
        end

        def update
            super

            los = Game.line_of_sight?(position, max_distance: 500)

            @next_fire_timer -= 1
            if @next_fire_timer <= 0
                if los
                    Sounds::LASER_HEAVY.play(0.3)
                    6.times do
                        fire_at_player(
                            speed: 5,
                            damage: 1,
                            spread: 40
                        )
                    end
                end

                @next_fire_timer = rand(120..180)
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
