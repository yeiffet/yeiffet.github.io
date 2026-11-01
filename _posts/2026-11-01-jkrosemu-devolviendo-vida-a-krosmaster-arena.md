---
layout: posts
title: "JKrosEmu: devolviéndole la vida a Krosmaster Arena"
date: 2026-11-01 21:11:31 +0100
category: gamedev
tag: gamedev
header-image: /assets/images/jkrosemu/kros3d.jpg
---

Como ya adelanté en la [entrada anterior](/como-ha-cambiado-todo-en-4-años/), uno de los proyectos que tengo entre manos es **JKrosEmu**: un emulador de servidor para **Krosmaster Arena 3D**, un juego de Ankama el cual cerraron sus servidores oficiales hace ya un tiempo y que, para mí, era un pequeño vicio diario. Un juego de tablero por turnos con figuras físicas que también se podía jugar online, si ya el juego de mesa es excepcional, el video juego le da una un toque "vivo" bastante chulo.

El problema es que sin servidores oficiales, el cliente del juego arranca, se intenta conectar a la nada y no se puede hacer funcionar. Fin.
La idea de JKrosEmu es sencilla, montar un servidor que hable el mismo protocolo que entendía el cliente original, y que éste no se entere de 
que al otro lado ya no está Ankama, sino un programa que los sustituye, ya sea en local (en el propio ordenador) o como antes, online. Aquí quiero introducirlo un poco más
y que cada progreso vaya actualizando, ya que parece que no soy yo solo el que quiere volver a jugarlo.

## ¿Qué es exactamente JKrosEmu?

El servidor un proyecto en **C# sobre .NET 8**, una aplicación de consola que levanta cuatro servidores TCP, tal y como estaba montados cuando estaban activos:

- **HAAPI** (puerto 8400) — autenticación falsa de Ankama (como ya no existe, le decimos al cliente "tranquilo, este usuario es válido")
- **LOBBY** (8100) — login, selección de equipo, matchmaking
- **MATCH** (8200) — toda la lógica de la partida en sí
- **COLLECTION** (8300) — colección de figuras del jugador

Para poder hacer funcionar lo más fidedignamente y sin casi modificaciones del cliente original (si no habido más remedio que hacerlas) se usan las DLLs de una librería que tiene el juego
para la comunicación con lo cual es **byte-idéntico** al protocolo original, por lo tanto el cliente no se entera de que no es oficial.

Como he dicho anteriormente hay un par de parches mínimos en el cliente, por ejemplo, para que lea un fichero local con direcciones de ip para conectar a cualquier servidor, esté donde esté.

## ¿En qué punto está?

Resumen rápido del estado actual:

### Lo que ya funciona end-to-end

- **Partidas multijugador LAN/Online** verificadas entre dos PCs. Me he echado partidas enteras contra mi hijo sin romperse nada relevante.
- **Partidas vs AI** — hay un bot que juega, mueve, lanza hechizos y compra en celdas demoníacas. No es Deep Blue, pero da la pelea.
- **Flujo completo de un turno**: tirada de tensión, dados de inspiración, movimiento con dados de placaje/esquiva, lanzamiento de hechizos con dados de crítico/armadura, muerte, robo de GG, etc.
- **Más de 240 figuras** cargadas desde el catálogo real del cliente, con sus hechizos, poderes, stats, etiquetas de familia…
- **Invocaciones** (summons) — bombas con su cuenta atrás, trampas que se disparan al pisar, criaturas (mobs) que tienen su propio turno en el timeline…
- **Recompensas Demoníacas** — la tienda y la mecánica de compra/asignación/activación están cerradas de principio a fin, con placeholders por ahora (los efectos reales de las 60 recompensas las implementaré en las próximas sesiones).




### Lo que llevo refactorizado

En algún punto el `MatchSession.cs` llegó a tener **4200 líneas** (sí, cuatro mil doscientas) No quería refactorizar hasta tener algo decente funcionando, pero bueno, era un monolito espantoso pero trabajo así y luego lo dejo bien estructurado con lo cual lo partí en 11 servicios bien delimitados:

```
MatchSession (orquestador, 386 líneas)
├── MatchState        (estado mutable de la partida)
├── MatchBroadcaster  (helpers de envío por el cable)
├── MarkerManager     (buffs/debuffs efímeros)
├── SummonManager     (invocaciones)
├── MovementResolver  (movimiento, placajes)
├── SpellCaster       (resolución de hechizos)
├── StrainMaster      (dados de tensión)
├── EconomyManager    (kamas, GG, recompensas demoníacas)
├── AiController      (bot)
└── TurnStateMachine  (máquina de estados de turnos/fases)
```

Es un refactor por servicios (package-by-feature), de momento no tendrá arquitectura hexagonal, pero deja la casa en orden para seguir metiendo contenido sin volverme loco buscando dónde cada cosa. Por supuesto el objetivo es tener una buena arquitectura.
Pero no nos pongamos técnicos, seguramente la gente que quiere jugar esto le de completamente igual.

### Lo último que he añadido

Las últimas sesiones de desarrollo se han ido metiendo **habilidades (poderes) de los campeones** por tandas. Hoy en día están implementadas, entre otras:

- **Insensible** (bloquea empujes/atracciones)
- **Toupiti** (bypass total de placajes)
- **Prospección** (+1 kama al matar un Krosmaster)
- **Granjero** (+1 kama bonus al final del turno si recogió kamas)
- **Alcance Salvaje** (más rango de hechizos si tienes Salvajes aliados)
- **Jalatero Real** (aura de Placaje + Armadura a aliados de la familia Jalató)
- **Bucanero** (si recibes ≥2 pts de daño, tus aliados Piwatas se curan 1 HP)

Más los poderes de siempre que ya estaban desde el principio (Crítico, Armadura, Placaje, Esquiva, Fuerza, Agilidad, Suerte, Inteligencia, Sabiduría, Resistencias elementales…).

Y bastante **wiring de cartas específicas de champions**: Sfinter Cell con sus 4 Tortugas y mecánica de picker, Caballero Justicia con Escudo de Justicia (intercambio de posición), Anathar con sus combos de daño + empuje/atracción, y un batch de ~9 campeones invocadores (Katar, Moon, Dragosa, Ledrag, Miaubuelo Protector…). Si si, están en el juego...

## ¿Qué viene ahora?

El siguiente gran bloque es **implementar los efectos reales de las 60 recompensas demoníacas del juego**. Hoy están todas creadas y asignables, pero la mitad del efecto se queda en placeholder (una Multi-slap "funciona" en el sentido de que la compras, la pones en un Krosmaster y la activas, pero el daño extra que debería dar al siguiente hechizo todavía no está wireado). Son 60 recompensas con mecánicas únicas y claro, estaba del lado del servidor en ankama, con lo cual así que hay que implementarlas todas e irán por tandas:

1. BOOSTS (one-shots) — ~17 cartas
2. BUFFS (temporales hasta tu siguiente turno) — ~15
3. EQUIPMENT (permanentes) — ~16
4. Techniques (modifican el puñetazo) — 8

Y en paralelo, lo que va quedando de poderes bespoke de 1-2 figuras y algunos sistemas que están todavía stub (multi-tablero, trampas estela, mecanismos de desplazamiento…).

Si alguien está metido en el mundillo de Krosmaster y quiere trastear, está todo en [GitHub](https://github.com/Yeiffet/JKrosEmu). Y si eres de los que jugó en su día y lo echas de menos, dentro de poco espero poder decir "oye, descárgate esto y vuelve a jugar". Aún queda camino, pero se avanza.

¡Hasta la próxima bitácora!
