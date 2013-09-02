class Player
  def play_turn(warrior)
    # level 7 intermediate
    @eNemies=0 #variable para saber cuantos enemigos tengo alrededor
    @Captives=0 # variable para saber cuantos captives tengo alrededor
    @direXion=[:left,:right,:backward,:forward] #array con todas las direcciones posibles a mi alrededor
    @ArrayEnemie=[] #array para guardar la direccion donde tengo los enemigos que me rodean
    @ArrayCaptive=[] # array para guardar la direccion donde tengo los captives que me rodean
    @contador=0 # variable para saber en que posicion del array warrior.listen esta el ticking , si no hay se va al first

    if warrior.listen.empty? #si no hay nada
        warrior.walk!(warrior.direction_of_stairs)#sal del lugar       
    else
        #PRIMERO DETERMINO HACIA DONDE TENGO QUE IR SI HAY UN CAPTIVE TICKING
        #ciclo para saber donde esta el ticking

        a=0 #variable temporal para moverme entre el array listen
        warrior.listen.each { |ticK|
            if warrior.listen[a].ticking?
                @contador=a
            end
            a=a+1

        }

        if @contador==0   #significa que no hay ticking
            @aDondeVoy = warrior.direction_of(warrior.listen.first)
        else
            @aDondeVoy = warrior.direction_of(warrior.listen[@contador])
        end
        
#si encuentro las escaleras pero no he terminado con los enemigos
        if warrior.feel(@aDondeVoy).stairs?
            @direXion.each { |dir|

                if dir != @aDondeVoy
                    if warrior.feel(dir).empty?
                        @direccion=dir               
                    end
                end
            }
            puts @direccion    
            warrior.walk!(@direccion)



         else   
        
                        #PRIMERO CHECO QUE TENGO ALREDEDOR
                @direXion.each { |dir|
                    if warrior.feel(dir).enemy?
                        @eNemies = @eNemies+1
                        if dir != @aDondeVoy 
                            @ArrayEnemie.push(dir) 
                        end           
                    end
                    if warrior.feel(dir).captive?
                        @Captives= @Captives+1
                        @ArrayCaptive.push(dir)
                                
                    end
                }
                if @eNemies==1  && @ArrayEnemie.empty?
                    @ArrayEnemie.push(@aDondeVoy)
                end


                
                if warrior.look[0].enemy? && warrior.look[1].enemy? && warrior.health >= 6 
                    @detona=1
                else
                    @detona=0
                
                end        
               
                #si tengo mas de un enemigo primero les hago bind
                    if @eNemies > 1
                        warrior.bind!(@ArrayEnemie.first) 
                    
                    elsif @eNemies == 1 && @detona==1 && warrior.health >=6
                        warrior.detonate!
                        
                    elsif @eNemies == 1 && @detona != 1
                            if  warrior.listen[@contador].ticking? && @ArrayEnemie.first != @aDondeVoy
                                 warrior.walk!(@aDondeVoy)
                            else
                                warrior.attack!(@ArrayEnemie.first)
                            end
                                              
                     elsif @eNemies < 1 && warrior.feel(@aDondeVoy).empty?
                            if warrior.health < 16 && warrior.listen[@contador].ticking? == false #
                                warrior.rest!
                            elsif warrior.listen.count > 7 && warrior.health < 14
                                warrior.rest!

                            else
                                warrior.walk!(@aDondeVoy)
                            end
                              

                    elsif warrior.feel(@aDondeVoy).captive?
                            if warrior.health < 16 && warrior.listen[@contador].ticking? == false
                                warrior.rest!
                            else
                                warrior.rescue!(@aDondeVoy)
                            end                

                             
                    
                   
                   end
          
        end
           
    end
  end
end














