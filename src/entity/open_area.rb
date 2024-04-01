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

        alias full_bounding_box bounding_box
        def bounding_box
            original = super
            OZ::Box.new(
                original.origin + OZ::Point[Player::WIDTH / 2, Player::HEIGHT / 2],
                original.width - Player::WIDTH,
                original.height - Player::HEIGHT,
            )
        end
    end
end
