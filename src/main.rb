require 'gosu'

require 'orange_zest'
OZ = OrangeZest

module GosuGameJam6
    WIDTH = 1600
    HEIGHT = 900

    class Game < OZ::Window
        def initialize
            super WIDTH, HEIGHT
            @@window = self

            Gosu.enable_undocumented_retrofication

            # Add a component to clear the screen
            OZ::Component
                .anon(draw: ->{ Gosu.draw_rect(0, 0, WIDTH, HEIGHT, Gosu::Color::WHITE) })
                .register
        end

        def update
            super
            OZ::Input.clear_click
        end    
    end
end

GosuGameJam6::Game.new.show
