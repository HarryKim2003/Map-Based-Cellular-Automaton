# Map-Based Cellular Automaton  

![Simulation Screenshot](images/sample.png) <!-- Replace with your own image -->

---

## Project Description  

This project is an interactive simulation that models how competing influences spread across a geographic map.  
Each pixel is treated as a **cell** in a cellular automaton, which evolves through multiple levels of influence.  
Over time, regions shift between **neutral**, **red team**, and **blue team** states depending on local interactions and propagation rules.  

---

## Technical Highlights  

- **Efficient Pixel Updates:** Built in **Processing/Java** with optimized rendering to handle thousands of cells per frame.  
- **Influence-Propagation Algorithm:** Weighted neighbor sums with generational thresholds.  
- **Flexible Rules:** Designed customizable state-transition logic for experimenting with different propagation models.  
- **Smooth Visualization:** Optimized rendering loop for interactive exploration and real-time feedback.  

---

## Applications  

While framed here as “Red vs. Blue Team,” the framework can be adapted to simulate:  

- Information or idea spread  
- Competitive dynamics (e.g., product adoption)  
- Territory control in strategy games  
- Diffusion processes on irregular maps  

---

## Possible States of a Cell  

A cell can be in one of three states:  

- **Neutral**  
- **Red Team**  
- **Blue Team**  

Each team has three progressive **stages of influence**:  

- Stage 1 = Weak alignment  
- Stage 2 = Partial alignment  
- Stage 3 = Fully entrenched  

The brighter the shade, the stronger the cell’s ties to its team and the greater its influence on neighboring cells.  

![State Diagram](images/states.png) <!-- Replace with your own diagram -->

---

## Key Features  

- **Map Integration:** Any image map can be loaded as the simulation domain.  
- **Multi-Level Influence System:** Each cell’s strength determines both its resilience and its influence.  
- **Dynamic Evolution Rules:**  
  - Neutral regions are highly susceptible to change.  
  - Weakly aligned regions can shift allegiance under sustained pressure.  
  - Strong regions reinforce their surroundings.  
- **Visualization:** Real-time rendering with gradients showing relative team strength.  

---

## Evolution Rules  

1. Each cell exerts influence on its neighbors based on its stage:  
   - Stage 3 → Influence = 3  
   - Stage 2 → Influence = 2  
   - Stage 1 → Influence = 1  

2. Stage 3 cells:  
   - If opposed or balanced, they have a 50% chance to weaken (drop to Stage 1, Stage 2, or Neutral).  
   - If favored, they never change.  

3. Stage 1 & 2 cells:  
   - Opposing influence > Ally influence → Cells weaken over time (Stage 2 → Stage 1 after 7 generations, Stage 1 → Neutral after 12 generations).  
   - Ally influence > Opposing influence → Cells strengthen (Stage 1 → Stage 2 after 12 generations, Stage 2 → Stage 3 after 7 generations).  
   - Equal influence → Slow drift toward stronger stages.  

4. Neutral cells:  
   - Convert in **3 generations** if influenced more strongly by one team.  
   - Stay neutral if influence is balanced.  

---

## Sample Evolution  

**First Generation:**  
- Cells 1, 2, 3, 4, 7 → Stage 1 Blue  
- Cells 5, 6, 10, 13 → Stage 2 Blue  
- Cell 9 → Stage 3 Blue  
- Cell 12 → Stage 1 Red  
- Cells 15, 16 → Stage 2 Red  
- Cells 8, 11, 14 → Neutral  

**Second Generation:**  
- Cell 7 advances to Stage 2 Blue (influence factor = 7).  
- Cell 8 becomes Blue (influence factor = 2).  
- Cell 11 becomes Blue (influence factor = 1).  

![Evolution Example](images/evolution.png) <!-- Replace with your evolution example screenshot -->

---

