require_relative 'bullet'

module GosuGameJam6
    class Enemy < OZ::Entity
        def initialize(**kw)
            super(
                animations: {
                    "idle" => OZ::Animation.placeholder(width, height, Gosu::Color::RED)
                },
                **kw
            )
            @health = max_health
        end

        attr_accessor :health

        def width
            30
        end

        def height
            30
        end

        def max_health
            50
        end

        def hit_by(bullet)
            take_damage bullet.damage
        end

        def take_damage(amount)
            @health -= amount
            die if @health <= 0
        end

        def die
            unregister
        end
    end
end
