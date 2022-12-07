class Array 
    #definig function fold for the Array class
    def foldl(id,&block)
        self.each {|m| id = yield(id,m) }
        return id
    end
end


# example input :
# array = [1,2,3,4,5]
# puts "#{array.foldl (10) {|m,n| m-n}}"