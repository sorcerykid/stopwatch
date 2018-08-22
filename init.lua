--------------------------------------------------------
-- Minetest :: Stopwatch Mod v1.0 (stopwatch)
--
-- See README.txt for licensing and release notes.
-- Copyright (c) 2016-2018, Leslie Ellen Krause
--------------------------------------------------------

function Stopwatch( scale )
	local clock = minetest.get_us_time
	local sprintf = string.format
	local getinfo = debug.getinfo
	local factors = { us = 1, ms = 1000, s = 1000000 }
	local origin = getinfo( 2 ).source
	local trials = { }
	local id

	if not scale then
		scale = "ms"
	elseif not factors[ scale ] then
		error( "Invalid scale specified, aborting." )
	end

	local function S( desc )
		local i = getinfo( 2, "lf" )
		id = desc or tostring( i.func ) .. ", line " .. i.currentline
		local v = trials[ id ]
		if not v then
			v = { count = 0, delta_t = 0 }
			trials[ id ] = v
		end
		v.start = clock( )
	end
	local function S_( is_show, desc )
		if not desc and not id then
			local i = getinfo( 2, "lf" )
			id = tostring( i.func ) .. ", line " .. i.currentline
		end
		local v = trials[ desc or id ]
		local delta = clock( ) - v.start
		if is_show then
			print( sprintf( "** trial count = %9.3f %s @%s", delta / factors[ scale ], scale, id ) )
		end
		v.delta_t = v.delta_t + delta
		v.count = v.count + 1
	end
	minetest.register_on_shutdown( function ( )
		local delta_g = 0
		print( "** " .. origin )
		for i, v in pairs( trials ) do
			print( sprintf( "** trial total = %9.3f %s %4d tries %8.3f %s each @%s",
				v.delta_t / factors[ scale ], scale, v.count, v.delta_t / v.count / factors[ scale ], scale, i ) )
			delta_g = delta_g + v.delta_t
		end
		print( sprintf( "** grand total = %9.3f %s", delta_g / factors[ scale ], scale ) )
	end )
	return S, S_
end
