-- measure the performance of table inserts in append vs prepend mode:

local S, S_ = Stopwatch( )

local y = { }
S( "table prepend" )
for x = 0, 5000 do
        table.insert( y, 1, x )
end
S_( )

y = { }
S( "table append" )
for x = 0, 5000 do
        table.insert( y, x )
end
S_( )
