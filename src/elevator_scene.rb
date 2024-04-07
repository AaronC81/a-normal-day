module GosuGameJam6
    module ElevatorScene 
        FLOOR = Gosu::Image.new(File.join(RES_DIR, "scene/floor.png"))
        WALL = Gosu::Image.new(File.join(RES_DIR, "scene/wall0.png"))
        PLAYER = Gosu::Image.new(File.join(RES_DIR, "player/idle.png"))
        ELEVATOR_DOOR = Gosu::Image.new(File.join(RES_DIR, "scene/wall_elevator.png"))

        def self.draw_elevator_scene(pt)
            w = FLOOR.width
            h = FLOOR.height

            3.times do |x|
                if x == 1
                    ELEVATOR_DOOR.draw(pt.x + x * w, pt.y, 1)
                else
                    WALL.draw(pt.x + x * w, pt.y, 1)
                end
            end

            3.times do |x|
                4.times do |y|
                    FLOOR.draw(pt.x + x * w, pt.y + y * h + WALL.height, 1)

                    if x == 1 && y == 2
                        PLAYER.draw(pt.x + x * w + 4, pt.y + y * h + WALL.height - 6, 10)
                    end
                end
            end
        end
    end
end
