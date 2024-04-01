module GosuGameJam6
    class OpenArea < OZ::Entity
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
    end
end
