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
    member(licorerias,LugaresQueRoba).
    



