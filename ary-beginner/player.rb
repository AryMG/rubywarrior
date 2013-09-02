class Player
  def play_turn(warrior)
    # level 9
    #investigar porque el array no me funciono
    if @health == nil
    	@health = warrior.health
    	@direccion=:forward
        @hechicero=0
    end
 
   if warrior.feel.empty? #no hay nada adelante
        #observa como esta tu salud

        if @health > warrior.health #estoy siendo atacado de lejos
            @hechicero=0
        end

        if warrior.health<20 && @hechicero == 0 
            warrior.shoot!(@direccion)
            @hechicero =1
        elsif warrior.health < 18
            warrior.rest!    
        else

            warrior.walk!(@direccion)
        end
   else #hay algo delante
        if warrior.feel.wall? #es una pared
            warrior.pivot!
        elsif warrior.feel.enemy?
            warrior.attack!(@direccion)
        elsif warrior.feel.captive?
            warrior.rescue!
        else    
            warrior.shoot!(@direccion)
        end

   end     
    @health =  warrior.health
   
   end
end

