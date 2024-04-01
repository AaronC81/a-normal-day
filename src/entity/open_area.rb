module GosuGameJam6
    class OpenArea < OZ::Entity
        def initialize(width:, height:, **kw)
            super(
                animations: {
                    "idle" => OZ::Animation.placeholder(width, height, Gosu::Color::FUCHSIA)
                },
                **kw
            )
        end
    end
end
