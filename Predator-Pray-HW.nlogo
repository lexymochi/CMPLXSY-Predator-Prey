globals [ fixed-regrowth-time fish-reproduction-chance shark-reproduction-chance fish-energy-gained shark-energy-gained ]

breed [ sharks shark ]
breed [ fishes fish ]

turtles-own [ energy ] ; both shark and fish have energy

patches-own [ countdown ] ; patches have a countdown to regrow kelp

to setup
  clear-all

  set fixed-regrowth-time 30 ; kelp regrowth time set to 30
  set fish-reproduction-chance 10 ; fish reproduction chance 10%
  set shark-reproduction-chance 5 ; shark reproduction chance 5%
  set fish-energy-gained 10 ; fish replenishes 10 energy from eating kelp
  set shark-energy-gained 6; shark replenishes 6 energy from eating fish

  ask patches
  [
    ifelse random 100 < density [ ; create kelp based on density
      set pcolor green
      set countdown fixed-regrowth-time ; fixed kelp regrow time
    ] [
      set pcolor blue
      set countdown random fixed-regrowth-time
    ]
  ]

  create-fishes initial-number-fishes ; create the fishes, then initialize variables
  [
    set shape "fish"
    set color orange
    set size 1
    set energy 10 + random 16 ; starting energy for fishes (10-15)
    setxy random-xcor random-ycor
  ]

  create-sharks initial-number-sharks ; create the sharks, then initialize variables
  [
    set shape "shark"
    set color grey
    set size 3
    set energy 10 + random 21 ; starting energy for sharks (10-20)
    setxy random-xcor random-ycor
  ]
  reset-ticks
end

to go
  if not any? turtles [ stop ] ; stop if no turtles

  ;; Stop if either fishes, sharks, or kelp are gone
  if stop-after-an-extinction? [
    if not any? fishes or not any? sharks or count patches with [pcolor = green] = 0 [
      stop
  ]

  ]

  if stop-after-500-ticks? [ ; stop after 500 ticks switch
    if ticks >= 500 [ stop ]
  ]

  update-turtles
  ask patches [ grow-kelp ]
  tick
  display-labels
end


to move ; turtle movement
  rt random 30 - 15 ;
  fd 1
end

to eat-kelp
  ; once kelp is eaten, turn the patch to blue
  if pcolor = green [
    set pcolor blue
    set countdown fixed-regrowth-time ; start regrowth countdown only when help is eaten
    set energy energy + fish-energy-gained ; fish replenishes energy from eating kelp
  ]
end

to reproduce-fishes
  if random-float 100 < fish-reproduction-chance [
    set energy (energy / 2) ; divide energy between the parent and child
    hatch 1 [ rt random-float 360 fd 1 ]
  ]
end

to reproduce-sharks
  if energy > 20 and random-float 100 < shark-reproduction-chance [
    set energy (energy / 2) ; divide between the parent and child
    hatch 1 [rt random-float 360 fd 1 ]
  ]
end

to eat-fish
  let prey one-of fishes in-radius 1
  if prey != nobody [
    ask prey [ die ]
    set energy energy + shark-energy-gained ; shark replenishes energy from eating fish
  ]
end

to update-turtles
  ask turtles [
    move
    ifelse breed = fishes [
      set energy energy - 1
      eat-kelp
      reproduce-fishes
    ] [
      set energy energy - 1.5 ; sharks use up more energy when walking compared to fish
      eat-fish
      reproduce-sharks
    ]
    death
  ]
end

to death
  ; for both fish and shark
  if energy < 0 [ die ] ; when energy = 0 turtle will die
end

to grow-kelp
  if pcolor = blue [
    ifelse countdown <= 0 [ ; when counter reaches 0, grow kelp
      set pcolor green
      set countdown fixed-regrowth-time
    ] [
      set countdown countdown - 1 ; else -1 from countdown
    ]
  ]
end

to-report kelp
  report patches with [pcolor = green]
end

to display-labels
  ask turtles [ set label "" ]
  if show-energy? [
    ask turtles [ set label round energy ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
556
13
1270
728
-1
-1
13.85
1
14
1
1
1
0
1
1
1
-25
25
-25
25
1
1
1
ticks
30.0

SLIDER
78
203
250
236
density
density
0
100
30.0
1
1
NIL
HORIZONTAL

BUTTON
181
108
246
142
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
268
156
441
189
initial-number-sharks
initial-number-sharks
0
200
100.0
1
1
NIL
HORIZONTAL

SLIDER
78
156
251
189
initial-number-fishes
initial-number-fishes
0
200
100.0
1
1
NIL
HORIZONTAL

BUTTON
269
108
333
142
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
229
310
286
355
Kelp
count kelp
17
1
11

MONITOR
172
310
229
355
Fish
count fishes
17
1
11

MONITOR
285
310
342
355
Sharks
count sharks
17
1
11

SWITCH
77
257
211
290
show-energy?
show-energy?
1
1
-1000

PLOT
63
364
483
630
Prey-Predator Populations
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -955883 true "" "plot count fishes"
"pen-1" 1.0 0 -9276814 true "" "plot count sharks"

SWITCH
269
204
441
237
stop-after-500-ticks?
stop-after-500-ticks?
0
1
-1000

SWITCH
248
254
443
287
stop-after-an-extinction?
stop-after-an-extinction?
1
1
-1000

@#$#@#$#@
## WHAT IS IT?

This model explores predator-prey ecosystem's stability, particularly in the "fishes-shark" aspect. A system is called unstable if it tends to result in extinction for one or more species involved. In contrast, a system is stable if it tends to maintain itself over time, despite fluctuations in population sizes.

## HOW IT WORKS

The environment will simulate an ocean ecosystem, a predator-prey simulation, that focuses on specific animals as predators and prey together with a fixed food agent. The food regrows overtime at a fixed rate and will provide sustenance for the prey while the prey provides sustenance for the predator. The agents will roam the environment/space with a common goal to replenish their energy as it depletes with their movement. The movement of the predator and prey will depend on their hunger/energy and will die out when not eaten in a duration of steps.

### Preys [also a Food] - Fish 
Preys roam around the space looking for food (Kelps) as sustenance to find. They must eat Kelps as food to keep moving. For each step the prey has done, it depletes energy. For each kelp eaten by the fish, their energy comes back. Fishes also have a fixed probability of reproducing after each step.

### Predators - Shark
Predators also roam around the space looking for food (Fish) as sustenance to find. They must eat fish as food to keep moving. For each step the predator has done, it depletes energy. For each fish eaten by the shark, their energy comes back. Sharks also have a fixed probability of reproducing after each step.

### Food - Kelps
A finite resource in the environment. Kelps regrow when eaten at a fixed rate. Can only be eaten by fishes. Provides sustenance for fishes to replenish lost energy.


## HOW TO USE IT

1. Adjust the slider and switch parameters if needed.
2. Press the SETUP button.
3. Press the GO button to begin the simulation.
4. Look at the Predator-Prey Population plot to see the current population sizes.
5. Look at the Fish, Kelp, and Shark monitor to see the number of food eaten over time.

### PARAMETERS:
	density - The number of patches with kelp
	initial-number-sharks - The initial size of shark population
	initial-number-fishes - The initial size of fish population
	stop-after-500-ticks? - Whether the model will stop after 500 ticks or not
	show-energy? - Whether the energy of the sharks and fishes would be shown or not

## THINGS TO NOTICE

Look for the graph of the population of the preys and predators as the ecosystem runs.

## THINGS TO TRY

Try to adjust the amount of preys, predators, and density of the food to see if new patterns emerge. Additionally, you can edit the global variable's values to see how it will affect the population of the preys and predators.

## EXTENDING THE MODEL

Adding variability of the turtles (fishes and sharks) may yield different results. By having a mix of small and big predators and preys, it may yield different results when the ecosystem runs.

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

The fishes-sharks prey-predator ecosystem made was based on sheeps-wolves model from the NetLogo Models Library 

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

shark
false
0
Polygon -7500403 true true 283 153 288 149 271 146 301 145 300 138 247 119 190 107 104 117 54 133 39 134 10 99 9 112 19 142 9 175 10 185 40 158 69 154 64 164 80 161 86 156 132 160 209 164
Polygon -7500403 true true 199 161 152 166 137 164 169 154
Polygon -7500403 true true 188 108 172 83 160 74 156 76 159 97 153 112
Circle -16777216 true false 256 129 12
Line -16777216 false 222 134 222 150
Line -16777216 false 217 134 217 150
Line -16777216 false 212 134 212 150
Polygon -7500403 true true 78 125 62 118 63 130
Polygon -7500403 true true 121 157 105 161 101 156 106 152

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
