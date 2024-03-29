require 'gosu'

require 'orange_zest'
OZ = OrangeZest

require_relative 'entity/player'

module GosuGameJam6
    WIDTH = 1600
    HEIGHT = 900

    class Game < OZ::Window
        def initialize
            super WIDTH, HEIGHT
            Gosu.enable_undocumented_retrofication

            # Add a component to clear the screen
            OZ::Component
                .anon(draw: ->{ Gosu.draw_rect(0, 0, WIDTH, HEIGHT, Gosu::Color::WHITE) })
                .register

            $player = GosuGameJam6::Player.new(position: OZ::Point.new(200, 200)).register
        end

        def update
            super
            OZ::Input.clear_click
        end
    end
end

GosuGameJam6::Game.new.show
