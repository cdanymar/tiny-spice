# Tiny SPICE

This is my final Matlab project for the Computer Programming 1 (BPA-PP1) course.

**SPICE** (Simulation Program with Integrated Circuit Emphasis) is type of tools for 
simulating electronic circuits. While professional versions like
[LTspice](https://www.analog.com/en/resources/design-tools-and-calculators/ltspice-simulator.html)
or [PSpice](https://www.ti.com/tool/PSPICE-FOR-TI) are massive, well-maintained and 
feature-heavy, **Tiny SPICE** is a ~~useless~~ lightweight, educational project. 

## Main Algorithm

The two main methods for electric circuit analysis (within EL1 and EL2) are the **Node 
Voltage Method (NVM)** and the **Mesh Current Method (MCM)**. Both are based on 
Kirchhoff’s laws and lead to systems of linear equations:

* **NVM** (node voltages as unknowns):
  $$\mathbf{G}\mathbf{u} = \mathbf{i}$$
* **MCM** (mesh currents as unknowns):
  $$\mathbf{R}\mathbf{i} = \mathbf{u}$$

While suitable for manual analysis on paper, in most cases they are far from optimal 
for computers  because handling voltage sources in NVM or current sources in MCM 
requires manual source transformations. To avoid this, **Tiny SPICE** uses **Modified 
Nodal Analysis (MNA)**.

---

### Modified Nodal Analysis (MNA)

MNA extends the node voltage method by introducing additional unknowns for currents 
through voltage-defined elements and branches (not meshes nor loops!). The resulting 
system is solved as:

> This model of MNA assumes only ideal sources and linear elements; I don't want to 
> explain the details of the method unless they are part of my project.

$$
\begin{bmatrix}
    \mathbf{G_{n \times n}} & \mathbf{B_{n \times m}} \\
    \mathbf{B^T}            & \mathbf{D_{m \times m}}
\end{bmatrix}
\begin{bmatrix}
    \mathbf{v} \\
    \mathbf{j}
\end{bmatrix} =
\begin{bmatrix}
    \mathbf{i} \\
    \mathbf{u}
\end{bmatrix}
$$

Where:
* $n$ is the number of reference nodes (total number without the ground).
* $m$ is the number of voltage-defined branches.
* $\mathbf{G}$ is the admittance of passive component.
* $\mathbf{B}$ is the incidence of voltage-defined branches.
* $\mathbf{D}$ is the internal impedance of voltage-defined component.
* $\mathbf{v}$ is the vector of unknown node voltages.
* $\mathbf{j}$ is the vector of unknown branch currents.
* $\mathbf{i}$ is the vector of independent current sources.
* $\mathbf{u}$ is the vector of independent voltage sources.

---

### Component Stamps

Each element applies a local stamp to the global system (`@Device.applyStamp()`). $in$ 
and $out$ refer to the nodes to which a component is connected to.

#### Resistor
$$
\begin{array} 
    @{\hspace{1em}} & 
    \begin{matrix} 
        \text{in} & \text{out}
    \end{matrix} \\
    \begin{matrix}
        \text{in} \\
        \text{out} 
    \end{matrix} & 
    \begin{bmatrix}
        g & -g \\ 
        -g & g 
    \end{bmatrix} &
    \begin{bmatrix} 
        0 \\ 
        0 
    \end{bmatrix}
\end{array}
$$

#### Capacitor

$$
\begin{array} 
    @{\hspace{1em}} &
    \begin{matrix}
        \text{in} & \text{out}
    \end{matrix} \\
    \begin{matrix}
        \text{in} \\
        \text{out}
    \end{matrix} &
    \begin{bmatrix}
        j\omega C & -j\omega C \\
        -j\omega C & j\omega C
    \end{bmatrix} &
    \begin{bmatrix}
        0 \\
        0
    \end{bmatrix}
\end{array}
$$

#### Inductor

$$
\begin{array}
    @{\hspace{1em}} &
    \begin{matrix}
        \text{in} & \text{out} & \text{k}
    \end{matrix} \\
    \begin{matrix}
        \text{in} \\
        \text{out} \\
        \text{k}
    \end{matrix} &
    \begin{bmatrix}
        0 & 0 & 1 \\
        0 & 0 & -1 \\
        1 & -1 & -j\omega L
    \end{bmatrix}
    \begin{bmatrix}
        0 \\
        0 \\
        0
    \end{bmatrix}
\end{array}
$$

#### Voltage Source

$$
\begin{array} 
    @{\hspace{1em}} &
    \begin{matrix}
        \text{in} & \text{out} & \text{k}
    \end{matrix} \\
    \begin{matrix}
        \text{in} \\
        \text{out} \\
        \text{k}
    \end{matrix} &
    \begin{bmatrix}
        0 & 0 & 1 \\
        0 & 0 & -1 \\
        1 & -1 & 0
    \end{bmatrix} &
    \begin{bmatrix}
        0 \\
        0 \\
        U
    \end{bmatrix}
\end{array}
$$

#### Current Source

$$
\begin{array} 
    @{\hspace{1em}} &
    \begin{matrix}
        \text{in} & \text{out}
    \end{matrix} \\
    \begin{matrix}
        \text{in} \\
        \text{out}
    \end{matrix} &
    \begin{bmatrix}
        0 & 0 \\
        0 & 0
    \end{bmatrix} &
    \begin{bmatrix}
        -I \\
        I
    \end{bmatrix}
\end{array}
$$

## Todo

- [x] Write readme [`0da1c61`](https://github.com/cdanymar/tiny-spice/commit/0da1c6103dd302678ebf525bd06387d9ac21a2bd)
- [ ] Implement basic components
  - [ ] Resistor
  - [ ] Voltage source
- [ ] Implement more complex components
  - [ ] Inductor
  - [ ] Capacitor
  - [ ] Diode
  - [ ] Current source
- [ ] Implement more fun components
  - [ ] Zener diode
  - [ ] Light-emitting diode
  - [ ] Thevenin's equivalent / component combination 
- [ ] Implement AC
- [ ] Implement transient analysis
- [ ] Create UI
  - [ ] Circuit builder
  - [ ] Main menu
- [ ] Add serialization/deserialization
- [ ] Create some API usage examples
- [ ] Dockerize (maybe)
- [ ] Rewrite in C++

## License

**Unlicense** – I don't give a fuck what anyone does with this code; copy if you want.
