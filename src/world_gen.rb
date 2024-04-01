require_relative 'entity/wall'

module GosuGameJam6
    class WorldGen
        # Returns (unregistered) `OpenArea` instances for a corridor description.
        def corridor_areas(corridors)
            areas = []

            next_origin = OZ::Point[0, 0]

            # First, create the straights. We can deal with corners later...
            (corridors + [nil]).each_cons(2).each do |(length, width, direction), (_, next_width, _)|
                case direction
                when :left, :right
                    areas << OpenArea.new(width: length, height: width, position: next_origin)
                    if next_width
                        next_origin += OZ::Point[length - next_width, width]
                    end
                when :up, :down
                    areas << OpenArea.new(width: width, height: length, position: next_origin)
                    if next_width
                        next_origin += OZ::Point[width, length - next_width]
                    end
                end
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
                this_length = rand(400..1200)
                this_direction = available_directions_by_axis[axis].sample
                this_width = rand(300..600)

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
    end
end
