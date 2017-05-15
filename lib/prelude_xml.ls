@prelude__init=~> this[it] = prelude[it]
prelude.each prelude__init, <[ id is-type replicate List each map compact filter reject partition find head first tail last initial empty reverse unique unique-by fold foldl fold1 foldl1 foldr foldr1 unfoldr concat concat-map flatten difference intersection union count-by group-by and-list or-list any all sort sort-with sort-by sum product mean average maximum minimum maximum-by minimum-by scan scanl scan1 scanl1 scanr scanr1 slice take drop split-at take-while drop-while span break-list zip zip-with zip-all zip-all-with at elem-index elem-indices find-index find-indices Obj keys values pairs-to-obj obj-to-pairs lists-to-obj obj-to-lists empty each map filter compact reject partition find Str split join lines unlines words unwords chars unchars repeat capitalize camelize dasherize empty reverse slice take drop split-at take-while drop-while span break-str Func apply curry flip fix over memoize Num max min negate abs signum quot rem div mod recip pi tau exp sqrt ln pow sin cos tan asin acos atan atan2 truncate round ceiling floor is-it-NaN even odd gcd lcm ]>

@blaze__init=(tag)~>this[tag]=HTML[tag.toUpperCase!]
each blaze__init, <[ b input link h5 h6 strong img meta source br hr div span a p h4 h3 h2 h1 button table thead tr th tbody td small ul ol li span label select option textarea form output i sub time section html head body title script footer header article link nav figure figcaption tfoot video source type iframe ]>

@main_blaze = HTML[\MAIN]
@header_blaze = HTML[\HEADER]

@D =( cls, ...args)-> div class:cls, args

@P =( cls, ...args)-> p class:cls, args	