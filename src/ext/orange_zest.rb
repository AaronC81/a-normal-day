module OrangeZest
    class Box
        def encloses?(other)
            self.origin.x <= other.origin.x \
            && self.origin.y <= other.origin.y \
            && self.origin.x + self.width >= other.origin.x + other.width \
            && self.origin.y + self.height >= other.origin.y + other.height
        end
    end
end
