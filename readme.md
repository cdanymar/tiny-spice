# tinySPICE

This is my final Matlab project for the Computer Programming 1 (BPA-PP1) course.

**SPICE** (Simulation Program with Integrated Circuit Emphasis) is type of tools for 
simulating electronic circuits. While professional versions like
[LTspice](https://www.analog.com/en/resources/design-tools-and-calculators/ltspice-simulator.html)
or [PSpice](https://www.ti.com/tool/PSPICE-FOR-TI) are massive, well-maintained and 
feature-heavy, **Tiny SPICE** is a ~~useless~~ lightweight, educational project. 

## Usage

    matlab -nodesktop -nosplash -r "cd src; runApp"

## Examples

I included several circuit examples in the `examples` folder.
1. Launch program
2. Open a circuit json file (File > Open)
3. Run AC analysis (Run > AC (HSS) Analysis)
4. Enter desired frequency. I recommend 50 as the low frequency and 5,000,000 as the high.

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

### Modified Nodal Analysis (MNA)

> This model of MNA assumes only ideal sources and linear elements; I don't want to
> explain the details of the method unless they are part of my project.

MNA extends the node voltage method by introducing additional unknowns for currents 
through voltage-defined elements and branches (not meshes nor loops!). The resulting 
system is solved as:

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

where:
* $n$ is the number of reference nodes (total number without the ground).
* $m$ is the number of voltage-defined branches.
* $\mathbf{G}$ is the admittance of passive component.
* $\mathbf{B}$ is the incidence of voltage-defined branches.
* $\mathbf{D}$ is the internal impedance of voltage-defined component.
* $\mathbf{v}$ is the vector of unknown node voltages.
* $\mathbf{j}$ is the vector of unknown branch currents.
* $\mathbf{i}$ is the vector of independent current sources.
* $\mathbf{u}$ is the vector of independent voltage sources.

Individual stamps of all available components can be viewed [here](stamps.md).

## License

**Unlicense** – I don't give a fuck what anyone does with this code; copy if you want.
