defmodule Euler do
    def problem1(head..last, acc \\ 0) do
        cond do
            head == last ->
                acc
            (rem head, 3) == 0 or (rem head, 5) == 0 ->
                problem1 head+1..last, head + acc
            true ->
                problem1 head+1..last, acc
        end 
    end

    def problem2(limit \\ 1, n_1 \\ 1, n_2 \\ 1, sum \\ 0) do
        cond do
            limit == 1 ->
                1
            n_1 >= limit ->
                sum
            0 == rem n_1 + n_2, 2 ->
                problem2 limit, n_1 + n_2, n_1, sum + n_1 + n_2
            true ->
                problem2 limit, n_1 + n_2, n_1, sum
        end
    end

    def problem3(number, factor \\ 1, next \\ 3) do
        # I actually couldn't solve this one, and I needed to google an explanation
        # however, what I clicked on was a solution, so credit goes to
        # http://code.jasonbhill.com/c/project-euler-problem-3/
        # Though I did the translation to Elixir
        cond do
            1 == number ->
                factor
            0 == rem number, 2 ->
                problem3 div(number, 2), 2, 3
            0 == rem number, next ->
                problem3 div(number, next), next, next + 2
            0 != rem number, next ->
                problem3 number, factor, next + 2
        end
    end

    def listify(number) do
        case {div(number, 10), rem(number, 10)} do
            {0, x} ->
                [x]
            {n, x} ->
                [x] ++ listify n
        end
    end

    def palindrome?(numbers, stack \\ []) do
        cond do
            is_integer numbers ->
                palindrome? listify numbers
            true ->
                case {numbers, stack} do
                    {[], []} ->
                        true
                    {[top|rest], []} ->
                        palindrome? rest, [top]
                    {[top|rest], [s_top|s_rest]} ->
                        # IO.inspect [rest, length rest]
                        # IO.inspect [s_rest, length s_rest]
                        # IO.puts "-----"
                        cond do
                            length(rest) > (length(s_rest) + 1) ->
                                palindrome? rest, [top] ++ stack
                            length(rest) == (length(s_rest) + 1) ->
                                palindrome? rest, stack # eliminate extra
                            length(rest) == length(s_rest) ->
                                if top == s_top, do: palindrome?(rest, s_rest), else: false
                        end
                end
        end
    end

    def problem4(min, max, a \\ nil, b \\ nil) do
        #IO.inspect {a, b}
        cond do
            a == nil ->
                problem4(min, max, min, min)
                |> Enum.max
            a <= max ->
                cond do
                    palindrome? a*b ->
                        #IO.inspect a*b
                        [a*b] ++ problem4 min, max, a + 1, b
                    true ->
                        problem4 min, max, a + 1, b
                end
            b <= max ->
                cond do
                    palindrome? a*b ->
                        #IO.inspect a*b
                        [a*b] ++ problem4 min, max, min, b + 1
                    true ->
                        problem4 min, max, min, b + 1
                end
            true ->
                []
        end
    end

    def problem5(max, last \\ nil) do
        if last == nil, do: last = max
        Enum.map(1..max, fn x -> rem(last, x) end)
        |> Enum.all?(fn x -> x == 0 end)
        |> (&(if &1, do: last, else: problem5 max, last + max)).()
    end

    def problem6(max) do
        sum_squares = Enum.map(1..max, fn x -> x * x end) |> Enum.sum
        square_sum = Enum.sum(1..max)
        square_sum = square_sum * square_sum
        square_sum - sum_squares
    end


    def is_prime?(num, i \\ nil, w \\ nil) do
        cond do
            num < 4 ->
                true
            0 == rem(num, 2) ->
                false
            0 == rem(num, 3) ->
                false
            i == nil ->
                is_prime? num, 5, 2
            i*i > num ->
                true
            0 == rem(num, i) ->
                false
            0 != rem(num, i) ->
                is_prime? num, i + w, 6 - w
        end
    end
    
    def problem7(prime_count, primes \\ [], last \\ 1) do
        cond do
            length(primes) == prime_count ->
                Enum.max(primes)
            is_prime?(last + 1) ->
                problem7 prime_count, primes ++ [last + 1], last + 1
            true ->
                problem7 prime_count, primes, last + 1
        end
    end

    def list_product(list) do
        case list do
            [] ->
                1
            [first|rest] ->
                first * list_product rest
        end
    end

    def problem8(array, adj_len, start \\ 0, max \\ 0) do
        sum = Enum.map(start..(start + adj_len - 1), fn x -> elem(array, x) end) |> IO.inspect |> list_product
        cond do
            (adj_len + start) == tuple_size(array) ->
                Enum.max([sum, max])
            sum > max ->
                problem8 array, adj_len, start + 1, sum
            sum <= max ->
                problem8 array, adj_len, start + 1, max
        end
    end

    def problem9(sum, a \\ nil, b \\ nil, c \\ nil) do
        cond do
            a == nil ->
                problem9 sum, 1, 1, sum - 2
            a * a + b * b == c * c ->
                a * b * c
            b == 1 ->
                problem9 sum, 1, a + 1, c - 1
            true ->
                problem9 sum, a + 1, b - 1, c

        end
    end

    def problem10(max, primes \\ [], next \\ 2) do
        cond do
            next == max ->
                Enum.sum(primes)
            is_prime?(next) ->
                problem10 max, primes ++ [next], next + 1
            true ->
                problem10 max, primes, next + 1
        end
    end
end

#IO.inspect Euler.problem3(13195)
#IO.inspect Euler.problem3(600851475143)
#IO.inspect Euler.problem4(100, 999)
#IO.inspect Euler.problem4(10, 99)
#IO.inspect Euler.problem5(20)
#IO.inspect Euler.problem6(100)
#IO.inspect Euler.problem7(6)
#IO.inspect Euler.problem7(10001)
#problem8_input = {7,3,1,6,7,1,7,6,5,3,1,3,3,0,6,2,4,9,1,9,2,2,5,1,1,9,6,7,4,4,2,6,5,7,4,7,4,2,3,5,5,3,4,9,1,9,4,9,3,4,9,6,9,8,3,5,2,0,3,1,2,7,7,4,5,0,6,3,2,6,2,3,9,5,7,8,3,1,8,0,1,6,9,8,4,8,0,1,8,6,9,4,7,8,8,5,1,8,4,3,8,5,8,6,1,5,6,0,7,8,9,1,1,2,9,4,9,4,9,5,4,5,9,5,0,1,7,3,7,9,5,8,3,3,1,9,5,2,8,5,3,2,0,8,8,0,5,5,1,1,1,2,5,4,0,6,9,8,7,4,7,1,5,8,5,2,3,8,6,3,0,5,0,7,1,5,6,9,3,2,9,0,9,6,3,2,9,5,2,2,7,4,4,3,0,4,3,5,5,7,6,6,8,9,6,6,4,8,9,5,0,4,4,5,2,4,4,5,2,3,1,6,1,7,3,1,8,5,6,4,0,3,0,9,8,7,1,1,1,2,1,7,2,2,3,8,3,1,1,3,6,2,2,2,9,8,9,3,4,2,3,3,8,0,3,0,8,1,3,5,3,3,6,2,7,6,6,1,4,2,8,2,8,0,6,4,4,4,4,8,6,6,4,5,2,3,8,7,4,9,3,0,3,5,8,9,0,7,2,9,6,2,9,0,4,9,1,5,6,0,4,4,0,7,7,2,3,9,0,7,1,3,8,1,0,5,1,5,8,5,9,3,0,7,9,6,0,8,6,6,7,0,1,7,2,4,2,7,1,2,1,8,8,3,9,9,8,7,9,7,9,0,8,7,9,2,2,7,4,9,2,1,9,0,1,6,9,9,7,2,0,8,8,8,0,9,3,7,7,6,6,5,7,2,7,3,3,3,0,0,1,0,5,3,3,6,7,8,8,1,2,2,0,2,3,5,4,2,1,8,0,9,7,5,1,2,5,4,5,4,0,5,9,4,7,5,2,2,4,3,5,2,5,8,4,9,0,7,7,1,1,6,7,0,5,5,6,0,1,3,6,0,4,8,3,9,5,8,6,4,4,6,7,0,6,3,2,4,4,1,5,7,2,2,1,5,5,3,9,7,5,3,6,9,7,8,1,7,9,7,7,8,4,6,1,7,4,0,6,4,9,5,5,1,4,9,2,9,0,8,6,2,5,6,9,3,2,1,9,7,8,4,6,8,6,2,2,4,8,2,8,3,9,7,2,2,4,1,3,7,5,6,5,7,0,5,6,0,5,7,4,9,0,2,6,1,4,0,7,9,7,2,9,6,8,6,5,2,4,1,4,5,3,5,1,0,0,4,7,4,8,2,1,6,6,3,7,0,4,8,4,4,0,3,1,9,9,8,9,0,0,0,8,8,9,5,2,4,3,4,5,0,6,5,8,5,4,1,2,2,7,5,8,8,6,6,6,8,8,1,1,6,4,2,7,1,7,1,4,7,9,9,2,4,4,4,2,9,2,8,2,3,0,8,6,3,4,6,5,6,7,4,8,1,3,9,1,9,1,2,3,1,6,2,8,2,4,5,8,6,1,7,8,6,6,4,5,8,3,5,9,1,2,4,5,6,6,5,2,9,4,7,6,5,4,5,6,8,2,8,4,8,9,1,2,8,8,3,1,4,2,6,0,7,6,9,0,0,4,2,2,4,2,1,9,0,2,2,6,7,1,0,5,5,6,2,6,3,2,1,1,1,1,1,0,9,3,7,0,5,4,4,2,1,7,5,0,6,9,4,1,6,5,8,9,6,0,4,0,8,0,7,1,9,8,4,0,3,8,5,0,9,6,2,4,5,5,4,4,4,3,6,2,9,8,1,2,3,0,9,8,7,8,7,9,9,2,7,2,4,4,2,8,4,9,0,9,1,8,8,8,4,5,8,0,1,5,6,1,6,6,0,9,7,9,1,9,1,3,3,8,7,5,4,9,9,2,0,0,5,2,4,0,6,3,6,8,9,9,1,2,5,6,0,7,1,7,6,0,6,0,5,8,8,6,1,1,6,4,6,7,1,0,9,4,0,5,0,7,7,5,4,1,0,0,2,2,5,6,9,8,3,1,5,5,2,0,0,0,5,5,9,3,5,7,2,9,7,2,5,7,1,6,3,6,2,6,9,5,6,1,8,8,2,6,7,0,4,2,8,2,5,2,4,8,3,6,0,0,8,2,3,2,5,7,5,3,0,4,2,0,7,5,2,9,6,3,4,5,0}
#IO.inspect Euler.problem8(problem8_input, 13)
#IO.inspect Euler.problem9(1000)
IO.inspect Euler.problem10(2000000)
