require_relative 'entity/wall'

module GosuGameJam6
    class WorldGen
        # Given a list of areas, returns a list of (unregistered) enemies to populate them with.
        def populate_areas(areas, density, enemy_pool)
            enemies = []

            far_edge_padding = 70

            areas = areas[1..-1]
            areas.each do |area|
                size = area.width * area.height
                total_number_of_enemies = ((size / 100000) * density).ceil

                total_number_of_enemies.times do
                    x = area.position.x + rand(0..(area.width - far_edge_padding))
                    y = area.position.y + rand(0..(area.height - far_edge_padding))
                    enemy = enemy_pool.sample.new(position: OZ::Point[x, y])
                    enemies << enemy
                end
            end

            enemies
        end

        # Returns (unregistered) `OpenArea` instances for a corridor description.
        def corridor_areas(corridors)
            areas = []

            next_origin = OZ::Point[0, 0]
            is_first = true

            # First, create the straights. We can deal with corners later...
            (corridors + [nil]).each_cons(2).each do |(length, width, direction), (_, next_width, _)|
                case direction
                when :left, :right
                    areas << OpenArea.new(width: length, height: width, position: next_origin, has_walls: true)
                    if next_width
                        next_origin += OZ::Point[length - next_width, width]
                    end
                when :up, :down
                    areas << OpenArea.new(width: width, height: length, position: next_origin, has_walls: !(direction == :down && !is_first))
                    if next_width
                        next_origin += OZ::Point[width, length - next_width]
                    end
                end

                is_first = false
            end
            
            areas
        end

        # Create a description of a series of corridors which will compose the level.
        #
        # Form: [[length, width, direction], ...] where direction is a symbol `:up`, `:left`, etc
        def generate_corridor_description(total_length)
            # Logic: we can naively generate a series of corridors which never overlap as long as:
            #   - One direction is omitted, so you can't make a spiral which hits itself
            #   - We don't choose opposing directions immediately (e.g. you need a `:left` or
            #     `:right` after an `:up` or `:down`)
            
            available_directions = [:up, :down, :left, :right]
            available_directions.delete(available_directions.sample) # Remove one

            available_directions_by_axis = {
                horizontal: available_directions.select { |d| d == :left || d == :right },
                vertical:   available_directions.select { |d| d == :up   || d == :down  },
            }

            axis = [:horizontal, :vertical].sample

            corridors = []
            length_so_far = 0
            until length_so_far >= total_length
                if length_so_far == 0
                    this_length = 800
                    this_width = 200
                else
                    this_length = rand(400..2000)
                    this_width = rand(200..600)
                end
                this_direction = available_directions_by_axis[axis].sample

                # Snap to multiples of floor tile size
                case axis
                when :horizontal
                    this_length = round_up_to(this_length, OpenArea::FLOOR_SPRITE.width)
                    this_width = round_up_to(this_width, OpenArea::FLOOR_SPRITE.height)
                when :vertical
                    this_length = round_up_to(this_length, OpenArea::FLOOR_SPRITE.height)
                    this_width = round_up_to(this_width, OpenArea::FLOOR_SPRITE.width)
                end

                corridors << [this_length, this_width, this_direction]

                # Invert axis
                axis = {
                    horizontal: :vertical,
                    vertical: :horizontal,
                }[axis]

                length_so_far += this_length
            end

            corridors
        end

        def round_up_to(num, mult)
            (num / mult.to_f).ceil * mult
        end
    end
end
