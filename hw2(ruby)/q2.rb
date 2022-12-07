def longest_ap_length(array)

    dp = Array.new(array.size) {{}} #for storing the longest ap array found till now
    ans = -Float::INFINITY # initializing the length of lonest ap array found
    ans_diff=0 # initializing the difference in ap so found
    nas_lastterm =0 # storing last term to find ap at the end

    for i in 1..array.length-1 do
        for j in 0..i-1 do
        diff = array[i] - array[j]
        if dp[j].has_key?(diff)
          dp[i][diff] = dp[j][diff] + 1
        else
          dp[i][diff] = 2
        end

        # if the ap found so now is lingest then update values
        if(dp[i][diff] > ans)
            ans = dp[i][diff]
            ans_diff = diff
            ans_lastterm = array[i]
        end

      end
    end

    result=[]
    for i in 1..ans do
        result.push(ans_lastterm)
        ans_lastterm=ans_lastterm-diff
    end
    # puts "#{result.reverse} is the longest Arithmetic progression of length #{ans} in the list"
    result.reverse
end

# example input :
# array = [1,2,3,4,4,5,6,6,7,8,322,9,10,5,6,7,8,9]
# puts "#{longest_ap_length(array)} is the longest Arithmetic progression"
