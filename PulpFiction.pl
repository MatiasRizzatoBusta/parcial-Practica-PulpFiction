personaje(pumkin,ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny,ladron([licorerias, estacionesDeServicio])).
personaje(vincent,mafioso(maton)).
personaje(jules,mafioso(maton)).
personaje(marsellus,mafioso(capo)).
personaje(winston,mafioso(resuelveProblemas)).
personaje(mia,actriz([foxForceFive])).
personaje(butch,boxeador).

pareja(marsellus,mia).
pareja(pumkin,honeyBunny).

sonPareja(X,Y):-
    pareja(X,Y).

sonPareja(X,Y):- %hago que sea simetrico
    pareja(Y,X).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

esPeligroso(Personaje):-
    personaje(Personaje,Rol),
    realizaActividadPeligrosa(Rol).

esPeligroso(Personaje):-
    trabajaPara(Personaje,Empleado),
    esPeligroso(Empleado).

realizaActividadPeligrosa(mafioso(maton)).

realizaActividadPeligrosa(ladron(LugaresQueRoba)):-
    member(licorerias,LugaresQueRoba).%me fijo que licorerias este entre lo que roba
    
amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

sonAmigos(X,Y):-
    amigo(X,Y).

sonAmigos(X,Y):- %hago que sea simetrico
    amigo(Y,X).

esDuoTemible(Personaje,Compa):-
    sonAmigos(Personaje,Compa),
    losDosSonPeligrosos(Personaje,Compa).

esDuoTemible(Personaje,Pareja):-
    sonPareja(Personaje,Pareja),
    losDosSonPeligrosos(Personaje,Pareja).

losDosSonPeligrosos(Personaje,OtroPersonaje):-
    personaje(Personaje,_),
    esPeligroso(Personaje),
    personaje(OtroPersonaje,_),
    esPeligroso(OtroPersonaje).

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).
encargo(marsellus,vincent,ayudar(winston)). % se lo agrego para probar que masAtareado anda bien

estaEnProblemas(Personaje):-
    encargo(Jefe,Personaje,Encargo),
    esPeligroso(Jefe),
    encargoProblematico(Jefe,Encargo).

estaEnProblemas(butch). %siempre esta en problemas

encargoProblematico(Jefe,cuidar(Personaje)):-
    sonPareja(Jefe,Personaje).

encargoProblematico(_,buscar(Persona,_)):-
    personaje(Persona,boxeador).

sanCayetano(Personaje):-
    encargo(Personaje,Empleado,_),
    sonAmigos(Personaje,Empleado).

sanCayetano(Personaje):-
    encargo(Personaje,Empleado,_),
    trabajaPara(Personaje,Empleado).

masAtareado(Personaje):-
    personaje(Personaje,_),
    cuantosEncargosTiene(Personaje,CantidadDeEncargos),
    forall((personaje(OtroPersonaje,_),OtroPersonaje \= Personaje,cuantosEncargosTiene(OtroPersonaje,OtrosEncargos)),CantidadDeEncargos > OtrosEncargos).

cuantosEncargosTiene(Personaje,CantidadDeEncargos):-
    findall(Encargos,encargo(_,Personaje,Encargos),ListaEncargos),
    length(ListaEncargos,CantidadDeEncargos).

personajeRespetables(Personaje):-
    personaje(Personaje,Trabajo),
    prestigioTrabajo(Trabajo,Prestigio),
    Prestigio > 9.

prestigioTrabajo(actriz(ListaPeliculas),Prestigio):-
    length(ListaPeliculas,CantidadDePeliculas),
    Prestigio is (CantidadDePeliculas / 10).

prestigioTrabajo(mafioso(Rol),Prestigio):-
    queRolTieneElMafioso(Rol,Prestigio).

queRolTieneElMafioso(resuelveProblemas,10).
queRolTieneElMafioso(maton,1).
queRolTieneElMafioso(capo,20).

hartoDe(Personaje,OtroPersonaje):-
    personaje(Personaje,_),
    forall(encargo(_,Personaje,Encargo),conQuienTieneQueTrabajar(Personaje,Encargo)).

conQuienTieneQueTrabajar(Personaje,buscar(OtroPersonaje,_)):-
    personaje(Personaje,_),
    esAmigoOAmigoDeAmigo(Personaje,OtroPersonaje).

conQuienTieneQueTrabajar(Personaje,ayudar(OtroPersonaje)):-
    personaje(Personaje,_),
    esAmigoOAmigoDeAmigo(Personaje,OtroPersonaje).

conQuienTieneQueTrabajar(Personaje,cuidar(OtroPersonaje)):-
    personaje(Personaje,_),
    esAmigoOAmigoDeAmigo(Personaje,OtroPersonaje).

esAmigoOAmigoDeAmigo(Personaje,OtroPersonaje):-
    sonAmigos(OtroPersonaje,Personaje).

esAmigoOAmigoDeAmigo(Personaje,AmigoDelAmigo):-
    sonAmigos(Personaje,OtroPersonaje),
    esAmigoOAmigoDeAmigo(OtroPersonaje,AmigoDelAmigo).

caracteristicas(vincent,[negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,[tieneCabeza, muchoPelo]).
caracteristicas(marvin,[negro]).

duoDiferenciable(Personaje,OtroPersonaje):-
    sonAmigosOPareja(Personaje,OtroPersonaje),
    findall(Caracteristicas,caracteristicas(Personaje,Caracteristicas),ListasDeCaracteristicas),
    findall(OtrasCar,caracteristicas(OtroPersonaje,OtrasCar),OtraListaDeCar),
    not(ListasDeCaracteristicas == OtraListaDeCar). %si la lista de caracteristicas no son iguales es pq se diferencian en al menos 1.

sonAmigosOPareja(X,Y):-
    sonPareja(X,Y).

sonAmigosOPareja(X,Y):-
    sonAmigos(X,Y).