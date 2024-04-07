module GosuGameJam6
    module Fonts
        TTF = File.join(RES_DIR, 'fonts', 'infostory.ttf')

        HEADER = Gosu::Font.new(50, name: TTF)
        STANDARD = Gosu::Font.new(30, name: TTF)
        SMALL = Gosu::Font.new(20, name: TTF)
    end
end
