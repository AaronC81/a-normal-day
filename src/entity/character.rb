module GosuGameJam6
    class Character < OZ::Entity
        def initialize(**kw)
            super(**kw)
            @health = max_health
        end

        def max_health
            raise 'abstract: max_health'
        end
        
        attr_accessor :health

        def hit_by(bullet)
            take_damage bullet.damage
        end

        def take_damage(amount)
            @health -= amount
            die if @health <= 0
        end

        def die
            raise 'abstract: die'
        end
    end
end
