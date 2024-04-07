require_relative 'elevator_scene'

module GosuGameJam6
    class MainMenu        
        PLAY_BUTTON = OZ::Box.new(
            OZ::Point[650, 700],
            550,
            70
        )

        FULLSCREEN_BUTTON = OZ::Box.new(
            OZ::Point[1330, 810],
            250,
            70,
        )

        LOGO = Gosu::Image.new(File.join(RES_DIR, 'logo.png'))

        def draw
            ElevatorScene.draw_elevator_scene(OZ::Point[200, 400]) 

            LOGO.draw(730, 50)

            # Instructions
            Fonts::STANDARD.draw_text("WASD: Move", 850, 550, 2, 1, 1)
            Fonts::STANDARD.draw_text("Left click: Shoot", 840, 600, 2, 1, 1)

            # Play button
            Gosu.draw_rect(PLAY_BUTTON.origin.x, PLAY_BUTTON.origin.y, PLAY_BUTTON.width, PLAY_BUTTON.height, Gosu::Color::BLACK)
            text_colour = PLAY_BUTTON.point_inside?(OZ::Input.cursor) ? Gosu::Color::YELLOW : Gosu::Color::WHITE
            Fonts::STANDARD.draw_text("Start!", PLAY_BUTTON.origin.x + 20, PLAY_BUTTON.origin.y + 20, 2, 1, 1, text_colour)

            # Fullscreen button
            Gosu.draw_rect(FULLSCREEN_BUTTON.origin.x, FULLSCREEN_BUTTON.origin.y, FULLSCREEN_BUTTON.width, FULLSCREEN_BUTTON.height, Gosu::Color::BLACK)
            text_colour = FULLSCREEN_BUTTON.point_inside?(OZ::Input.cursor) ? Gosu::Color::YELLOW : Gosu::Color::WHITE
            Fonts::STANDARD.draw_text("Toggle fullscreen", FULLSCREEN_BUTTON.origin.x + 20, FULLSCREEN_BUTTON.origin.y + 20, 2, 1, 1, text_colour)

            Fonts::STANDARD.draw_text("Created by Aaron Christiansen\nfor Gosu Game Jam 6", 20, 730, 2, 1, 1)
            Fonts::SMALL.draw_text("Audio from Freesound\n  Music: Sirkoto51, BlondPanda\n  SFX: SuperPhat, azumarill, BenjaminNelan, Raclure,\n          djfroyd, Metzik, bubaproducer, mparsons99\nFont: 'Info Story' by Khurasan", 20, 790, 2, 1, 1)
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
