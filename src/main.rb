require 'gosu'

require 'orange_zest'
OZ = OrangeZest
require_relative 'ext/orange_zest'

require_relative 'entity/player'
require_relative 'entity/bullet'
require_relative 'entity/wall'
require_relative 'entity/enemy'
require_relative 'entity/open_area'

require_relative 'component/spawner'
require_relative 'component/ui'

require_relative 'world_gen'

module GosuGameJam6
    class Game < OZ::Window
        WIDTH = 1600
        HEIGHT = 900

        WALLS = OZ::Group.new
        OPEN_AREAS = OZ::Group.new
        ENEMIES = OZ::Group.new

        # Not registered into `Main` - used to draw stuff which shouldn't scroll
        STATIC_EARLY = OZ::Group.new
        STATIC_LATE = OZ::Group.new

        def self.player
            @@player
        end
        
        def initialize
            super WIDTH, HEIGHT
            Gosu.enable_undocumented_retrofication

            # Add a component to clear the screen
            OZ::Component
                .anon(draw: ->{ Gosu.draw_rect(0, 0, WIDTH, HEIGHT, Gosu::Color::WHITE) })
                .register(STATIC_EARLY)

            # Set up groups
            OPEN_AREAS.register
            WALLS.register
            ENEMIES.register

            # Create player
            @@player = GosuGameJam6::Player.new(position: OZ::Point.new(200, 200))
            @@player.register

            # Add debug area
            # GosuGameJam6::OpenArea.new(position: OZ::Point[0, 0], width: WIDTH, height: HEIGHT).register(OPEN_AREAS)

            # Add some debug walls
            # GosuGameJam6::Wall.new(position: OZ::Point[0, 0], width: 50, height: HEIGHT).register(WALLS)
            # GosuGameJam6::Wall.new(position: OZ::Point[0, 0], width: WIDTH, height: 50).register(WALLS)
            # GosuGameJam6::Wall.new(position: OZ::Point[WIDTH - 50, 0], width: 50, height: HEIGHT).register(WALLS)
            # GosuGameJam6::Wall.new(position: OZ::Point[0, HEIGHT - 50], width: WIDTH, height: 50).register(WALLS)

            wg = WorldGen.new
            wg.corridor_areas(wg.generate_corridor_description(2000)).each do |area|
                area.register(OPEN_AREAS)
            end

            # Create enemy spawner
            # GosuGameJam6::Spawner.new.register

            # Draw UI
            # (This is last, so it gets drawn on top of other stuff)
            UI.new.register(STATIC_LATE)
        end

        def update
            super
            STATIC_EARLY.update
            STATIC_LATE.update
            OZ::Input.clear_click
        end

        def self.offset
            OZ::Point[
                WIDTH / 2 - player.centre_position.x,
                HEIGHT / 2 - player.centre_position.y,
            ]
        end
    
        def draw
            STATIC_EARLY.draw
            Gosu.translate(Game.offset.x, Game.offset.y) do
                super
            end
            STATIC_LATE.draw
        end
    end
end

GosuGameJam6::Game.new.show
