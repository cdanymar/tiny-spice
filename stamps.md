## Component Stamps

Each component applies a local stamp to the global system (`device.applyStamp()`). 
The labels $\text{in}$ and $\text{out}$ refer to the nodes to which a component is connected.

* $\text{in}$ and $\text{out}$ refer to connected nodes of a component.
* $\text{k}$ is the new device index in the matrix for voltage-defined components.
* The LHS matrix is the matrix of coefficients ($\mathbf{A}$).
* The RHS matrix is the volt-ampere matrix of independent sources ($\mathbf{z}$).

#### Resistor

$$
\begin{array}{rcc}
    & \begin{matrix} \text{in} & \text{out} \end{matrix} & \\
    \begin{matrix} \text{in} \\ \text{out} \end{matrix} &
    \begin{bmatrix} g & -g \\ -g & g \end{bmatrix} &
    \begin{bmatrix} 0 \\ 0 \end{bmatrix}
\end{array}
$$

#### Capacitor

$$
\begin{array}{rcc}
    & \begin{matrix} \text{in} & \text{out} \end{matrix} & \\
    \begin{matrix} \text{in} \\ \text{out} \end{matrix} &
    \begin{bmatrix} j\omega C & -j\omega C \\ -j\omega C & j\omega C \end{bmatrix} &
    \begin{bmatrix} 0 \\ 0 \end{bmatrix}
\end{array}
$$

#### Inductor

$$
\begin{array}{rcc}
    & \begin{matrix} \text{in} & \text{out} & \text{k} \end{matrix} & \\
    \begin{matrix} \text{in} \\ \text{out} \\ \text{k} \end{matrix} &
    \begin{bmatrix} 0 & 0 & 1 \\ 0 & 0 & -1 \\ 1 & -1 & -j\omega L \end{bmatrix} &
    \begin{bmatrix} 0 \\ 0 \\ 0 \end{bmatrix}
\end{array}
$$

#### Voltage Source

$$
\begin{array}{rcc}
    & \begin{matrix} \text{in} & \text{out} & \text{k} \end{matrix} & \\
    \begin{matrix} \text{in} \\ \text{out} \\ \text{k} \end{matrix} &
    \begin{bmatrix} 0 & 0 & 1 \\ 0 & 0 & -1 \\ 1 & -1 & 0 \end{bmatrix} &
    \begin{bmatrix} 0 \\ 0 \\ U \end{bmatrix}
\end{array}
$$

#### Current Source

$$
\begin{array}{rcc}
    & \begin{matrix} \text{in} & \text{out} \end{matrix} & \\
    \begin{matrix} \text{in} \\ \text{out} \end{matrix} &
    \begin{bmatrix} 0 & 0 \\ 0 & 0 \end{bmatrix} &
    \begin{bmatrix} -I \\ I \end{bmatrix}
\end{array}
$$

#### Breaker

**Closed state**

$$
\begin{array}{rcc}
    & \begin{matrix} \text{in} & \text{out} & \text{k} \end{matrix} & \\
    \begin{matrix} \text{in} \\ \text{out} \\ \text{k} \end{matrix} &
    \begin{bmatrix} 0 & 0 & 1 \\ 0 & 0 & -1 \\ 1 & -1 & 0 \end{bmatrix} &
    \begin{bmatrix} 0 \\ 0 \\ 0 \end{bmatrix}
\end{array}
$$

**Open state**

$$
\begin{array}{}
    & \begin{matrix} \text{in} & \text{out} & \text{k} \end{matrix} & \\
    \begin{matrix} \text{in} \\ \text{out} \\ \text{k} \end{matrix} &
    \begin{bmatrix} 0 & 0 & 0 \\ 0 & 0 & 0 \\ 0 & 0 & 1 \end{bmatrix} &
    \begin{bmatrix} 0 \\ 0 \\ 0 \end{bmatrix}
\end{array}
$$
