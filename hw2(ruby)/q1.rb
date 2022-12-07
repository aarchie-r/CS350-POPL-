#function to return the reversed string
def revstr (your_string)
    new_str = ""
    (1..your_string.length).each do |i|
        new_str += your_string[-i]
    end
    return new_str
end

# rucksack = gets.chomp() # taking a string as an input
# puts revstr(rucksack) # printing the reverse string

#can take any string as input for defined function
# example input: revstr(str)
# str = "hello"