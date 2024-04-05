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

        FULLSCREEN_BUTTON = OZ::Box.new(
            OZ::Point[1350, 810],
            230,
            70,
        )

        def draw
            ElevatorScene.draw_elevator_scene(OZ::Point[200, 400]) 

            # Instructions
            @standard_font.draw_text("WASD: Move", 850, 500, 2, 1, 1)
            @standard_font.draw_text("Left click: Shoot", 840, 550, 2, 1, 1)

            # Play button
            Gosu.draw_rect(PLAY_BUTTON.origin.x, PLAY_BUTTON.origin.y, PLAY_BUTTON.width, PLAY_BUTTON.height, Gosu::Color::BLACK)
            text_colour = PLAY_BUTTON.point_inside?(OZ::Input.cursor) ? Gosu::Color::YELLOW : Gosu::Color::WHITE
            @standard_font.draw_text("Start!", PLAY_BUTTON.origin.x + 20, PLAY_BUTTON.origin.y + 20, 2, 1, 1, text_colour)

            # Fullscreen button
            Gosu.draw_rect(FULLSCREEN_BUTTON.origin.x, FULLSCREEN_BUTTON.origin.y, FULLSCREEN_BUTTON.width, FULLSCREEN_BUTTON.height, Gosu::Color::BLACK)
            text_colour = FULLSCREEN_BUTTON.point_inside?(OZ::Input.cursor) ? Gosu::Color::YELLOW : Gosu::Color::WHITE
            @standard_font.draw_text("Toggle fullscreen", FULLSCREEN_BUTTON.origin.x + 20, FULLSCREEN_BUTTON.origin.y + 20, 2, 1, 1, text_colour)
        end

        # Returns boolean indicating whether game should start
        def update
            if OZ::Input.click?
                if PLAY_BUTTON.point_inside?(OZ::Input.cursor)
                    return :play
                end

                if FULLSCREEN_BUTTON.point_inside?(OZ::Input.cursor)
                    return :fullscreen
                end
            end

            nil
        end
    end
end
