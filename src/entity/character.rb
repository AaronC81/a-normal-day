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
            return if dead?
            @health -= amount
            die if @health <= 0
        end

        def restore_health(amount)
            @health += amount
            @health = max_health if @health > max_health
        end

        def die
            raise 'abstract: die'
        end

        def dead?
            @health <= 0
        end

        def valid_position?
            # All four corners of the character must be touching an open area
            # (Doesn't need to be the same one, though)
            bb = bounding_box
            points = [
                position,
                position + OZ::Point[bb.width, 0],
                position + OZ::Point[0, bb.height],
                position + OZ::Point[bb.width, bb.height],
            ]
            area_check = points.all? { |pt| Game::OPEN_AREAS.items.any? { |area| area.bounding_box.point_inside?(pt) } }

            # Can't be inside a wall
            wall_check = !Game::WALLS.items.any? { |wall| wall.bounding_box.overlaps?(bounding_box) } \

            area_check && wall_check
        end
    end
end
