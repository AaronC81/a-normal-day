require 'gosu'

require 'orange_zest'
OZ = OrangeZest
require_relative 'ext/orange_zest'

RES_DIR = File.join(__dir__, "..", "res")

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

            # Add a component to clear the screen
            OZ::Component
                .anon(draw: ->{ Gosu.draw_rect(0, 0, WIDTH, HEIGHT, Gosu::Color.rgba(50, 50, 50, 255), -10) })
                .register(STATIC_EARLY)

            # Set up groups
            OPEN_AREAS.register
            WALLS.register
            ENEMIES.register

            # Create player
            @@player = GosuGameJam6::Player.new(
                weapon_sprite: Gosu::Image.new(File.join(RES_DIR, "weapon/ar.png")),
                weapon_cooldown: 8,
                weapon_is_automatic: true,
                weapon_spread: 4,
            )
            @@player.register

            # Difficulty control
            @world_gen_length = 2000
            @world_gen_density = 1
            
            regenerate_world(@world_gen_length, @world_gen_density, [MachineGunTurret, Walker, Walker])

            # Draw UI
            # (This is last, so it gets drawn on top of other stuff)
            UI.new.register(STATIC_LATE)
        end

        def regenerate_world(length, density, pool)
            # Tear down
            OPEN_AREAS.items.each(&:unregister)
            ENEMIES.items.each(&:unregister)

            wg = WorldGen.new
            areas = wg.corridor_areas(wg.generate_corridor_description(length))
            areas.each do |area|
                area.register(OPEN_AREAS)
            end
            enemies = wg.populate_areas(areas, density, pool)
            enemies.each do |enemy|
                enemy.register(ENEMIES)
            end

            # TODO: better spawn location
            @@player.position = areas.first.bounding_box.centre
        end

        def update
            super
            STATIC_EARLY.update
            STATIC_LATE.update
            OZ::Input.clear_click

            # TODO: crude
            if ENEMIES.items.empty?
                @world_gen_length += 500
                @world_gen_density += 1
                regenerate_world(@world_gen_length, @world_gen_density, [MachineGunTurret, Walker, Walker])
            end
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
