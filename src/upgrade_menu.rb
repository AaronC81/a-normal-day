require_relative 'elevator_scene'

module GosuGameJam6
    class UpgradeMenu        
        def initialize
            @header_font = Gosu::Font.new(50, name: 'Arial') # TODO
            @standard_font = Gosu::Font.new(28, name: 'Arial') # TODO
        end

        attr_accessor :choices, :on_choice_made

        def draw
            ElevatorScene.draw_elevator_scene(OZ::Point[200, 400]) 

            @header_font.draw_text("Choose one", 800, 100, 1)
            button_boxes.zip(choices).each do |box, (text, _)|
                Gosu.draw_rect(box.origin.x, box.origin.y, box.width, box.height, Gosu::Color::BLACK)

                text_colour = box.point_inside?(OZ::Input.cursor) ? Gosu::Color::YELLOW : Gosu::Color::WHITE
                @standard_font.draw_text(text, box.origin.x + 20, box.origin.y + 20, 2, 1, 1, text_colour)
            end
        end

        def update
            if OZ::Input.click?
                _, (_, action) = button_boxes.zip(choices).find { |box, _| box.point_inside?(OZ::Input.cursor) }
                return if action.nil?
                action.()
                on_choice_made.()
            end
        end

        def button_boxes
            button_origin = OZ::Point[650, 300]

            button_height = 70
            button_width = 550
            button_spacing = 50

            choices.length.times.map do |i|
                OZ::Box.new(
                    button_origin + OZ::Point[0, i * (button_height + button_spacing)],
                    button_width,
                    button_height,
                )
            end
        end
    end
end
