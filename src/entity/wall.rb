module GosuGameJam6
    class Wall < OZ::Entity
        def initialize(width:, height:, **kw)
            super(
                animations: {
                    "idle" => OZ::Animation.placeholder(width, height, Gosu::Color::YELLOW)
                },
                **kw
            )
        end
    end
end
