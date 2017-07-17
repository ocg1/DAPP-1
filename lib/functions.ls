# @M = map

@SiteQ   =-> /^[\S]+\.[\S]+$/gi.test it
@IntQ    =-> /^[0-9\.]+$/gi.test it
@EthQ    =-> /^(0x)?[0-9a-zA-Z]{42}$/i.test it
@ShaQ    =-> /^(0x)?[0-9a-zA-Z]{66}$/i.test it

@EmailQ  =-> /^[\S]+\@[\S]+\.[\S]+$/gi.test it

@date-now-arr =-> 
    new Date(Date.now!)
        |> String
        |> split ' '
        |> slice 1 4

@date-tomorrow-arr =-> inc-date-arr {date:Date.now!, inc:1}

@inc-date-arr =-> 
    date = new Date(Date.parse it.date)
    new Date(date.setDate(date.getDate() + (+it.inc-1)))
        |> String
        |> split ' '
        |> slice 1 4

@format-date =-> 
    "#{it?1||''} #{it?0||''} #{drop(2 it?2||'')}"

@today    =-> format-date date-now-arr!
@tomorrow =-> format-date date-tomorrow-arr!
@inc-date =-> format-date inc-date-arr it

@get-all-of =-> 
    rules_arr = []
    rules = state.get it
    for n of rules
        rule = rules[n]
        rule.id = n
        rules_arr.push rule
    rules_arr

@get-num-of =->
    arr = []
    els = state.get it
    for n of els
        arr.push n
    arr

@delete-year =-> slice 0 6 it

@get-id =->
    id = ''
    charset = union [48 to 57], [65 to 90],[97 to 122] 
    for i in [1 to 30] 
        pos = Math.floor(62*Math.random!)
        id += String.fromCharCode charset[pos]
    return String(id)

# @validate-val-with =(o,test)-> 
#     name = o.attr(\ident)

#     # ident = $(event.target).attr(\ident)
#     # $(event.target) `validate-val-with` IntQ
#     state.set "#{name}" o.val!     
#     if not test o.val! 
#         state.set("#{name}-rpin" true); state.set("#{name}-gpin" false)
#     else state.set("#{name}-rpin" false); state.set("#{name}-gpin" true)
#     global[name].focus!
#     return

@push-to-state =->
    current = state.get &0
    current.push &1
    state.set &0, current


@lookup-and-append = (obj,cls) ~> Meteor.setTimeout((~> 
    if typeof obj != \undefined => $(cls).html(String(obj))
    else lookup-and-append(obj,cls); #console.log obj
    ), 30)


@lookup= (obj,func) ~> Meteor.setTimeout((~> 
    if typeof obj != \undefined => func(obj);
    else 
        state.set(\inc_lookup (state.get(\inc_lookup)||1)+1)
        console.log state.get(\inc_lookup)
        if state.get(\inc_lookup) > 20 => return #location.reload()
        lookup(obj,func)
        
    ), 30)


@conscb =-> 
    if &0 => console.log \err: &0
    if &1 => console.log \res: &1

@goto-success-cb =-> 
    if &0 => console.log \err: &0
    if &1
        console.log \res: &1
        Router.go \success



@simple-cb =->
    if &0 => new Error &0
    if &1 => &1    

@state-int-to-str =(state, what)-> switch state
    | 0=> 'no data'
    | 1=> 'waiting for ' + what
    | 2=> \cancelled
    | 3=> 'waiting for lender'
    | 4=> \funded
    | 5=> \default
    | 6=> \finished
    | _=> \----

@big-zero = \0x0000000000000000000000000000000000000000

@sha-zero = \0x0000000000000000000000000000000000000000000000000000000000000000


@get-it-tail =-> 
    it|> join '' |> chars |> tail
@get-it-head =-> 
    it|> join '' |> chars |> first

@get-num =-> 
    ( [get-it-head(it)] ++ ['.'] ++ get-it-tail(it) )|> join ''


# @convert-big-number =->
#     +get-num(it.c)*10^(it.e*it.s)

@eth-to-wei =(str)->
    bn = new BigNumber(str)
    bn.times(1000_000_000_000_000_000).to-fixed!

@bigNum-add =(arr1,arr2)->
    a1 = new BigNumber(0)
    a2 = new BigNumber(0)
    a1.c = arr1?c
    a1.e = arr1?e
    a1.s = arr1?s    

    a2.c = arr2?c
    a2.e = arr2?e
    a2.s = arr2?s    

    bigNum-toStr a1.add a2

@bigNum-add-Wei =(arr1,arr2)->
    a1 = new BigNumber(0)
    a2 = new BigNumber(0)
    a1.c = arr1?c
    a1.e = arr1?e
    a1.s = arr1?s    

    a2.c = arr2?c
    a2.e = arr2?e
    a2.s = arr2?s    

    a1.add a2 .to-fixed!



@bigNum-toStr =(arr)-> 
    bn = new BigNumber(0)
    bn.c = arr?c
    bn.e = arr?e
    bn.s = arr?s
    many = 1000_000_000_000_000_000
    bn.divided-by(many).to-fixed!
    # console.log \bn: bn

@bigNum-toStr-div10 =(arr)->
    bn = new BigNumber(0)
    bn.c = arr?c
    bn.e = arr?e
    bn.s = arr?s
    many = \10000000000000000000
    bn.divided-by(many).to-fixed!


@lilNum-toStr =(arr)-> 
    bn = new BigNumber(0)
    bn.c = arr?c
    bn.e = arr?e
    bn.s = arr?s
    bn.to-fixed!

@state-null =-> state.set it, null


@shortest =(str1, str2)->
    if str1.length > str2.length => str2
    else str1


@yesno =-> if it then \Yes else \No

@get-faq-img-link=-> switch it
    case 1  => a href:\http://ibb.co/mDACyF, img class:\faq-img src:\http://preview.ibb.co/ePDAkv/image1.jpg  alt:\image1  border:\0
    case 2  => a href:\http://ibb.co/eRmkJF, img class:\faq-img src:\http://preview.ibb.co/dtACyF/image2.jpg  alt:\image2  border:\0
    case 3  => a href:\http://ibb.co/c0wkJF, img class:\faq-img src:\http://preview.ibb.co/krbVkv/image3.jpg  alt:\image3  border:\0
    case 4  => a href:\http://ibb.co/h2dbQv, img class:\faq-img src:\http://preview.ibb.co/iB4GQv/image4.jpg  alt:\image4  border:\0
    case 5  => a href:\http://ibb.co/iwUGQv, img class:\faq-img src:\http://preview.ibb.co/noyAkv/image5.jpg  alt:\image5  border:\0
    case 6  => a href:\http://ibb.co/npjSXa, img class:\faq-img src:\http://preview.ibb.co/iLPSXa/image6.jpg  alt:\image6  border:\0
    case 7  => a href:\http://ibb.co/cJWVkv, img class:\faq-img src:\http://preview.ibb.co/k1UGQv/image7.jpg  alt:\image7  border:\0
    case 8  => a href:\http://ibb.co/fHmwQv, img class:\faq-img src:\http://preview.ibb.co/hpMVkv/image8.jpg  alt:\image8  border:\0
    case 9  => a href:\http://ibb.co/nNvCyF, img class:\faq-img src:\http://preview.ibb.co/iOiMsa/image9.jpg  alt:\image9  border:\0
    case 10 => a href:\http://ibb.co/emUGQv, img class:\faq-img src:\http://preview.ibb.co/fK5qkv/image10.jpg alt:\image10 border:\0
    case 11 => a href:\http://ibb.co/kaFCyF, img class:\faq-img src:\http://preview.ibb.co/nu8XyF/image11.jpg alt:\image11 border:\0
    case 12 => a href:\http://ibb.co/gjYbQv, img class:\faq-img src:\http://preview.ibb.co/c1ngsa/image12.jpg alt:\image12 border:\0
    case 13 => a href:\http://ibb.co/no3nXa, img class:\faq-img src:\http://preview.ibb.co/bsBwQv/image13.jpg alt:\image13 border:\0
    case 14 => a href:\http://ibb.co/dpTzdF, img class:\faq-img src:\http://preview.ibb.co/k9HsyF/image14.jpg alt:\image14 border:\0
    case 15 => a href:\http://ibb.co/fuhgsa, img class:\faq-img src:\http://preview.ibb.co/gZ0CyF/image15.jpg alt:\image15 border:\0
    case 16 => a href:\http://ibb.co/mqAZCa, img class:\faq-img src:\http://preview.ibb.co/nOm7Xa/image16.jpg alt:\image16 border:\0
    case 17 => a href:\http://ibb.co/dGh35v, img class:\faq-img src:\http://preview.ibb.co/gq1KdF/image17.jpg alt:\image17 border:\0
    case 18 => a href:\http://ibb.co/j4TzdF, img class:\faq-img src:\http://preview.ibb.co/eo6Vkv/image18.jpg alt:\image18 border:\0
    case 19 => a href:\http://ibb.co/ct8Msa, img class:\faq-img src:\http://preview.ibb.co/jTOAkv/image19.jpg alt:\image19 border:\0
    case 20 => a href:\http://ibb.co/kP17Xa, img class:\faq-img src:\http://preview.ibb.co/n4LedF/image20.jpg alt:\image20 border:\0
    case 21 => a href:\http://ibb.co/cvXsyF, img class:\faq-img src:\http://preview.ibb.co/kdVedF/image21.jpg alt:\image21 border:\0
    case 22 => a href:\http://ibb.co/iVpGQv, img class:\faq-img src:\http://preview.ibb.co/d6kqkv/image22.jpg alt:\image22 border:\0
    case 23 => a href:\http://ibb.co/kRL1sa, img class:\faq-img src:\http://preview.ibb.co/nzvZCa/image23.jpg alt:\image23 border:\0
    case 24 => a href:\http://ibb.co/hiLO5v, img class:\faq-img src:\http://preview.ibb.co/bKGwQv/image24.jpg alt:\image24 border:\0
    case 25 => a href:\http://ibb.co/joLO5v, img class:\faq-img src:\http://preview.ibb.co/bMoXyF/image25.jpg alt:\image25 border:\0
    case 26 => a href:\http://ibb.co/i3puCa, img class:\faq-img src:\http://preview.ibb.co/jLyXyF/image26.jpg alt:\image26 border:\0
    case 27 => a href:\http://ibb.co/mYm7Xa, img class:\faq-img src:\http://preview.ibb.co/gP8bQv/image27.jpg alt:\image27 border:\0
    case 28 => a href:\http://ibb.co/gJxECa, img class:\faq-img src:\http://preview.ibb.co/b2bkJF/image28.jpg alt:\image28 border:\0
    case 29 => a href:\http://ibb.co/hqaO5v, img class:\faq-img src:\http://preview.ibb.co/fH0qkv/image29.jpg alt:\image29 border:\0
    case 30 => a href:\http://ibb.co/jup5JF, img class:\faq-img src:\http://preview.ibb.co/dVkedF/image30.jpg alt:\image30 border:\0
    case 31 => a href:\http://ibb.co/my3nXa, img class:\faq-img src:\http://preview.ibb.co/jQSECa/image31.jpg alt:\image31 border:\0

@address-last =->
    Router.current!originalUrl |> split \/ |> last
