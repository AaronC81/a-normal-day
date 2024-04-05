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
require_relative 'entity/enemy/blaster'
require_relative 'entity/enemy/chaingunner'
require_relative 'entity/open_area'

require_relative 'component/spawner'
require_relative 'component/ui'
require_relative 'component/transition'

require_relative 'world_gen'
require_relative 'elevator_scene'
require_relative 'upgrade_menu'
require_relative 'main_menu'
require_relative 'sounds'

module GosuGameJam6
    class Game < OZ::Window
        WIDTH = 1600
        HEIGHT = 900

        GAME = OZ::Group.new

        WALLS = OZ::Group.new
        OPEN_AREAS = OZ::Group.new
        ENEMIES = OZ::Group.new
        PLAYER = OZ::Group.new

        # Not registered into `Main` - used to draw stuff which shouldn't scroll
        STATIC_EARLY = OZ::Group.new
        STATIC_LATE = OZ::Group.new

        ENEMY_POOL = [Walker, Walker, Walker, Walker, MachineGunTurret, MachineGunTurret, Blaster, Chaingunner]

        def self.player
            @@player
        end
        
        def initialize
            super WIDTH, HEIGHT

            @transition = Transition.new

            # Add a component to clear the screen
            OZ::Component
                .anon(draw: ->{ Gosu.draw_rect(0, 0, WIDTH, HEIGHT, Gosu::Color.rgba(50, 50, 50, 255), -10) })
                .register(STATIC_EARLY)

            # Set up groups
            OPEN_AREAS.register(GAME)
            WALLS.register(GAME)
            ENEMIES.register(GAME)
            PLAYER.register(GAME)

            # Create menus
            @upgrade_menu = UpgradeMenu.new
            @main_menu = MainMenu.new
            @is_on_main_menu = true

            # Draw UI
            # (This is last, so it gets drawn on top of other stuff)
            UI.new.register(STATIC_LATE)

            reset
        end

        def reset
            PLAYER.items.clear

            # Create player
            @@player = GosuGameJam6::Player.new(
                weapon_sprite: Gosu::Image.new(File.join(RES_DIR, "weapon/ar.png")),
                weapon_sound: Sounds::SMG,
                weapon_cooldown: 8,
                weapon_is_automatic: true,
                weapon_spread: 5,
                weapon_damage: 20,
            )
            @@player.register(PLAYER)

            # Difficulty control
            @world_gen_length = 2000
            @world_gen_density = 1
            
            regenerate_world(@world_gen_length, @world_gen_density, ENEMY_POOL)

            Music::ELEVATOR.play(true)
        end

        def regenerate_world(length, density, pool)
            # Tear down
            OPEN_AREAS.items.clear
            ENEMIES.items.clear

            wg = WorldGen.new
            corridors = wg.generate_corridor_description(length)
            areas = wg.corridor_areas(corridors)
            areas.each do |area|
                area.register(OPEN_AREAS)
            end
            enemies = wg.populate_areas(areas, density, pool)
            enemies.each do |enemy|
                enemy.register(ENEMIES)
            end

            wg.move_player_to_spawn(corridors)

            # Don't generate anything too close to the player
            ENEMIES.items.each do |enemy|
                if Gosu.distance(enemy.position.x, enemy.position.y, @@player.position.x, @@player.position.y) < 1200
                    enemy.unregister
                end
            end
        end

        def update
            super
            STATIC_EARLY.update

            if @is_on_upgrade_menu
                @upgrade_menu.update
            elsif @is_on_main_menu
                case @main_menu.update
                when :play
                    @transition.fade_out(30) do
                        @is_on_main_menu = false
                        Music::GAME.play(true)
                        @transition.fade_in(30)
                    end
                when :fullscreen
                    self.fullscreen = !fullscreen?
                end
            else
                GAME.update
            end

            STATIC_LATE.update
            OZ::Input.clear_click
            @transition.update

            if OZ::TriggerCondition.watch(ENEMIES.items.empty?) == :on
                OZ::Scheduler.start do
                    OZ::Scheduler.wait(60)
                    @transition.fade_out(30) do
                        Music::ELEVATOR.play(true)

                        @upgrade_menu.choices = Player::UPGRADES.sample(2) + [
                            ["Instead of an upgrade, restore half health", ->{
                                Game.player.restore_health(Game.player.max_health / 2)
                            }],
                        ]
                        @is_on_upgrade_menu = true
                        @upgrade_menu.on_choice_made = ->do
                            @transition.fade_out(30) do
                                Music::ELEVATOR.stop
                                Sounds::ELEVATOR_BELL.play(0.7)
                                Music::GAME.play(true)

                                @is_on_upgrade_menu = false
                                @world_gen_length += 500
                                @world_gen_density += 1
                                regenerate_world(@world_gen_length, @world_gen_density, ENEMY_POOL)
                                @transition.fade_in(30)
                            end
                        end
                        @transition.fade_in(30)
                    end
                end
            end

            # Check if the player died
            if OZ::TriggerCondition.watch(@@player.dead?) == :on
                @transition.fade_out(30) do
                    reset
                    @is_on_main_menu = true
                    @transition.fade_in(30)
                end
            end
        end

        def self.offset
            OZ::Point[
                WIDTH / 2 - player.centre_position.x,
                HEIGHT / 2 - player.centre_position.y,
            ]
        end
    
        def draw
            super

            STATIC_EARLY.draw

            if @is_on_upgrade_menu
                @upgrade_menu.draw
                STATIC_LATE.draw
            elsif @is_on_main_menu
                @main_menu.draw
                # Do not draw STATIC_LATE, because it includes UI
            else
                Gosu.translate(Game.offset.x, Game.offset.y) do
                    GAME.draw
                end
                STATIC_LATE.draw
            end

            @transition.draw
        end

        def self.line_of_sight?(a, b=Game.player.position, max_distance: nil)
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

            if max_distance
                if Gosu.distance(a.x, a.y, b.x, b.y) > max_distance
                    return false
                end
            end

            true
        end
    end
end

GosuGameJam6::Game.new.show
