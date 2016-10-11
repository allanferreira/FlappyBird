--- Importar archivos LUA necesarios
require "qLearn"


---  Load del juego cada que se inicia una partida 
function game_load()
	gamestate = "game"
	fly = 1
	score = 0
	ready = 1
	if score > best then
		best = score
	end

	change = 0

	direct = 0

	---- Inicio Random del jugador dentro de la pantalla (3 posibles inicios arriba, abajo o en medio)
	inicio = math.random(1, 3)

	if inicio == 1 then
		inicial = math.random(3, 163)
   		posY = inicial
	elseif inicio == 2 then
		inicial = math.random(164, 326)
   		posY = inicial
	elseif inicio == 3 then
		inicial = math.random(326, 489)
   		posY = inicial
	end


	posX = iniX

	velY =0
	velX = 180

	------ Velocidad al darle click al usuario para causar un salto 
	jump = -120


   	first = 08
   	tbl = {}
   	for i=1,200 do
   		table.insert(tbl, math.random(27, 180))
   	end
   	
end

function game_mousepressed()
	if ready == 0 then
		ready = 1
	elseif ready == 1 then
		change = 1
		--velY = jump
	end
end

function game_draw()
	if ready == 1 then 
		first = first + 10
		for i=1,200 do
			love.graphics.draw(image, quad_holdback2, gamewidth - first + (i-1) * 180, tbl[i] - 190, 0, 1, 1, 0, 0)
		  	love.graphics.draw(image, quad_holdback1, gamewidth - first + (i-1) * 180, tbl[i] + 200, 0, 1, 1, 0, 0)
		end
	end
	
	-- ready
	if ready == 0 then
		love.graphics.draw(image,quadgetready,gamewidth/2-508/6,gameheight/3.5)
		love.graphics.draw(image,quadclick,gamewidth/2-286/6,gameheight/2.5)

		if(fly == 0) then
			posY = iniY - 3
			love.graphics.draw(image,quadbird2, posX, posY)
		end
		if(fly == 1) then
			love.graphics.draw(image,quadbird1, posX, posY)
			
		end
		if(fly == 2) then
			posY = iniY + 3
			love.graphics.draw(image,quadbird3, posX, posY)
		end
		if(fly == 3) then
			love.graphics.draw(image,quadbird1, posX, posY)
		end
		love.timer.sleep( 0.1 )

	elseif ready == 1 then	

		if(fly == 0) then
			love.graphics.draw(image,quadbird2, posX, posY, direct)
		end
		if(fly == 1) then
			love.graphics.draw(image,quadbird1, posX, posY, direct)
		end
		if(fly == 2) then
			love.graphics.draw(image,quadbird3, posX, posY, direct)
		end
		if(fly == 3) then
			love.graphics.draw(image,quadbird1, posX, posY, direct)
		end


		if posX > gamewidth - first + score * 180 then
			score = score + 1
			love.audio.play(passsound)
			--print(score)
		end

		-- score
		local sc = score
		local len = 0
		while math.floor(sc/10) ~= 0 do
			sc = math.floor(sc/10)
			len = len + 1
		end

		-- print(len)
		sc = score
		if sc == 0 then
			love.graphics.draw(image,quad_num[0],gamewidth/2-55/6,gameheight/5)
		end
		while sc ~= 0 do
			love.graphics.draw(image,quad_num[sc % 10],gamewidth/2 + len * 68 / 3 - 55/6, gameheight/5)
			sc = math.floor(sc / 10)
			len = len - 1
		end
		

		love.timer.sleep( 0.08 )
	end
end

function game_update(dt)
	tuberia = (tbl[score+1] + 206)
	tuberia2 = (tbl[score+1] + 86)

	if ready == 1 then

		nexthold = gamewidth - first + score * 180
		if nexthold > 270 then
			if (posY + 25) > tuberia then
				posicionActual = 1
				inicializar(dt)
			elseif (posY + 25) < tuberia and posY > tuberia2 then
				posicionActual = 2
				inicializar(dt)				
			elseif posY < tuberia2 then
				-- if math.abs(posY - tuberia2) < 15 then
					posicionActual = 3
					inicializar(dt)
				-- end
			end
		elseif nexthold <= 270 and nexthold > 133 then
			if (posY + 25) > tuberia then
				posicionActual = 4
				inicializar(dt)
			elseif (posY  + 25) < tuberia and posY > tuberia2 then
				-- if math.abs(((posY + 25) - tuberia)) < 25 then
					posicionActual = 5
					inicializar(dt)
				-- end
			elseif posY < tuberia2 then
				-- if math.abs(posY - tuberia2) < 15 then
					posicionActual = 6
					inicializar(dt)
				-- end
			end
		elseif nexthold <= 133 then	
			if posY < tuberia and posY > tuberia2 then
				if math.abs(((posY + 25) - tuberia)) < 25 then
					posicionActual = 7
					inicializar(dt)
				end
			end		
		end

		if nexthold > 270 then
			if (posY + 25) > tuberia then
				finalState = 1
				newState()
			elseif (posY + 25) < tuberia and posY > tuberia2 then
				finalState = 2
				newState()
			elseif posY < tuberia2 then
				-- if math.abs(posY - tuberia2) < 15 then
					finalState = 3
					newState()
				-- end
			end
		elseif nexthold <= 270 and nexthold > 133 then
			if (posY + 25) > tuberia then
				finalState = 4
				newState()
			elseif (posY + 25) < tuberia and posY > tuberia2 then
				-- if math.abs(((posY + 25) - tuberia)) < 25 then
					finalState = 5
					newState()
				-- end
			elseif posY < tuberia2 then
				if math.abs(posY - tuberia2) < 15 then
					finalState = 6
					newState()
				end
			end
		elseif nexthold <= 133 then
			if posY < tuberia and posY > tuberia2 then
				if math.abs(((posY + 25) - tuberia)) < 25 then
					finalState = 7
					newState()
				end
			end
		end

		velY = velY + 200 * dt
		posY = posY + velY * dt

		colision()
		bandera = false
	end
end

function inicializar(dt)
	randomAction = math.random()
	if randomAction < 0.5 then 
		velYTemp = velY
		position = posY
		position = position + velYTemp * dt
		first = first + 10
		nexthold = gamewidth - first + score * 180
		nextStep()
	elseif randomAction >= 0.5 then 
		velYTemp = jump
		position = posY
		position = position + velYTemp * dt
		first = first + 10
		nexthold = gamewidth - first + score * 180
		nextStep()
	end
end

function nextStep()
	if nexthold > 270 then
		if (position + 25) > tuberia then
			posicionNueva = 1
			if tempColision(position) == true then	
				calculate(-1000)
			elseif tempColision(position) == false then
				calculate(1)
			end
		elseif (position + 25) < tuberia and position > tuberia2 then
			posicionNueva = 2
			if tempColision(position) == true then	
				calculate(-1000)
			elseif tempColision(position) == false then
				calculate(1)
			end
		elseif position < tuberia2 then
			-- if math.abs(position - tuberia2) < 15 then
				posicionNueva = 3
				if tempColision(position) == true then	
					calculate(-1000)
				elseif tempColision(position) == false then
					calculate(1)
				end
			-- end
		end
	elseif nexthold <= 270 and nexthold > 133 then
		if (position + 25) > tuberia then
			posicionNueva = 3
			if tempColision(position) == true then	
				calculate(-1000)
			elseif tempColision(position) == false then
				calculate(1)
			end
		elseif  (position + 25) < tuberia and position > tuberia2 then
			-- if math.abs(((position + 25) - tuberia)) < 25 then
				posicionNueva = 4
				if tempColision(position) == true then	
					calculate(-1000)
				elseif tempColision(position) == false then
					calculate(1)
				end
			-- end
		elseif position < tuberia2 then 
			-- if math.abs(position - tuberia2) < 15 then
				posicionNueva = 5
				if tempColision(position) == true then	
					calculate(-1000)
				elseif tempColision(position) == false then
					calculate(1)
				end
			-- end
		end
	elseif nexthold <= 133 then
		if position < tuberia and position > tuberia2 then
			if math.abs(((position + 25) - tuberia)) < 25 then
				posicionNueva = 6
				if tempColision(position) == true then	
					calculate(-1000)
				elseif tempColision(position) == false then
					calculate(1)
				end
			end
		end
	end

end

function calculate(reward)
	if randomAction < 0.5 then
		value = states[posicionActual].noClick + .7*( reward + 1 * math.max(states[posicionNueva].yesClick, states[posicionNueva].noClick) - states[posicionActual].noClick)
		states[posicionActual].noClick = value
	elseif randomAction >= 0.5 then
		value = states[posicionActual].yesClick + .7*( reward + 1 * math.max(states[posicionNueva].yesClick, states[posicionNueva].noClick) - states[posicionActual].yesClick)
		states[posicionActual].yesClick = value
	end
	first = first - 10
	nexthold = gamewidth - first + score * 180
end

function colision()
	if posY >= 455  then
		game_load()
		return true
	end 

	if nexthold == 130 then
		if posY < tbl[score+1] + 70 then
			print("---------------------------------------- GAME OVER ----------------------------------------")
			game_load()
			return true
		end
		if (posY + 25) > tbl[score+1] + 205 then
			print("---------------------------------------- GAME OVER ----------------------------------------")
			game_load()
			return true
		end
	elseif nexthold < 130 then
		if posY < tbl[score+1] + 70 then
			print("---------------------------------------- GAME OVER ----------------------------------------")
			game_load()
			return true
		end
		if (posY + 25) > tbl[score+1] + 205 then
			print("---------------------------------------- GAME OVER ----------------------------------------")
			game_load()
			return true
		end
	end
	return false
end

function tempColision(position)
	local posY2 = position
	if posY2 + 25 >= 455  then
		return true
	end

	if nexthold == 130 then
		if posY2 < tbl[score+1] + 70 then
			return true
		end
		if (posY2 + 25) > tbl[score+1] + 205 then
			return true
		end
	elseif nexthold < 130 then
		if posY2 < tbl[score+1] + 70 then
			return true
		end
		if (posY2 + 25) > tbl[score+1] + 205 then
			return true
		end
	end
	return false
end

function newState()
	print("	        1    2    3    4    5    6    7")
	print("--------------------------------------------------------------------")
	io.write(string.format("noClick       %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n", states[1].noClick,states[2].noClick,states[3].noClick,states[4].noClick,states[5].noClick,states[6].noClick,states[7].noClick))
	io.write(string.format("yesClick      %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n", states[1].yesClick, states[2].yesClick,states[3].yesClick,states[4].yesClick,states[5].yesClick,states[6].yesClick,states[7].yesClick))
	print("")


	print("----------------------------------------------------------------------")
	print("Estado Actual < ", finalState)
	print("Opciones de acción:")
	print("NADA",states[finalState].noClick, "SALTAR: ",states[finalState].yesClick)


	if states[finalState].noClick < states[finalState].yesClick then
		print("El jugador saltara")
		velY = jump
	elseif states[finalState].noClick > states[finalState].yesClick then
		print("El jugador no hará nada")
		velY = velY
	elseif states[finalState].noClick == states[finalState].yesClick then
		random = math.random()
		if random < 0.5 then
			print("El jugador saltara")
			velY = jump
		elseif random >= 0.5 then
			print("El jugador no hará nada")
			velY = velY
		end
	end

end
