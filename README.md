# CMPLXSY-Predator-Prey

This model explores predator-prey ecosystem's stability, particularly in the "fishes-shark" aspect. A system is called unstable if it tends to result in extinction for one or more species involved. In contrast, a system is stable if it tends to maintain itself over time, despite fluctuations in population sizes.

## HOW IT WORKS

The environment will simulate an ocean ecosystem, a predator-prey simulation, that focuses on specific animals as predators and prey together with a fixed food agent. The food regrows overtime at a fixed rate and will provide sustenance for the prey while the prey provides sustenance for the predator. The agents will roam the environment/space with a common goal to replenish their energy as it depletes with their movement. The movement of the predator and prey will depend on their hunger/energy and will die out when not eaten in a duration of steps.

### Preys [also a Food] - Fish 
Preys roam around the space looking for food (Kelps) as sustenance to find. They must eat Kelps as food to keep moving. For each step the prey has done, it depletes energy. For each kelp eaten by the fish, their energy comes back. Fishes also have a fixed probability of reproducing after each step.

### Predators - Shark
Predators also roam around the space looking for food (Fish) as sustenance to find. They must eat fish as food to keep moving. For each step the predator has done, it depletes energy. For each fish eaten by the shark, their energy comes back. Sharks also have a fixed probability of reproducing after each step as long as they have a certain amount of energy.

### Food - Kelps
A finite resource in the environment. Kelps regrow when eaten at a fixed rate. Can only be eaten by fishes. Provides sustenance for fishes to replenish lost energy.
