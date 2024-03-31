module GosuGameJam6
    class UI < OZ::Component
        def initialize
            @font = Gosu::Font.new(28, name: 'Arial') # TODO
        end

        def draw
            @font.draw_text("HP: #{Game.player.health}/#{Game.player.max_health}", 2, 2, 100, 1, 1, Gosu::Color::BLACK)
        end
    end
end
