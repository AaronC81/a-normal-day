require_relative 'elevator_scene'

module GosuGameJam6
    class MainMenu        
        def initialize
            @header_font = Gosu::Font.new(50, name: 'Arial') # TODO
            @standard_font = Gosu::Font.new(28, name: 'Arial') # TODO
        end

        PLAY_BUTTON = OZ::Box.new(
            OZ::Point[650, 700],
            550,
            70
        )

        def draw
            ElevatorScene.draw_elevator_scene(OZ::Point[200, 400]) 

            Gosu.draw_rect(PLAY_BUTTON.origin.x, PLAY_BUTTON.origin.y, PLAY_BUTTON.width, PLAY_BUTTON.height, Gosu::Color::BLACK)

            text_colour = PLAY_BUTTON.point_inside?(OZ::Input.cursor) ? Gosu::Color::YELLOW : Gosu::Color::WHITE
            @standard_font.draw_text("Start!", PLAY_BUTTON.origin.x + 20, PLAY_BUTTON.origin.y + 20, 2, 1, 1, text_colour)
        end

        # Returns boolean indicating whether game should start
        def update
            if OZ::Input.click? && PLAY_BUTTON.point_inside?(OZ::Input.cursor)
                return true
            end

            false
        end
    end
end
