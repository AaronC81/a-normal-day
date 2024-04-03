module GosuGameJam6
    class OpenArea < OZ::Entity
        FLOOR_SPRITE = Gosu::Image.new(File.join(RES_DIR, "scene/floor.png"))

        def initialize(width:, height:, **kw)
            super(
                animations: {
                    "idle" => OZ::Animation.placeholder(width, height, Gosu::Color::FUCHSIA)
                },
                **kw
            )
            
            @width = width
            @height = height
        end

        attr_reader :width, :height

        def draw
            (width / FLOOR_SPRITE.width).times do |x|
                (height / FLOOR_SPRITE.height).times do |y|
                    FLOOR_SPRITE.draw(position.x + x * FLOOR_SPRITE.width, position.y + y * FLOOR_SPRITE.height)
                end
            end
        end
    end
end
