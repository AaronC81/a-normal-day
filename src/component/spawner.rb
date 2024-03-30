module GosuGameJam6
    class Spawner < OZ::Component
        SPAWN_PADDING = 100
        SPAWN_SPACING = 40

        def initialize
            @tick_timer = 0
            @spawn_timer = 3 * 60
        end

        def update
            super
            @tick_timer += 1

            @spawn_timer -= 1

            # If they already killed all the enemies, expedite things a bit
            if Game::ENEMIES.items.empty?
                @spawn_timer -= 5
            end

            if @spawn_timer <= 0
                # Choose a location to spawn
                base_x = rand(SPAWN_PADDING..(Game::WIDTH - SPAWN_PADDING))
                base_y = rand(SPAWN_PADDING..(Game::HEIGHT - SPAWN_PADDING))

                # TODO: absolutely terrible
                dimension = difficulty + 1
                base_x -= 1 while base_x + (dimension - 1) * SPAWN_SPACING > (Game::WIDTH - SPAWN_PADDING)
                base_y -= 1 while base_y + (dimension - 1) * SPAWN_SPACING > (Game::HEIGHT - SPAWN_PADDING)

                dimension.times do |x|
                    dimension.times do |y| 
                        GosuGameJam6::Enemy.new(position: OZ::Point[base_x + x * SPAWN_SPACING, base_y + y * SPAWN_SPACING]).register(Game::ENEMIES)
                    end
                end

                @spawn_timer = [(15 - difficulty) * 60, 120].max
            end
        end

        def difficulty
            thirty_seconds_in_ticks = 60 * 30
            @tick_timer / thirty_seconds_in_ticks + 1
        end
    end
end
