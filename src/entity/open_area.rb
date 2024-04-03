module GosuGameJam6
    class OpenArea < OZ::Entity
        WALL_SPRITE = Gosu::Image.new(File.join(RES_DIR, "scene/wall0.png")) # TODO the others
        FLOOR_SPRITE = Gosu::Image.new(File.join(RES_DIR, "scene/floor.png"))

        def initialize(width:, height:, has_walls:, **kw)
            super(
                animations: {
                    "idle" => OZ::Animation.placeholder(width, height, Gosu::Color::FUCHSIA)
                },
                **kw
            )
            
            @width = width
            @height = height
            @has_walls = has_walls
        end

        attr_reader :width, :height, :has_walls

        def draw
            (width / FLOOR_SPRITE.width).times do |x|
                (height / FLOOR_SPRITE.height).times do |y|
                    # If this is the top row, actually draw walls
                    if y == 0 && has_walls
                        WALL_SPRITE.draw(
                            position.x + x * WALL_SPRITE.width,
                            position.y - (WALL_SPRITE.height - FLOOR_SPRITE.height),
                            -2
                        )
                    else
                        FLOOR_SPRITE.draw(
                            position.x + x * FLOOR_SPRITE.width,
                            position.y + y * FLOOR_SPRITE.height,
                            -1
                        )
                    end
                end
            end
        end
    end
end
