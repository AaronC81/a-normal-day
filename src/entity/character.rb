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

        def valid_position?
            !Game::WALLS.items.any? { |wall| wall.bounding_box.overlaps?(bounding_box) } \
                && Game::OPEN_AREAS.items.any? { |area| area.bounding_box.overlaps?(bounding_box) }
        end
    end
end
