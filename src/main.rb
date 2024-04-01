require 'gosu'

require 'orange_zest'
OZ = OrangeZest
require_relative 'ext/orange_zest'

require_relative 'entity/player'
require_relative 'entity/bullet'
require_relative 'entity/wall'
require_relative 'entity/enemy'
require_relative 'entity/enemy/machine_gun_turret'
require_relative 'entity/enemy/walker'
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

            wg = WorldGen.new
            wg.corridor_areas(wg.generate_corridor_description(2000)).each do |area|
                area.register(OPEN_AREAS)
            end

            # Create enemy spawner
            # GosuGameJam6::Spawner.new.register
            Walker.new(position: OZ::Point[300, 300]).register(ENEMIES)

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

        def self.line_of_sight?(a, b=Game.player.position)
            # Take an arbitrary sample of points along the line between the two points, and check
            # they all fall into an `OpenArea`
            # For "dramatic effect", and also because it's harder to program, walls don't block
            # line-of-sight
            sample_points = 8

            x_step = (b.x.to_f - a.x.to_f) / sample_points
            y_step = (b.y.to_f - a.y.to_f) / sample_points

            sample_points.times do |i|
                this_point = a + OZ::Point[i * x_step, i * y_step]
                if !Game::OPEN_AREAS.items.any? { |area| area.bounding_box.point_inside?(this_point) }
                    return false
                end
            end

            true
        end
    end
end

GosuGameJam6::Game.new.show
