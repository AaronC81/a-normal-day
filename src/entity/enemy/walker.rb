require_relative '../enemy'

module GosuGameJam6
    class Walker < Enemy
        def initialize(**kw)
            super(
                animations: {
                    "idle" => OZ::Animation.static(Gosu::Image.new(File.join(RES_DIR, "enemy/walker.png")))
                },
                **kw
            )
            @next_fire_timer = rand(200..300)
        end

        def width
            30
        end

        def height
            30
        end

        def max_health
            8
        end

        def speed
            1.4
        end

        def update
            super

            los = Game.line_of_sight?(position)

            @next_fire_timer -= 1
            if @next_fire_timer <= 0
                if los
                    Sounds::LASER_SLOW.play(0.3)
                    fire_at_player(
                        speed: 7,
                        damage: 1,
                        spread: 15
                    )
                end

                @next_fire_timer = rand(30..120)
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
