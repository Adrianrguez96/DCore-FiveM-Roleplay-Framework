Helper = function()
    
    local this = {}

    local colours = {
        ['reset'] = '\x1b[39m',
        ['green'] = '\x1b[32m',
        ['lightgreen'] = '\x1b[92m',
        ['red'] = '\x1B[31m',
        ['blue'] = '\x1b[34m',
        ['lightblue'] = '\x1b[94m',
        ['white'] = '\x1b[37m',
        ['cyan'] = '\x1b[96m',

    }

    this.PrintWithTitle = function (title,content,colour)
        print (colours[colour] .. "[" .. title .. "]: ".. colours['reset'] .. content )
    end

    this.PrintColor = function(content,color)
        print(colours[color] .. content .. colours['reset'])
    end

    return this
end