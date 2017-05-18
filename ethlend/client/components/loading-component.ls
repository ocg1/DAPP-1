@loading-component =-> 
    div class:"loading #{state.get \loading-class } container" style:'padding:100px',  
        h1 style:'font-size:50px; display:block', 'Loading'
        p style:'font-size:20px; padding-top:15px;padding-bottom:15px', 'Please, wait...'