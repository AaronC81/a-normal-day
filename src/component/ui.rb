module GosuGameJam6
    class UI < OZ::Component
        HEART_FULL = Gosu::Image.new(File.join(RES_DIR, 'ui', 'heart_full.png'))
        HEART_HALF = Gosu::Image.new(File.join(RES_DIR, 'ui', 'heart_half.png'))
        HEART_EMPTY = Gosu::Image.new(File.join(RES_DIR, 'ui', 'heart_empty.png'))

        def draw
            full_hearts = Game.player.health / 2
            half_heart = (Game.player.health % 2 == 1)
            empty_hearts = (Game.player.max_health / 2) - full_hearts
            empty_hearts -= 1 if half_heart

            heart_spacing = 75

            heart_pos = OZ::Point[20, 20]
            full_hearts.times do
                HEART_FULL.draw(heart_pos.x, heart_pos.y, 1000)
                heart_pos.x += heart_spacing
            end
            if half_heart
                HEART_HALF.draw(heart_pos.x, heart_pos.y, 1000)
                heart_pos.x += heart_spacing
            end
            empty_hearts.times do
                HEART_EMPTY.draw(heart_pos.x, heart_pos.y, 1000)
                heart_pos.x += heart_spacing
            end
        end
    end
end
