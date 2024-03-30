require 'gosu'

require 'orange_zest'
OZ = OrangeZest

require_relative 'entity/player'
require_relative 'entity/bullet'
require_relative 'entity/wall'

module GosuGameJam6
    class Game < OZ::Window
        WIDTH = 1600
        HEIGHT = 900

        WALLS = OZ::Group.new

        class << self
            attr_accessor :player
        end
        
        def initialize
            super WIDTH, HEIGHT
            Gosu.enable_undocumented_retrofication

            # Add a component to clear the screen
            OZ::Component
                .anon(draw: ->{ Gosu.draw_rect(0, 0, WIDTH, HEIGHT, Gosu::Color::WHITE) })
                .register

            # Set up groups
            WALLS.register

            # Create player
            @@player = GosuGameJam6::Player.new(position: OZ::Point.new(200, 200)).register

            # Add some debug walls
            GosuGameJam6::Wall.new(position: OZ::Point[0, 0], width: 50, height: HEIGHT).register(WALLS)
            GosuGameJam6::Wall.new(position: OZ::Point[0, 0], width: WIDTH, height: 50).register(WALLS)
            GosuGameJam6::Wall.new(position: OZ::Point[WIDTH - 50, 0], width: 50, height: HEIGHT).register(WALLS)
            GosuGameJam6::Wall.new(position: OZ::Point[0, HEIGHT - 50], width: WIDTH, height: 50).register(WALLS)
        end

        def update
            super
            OZ::Input.clear_click
        end
    end
end

GosuGameJam6::Game.new.show
