class String
   def perm
       return [self] if self.length < 2
       ret = []
    
       0.upto(self.length - 1) do |n|
          #rest = self.split('')                
          rest = self.split(//u)            # for UTF-8 encoded strings
          picked = rest.delete_at(n) 
          ## Added to remove duplicate patterns == unless ret.include?(picked + x)
          rest.join.perm.each { |x| ret << (picked + x) unless ret.include?(picked + x)}
       end

       ret
   end
end

#p "abc".perm      #=>  ["abc", "acb", "bac", "bca", "cab", "cba"]


