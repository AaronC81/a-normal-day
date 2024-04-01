require_relative 'character'

module GosuGameJam6
    class Enemy < Character
        def initialize(**kw)
            super(
                animations: {
                    "idle" => OZ::Animation.placeholder(width, height, Gosu::Color::RED)
                },
                **kw
            )
        end

        def die
            unregister
        end
    end
end
