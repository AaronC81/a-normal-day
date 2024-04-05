module GosuGameJam6
    module Sounds
        SMG = Gosu::Sample.new(File.join(RES_DIR, 'sounds', 'smg.wav'))

        ELEVATOR_BELL = Gosu::Sample.new(File.join(RES_DIR, 'sounds', 'bell.wav'))

        ENEMY_HIT = Gosu::Sample.new(File.join(RES_DIR, 'sounds', 'enemy_hit.wav'))
        PLAYER_HIT = Gosu::Sample.new(File.join(RES_DIR, 'sounds', 'player_hit.wav'))

        LASER_QUICK = Gosu::Sample.new(File.join(RES_DIR, 'sounds', 'laser_quick.wav'))
        LASER_SLOW = Gosu::Sample.new(File.join(RES_DIR, 'sounds', 'laser_slow.wav'))
    end

    module Music
        ELEVATOR = Gosu::Song.new(File.join(RES_DIR, 'sounds', 'music_elevator.wav'))
        ELEVATOR.volume = 0.4

        GAME = Gosu::Song.new(File.join(RES_DIR, 'sounds', 'music_game.wav'))
        GAME.volume = 0.05
    end
end
