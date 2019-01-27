# MathematicaMVA
MathematicaMVA is a Mathematica package implementing mean-value analysis (MVA) for closed queueing networks in Mathematica. It has been used for researching alternative MVA formulas which also have been implemented in the package.

## Installation
- Download the [QueueingNetworks.wl](https://github.com/meteoorkip/MathematicaMVA/raw/master/QueueingNetworks.wl "Right click->save as...") file.
- Install it as described on [support.wolfram.com/kb/5648](http://support.wolfram.com/kb/5648).

## Usage
+ [1. Basics](#1-basics)
    - [1.1 Load the package](#11-load-the-package)
    - [1.2 Creating a queueing network](#12-creating-a-queueing-network)
+ [2. Retrieving values](#2-retrieving-values)
    - [2.1 Retrieving the station scheduling](#21-retrieving-the-station-scheduling)
    - [2.2 Retrieving the service times](#22-retrieving-the-service-times)
    - [2.3 Retrieving the routing probabilities](#23-retrieving-the-routing-probabilities)
+ [3. Calculating values](#3-calculating-values)
    - [3.1 Calculating the visit counts](#31-calculating-the-visit-counts)
    - [3.2 Calculating the service demands](#32-calculating-the-service-demands)
    - [3.3 Calculating the throughput](#33-calculating-the-throughput)
    - [3.4 Calculating the expected number of customers](#34-calculating-the-expected-number-of-customers)
    - [3.5 Calculating the expected response time](#35-calculating-the-expected-response-time)
    - [3.6 Calculating the expected response time per passage](#36-calculating-the-expected-repsonse-time-per-passage)
+ [4. Using the formulas](#4-using-the-formulas)
    - [4.1 Calculating the state space](#41-calculating-the-state-space)
    - [4.2 Using the 2 FCFS formula](#42-using-the-2-fcfs-formula)
    - [4.3 Using the M FCFS formula](#43-using-the-m-fcfs-formula)
    - [4.4 Using the M FCFS and N IS formula](#44-using-the-m-fcfs-and-n-is-formula)

### 1. Basics

#### 1.1 Load the package
Load the package by using:
```Mathematica
<< QueueingNetworks`
```

#### 1.2 Creating a queueing network
A queueing network can be created using the `QueueingNetwork` function. The `QueueingNetwork` function requires a list of stations and a list of routes as arguments.

Stations are represented as a tuple of scheduling and service time. The scheduling can be either `FCFS` or `IS`. The service time can be a number or a variable. An FCFS station with service time `s1` would be represented as `{FCFS,s1}`.

Routes are represented as a tuple of the route itself and the routing probability. The route itself is a [`Rule`](https://reference.wolfram.com/language/ref/Rule.html), [`TwoWayRule`](https://reference.wolfram.com/language/ref/TwoWayRule.html), [`DirectedEdge`](https://reference.wolfram.com/language/ref/DirectedEdge.html) or [`UndirectedEdge`](https://reference.wolfram.com/language/ref/UndirectedEdge.html) between two station indices (starting from 1). The routing probability can be a number or a variable. A route from station 1 to station 2 with routing probability `r12` would be represented as `{1 -> 2, r12}`.

An example queueing network would be:
```Mathematica
network = QueueingNetwork[
  {{FCFS, 10}, {IS, 100}, {FCFS, 20}, {FCFS, 120}},
  {{1 -> 3, 4/5}, {1 -> 4, 1/5}, {2 -> 1, 1}, {3 -> 1, 1/2}, {3 -> 2, 1/2}, {4 -> 1, 3/4}, {4 -> 2, 1/4}}
]
```
Which yields the following queueing network:

![Example queueing network](https://github.com/meteoorkip/MathematicaMVA/raw/master/images/network1.svg?sanitize=true "Example queueing network")

We will continue to use this queueing network and refer to it as `network` in the examples.

### 2. Retrieving values

#### 2.1 Retrieving the station scheduling
The station scheduling can be retrieved by using the `Scheduling` function. The `Scheduling` function requires a queueing network as argument and gives a list of schedules. An index argument can be added to retrieve the scheduling of a single station.

##### 2.1.1 Examples
```Mathematica
In[1]  = Scheduling[network]
Out[1] = {FCFS, IS, FCFS, FCFS}

In[2]  = Scheduling[network, 2]
Out[2] = IS
```

#### 2.2 Retrieving the service times
The service times can be retrieved using the `ServiceTime` function. The `ServiceTime` function requires a queueing network as argument and gives a list of service times. An index argument can be added to retrieve the service time of a single station.

##### 2.2.1 Examples
```Mathematica
In[1]  = ServiceTime[network]
Out[1] = {10, 100, 20, 120}

In[2]  = ServiceTime[network, 1]
Out[2] = 10
```

#### 2.3 Retrieving the routing probabilities
The routing probabilities can be retrieved using the `RoutingProbability` function. The `RoutingProbability` function requires a queueing network as argument and gives a matrix of routing probabilities. An index argument can be added to retrieve a list of routing probabilities originating from a single station. Another index argument can be added to retrieve the routing probability of a single route.

##### 2.3.1 Examples
```Mathematica
In[1]  = RoutingProbability[network]
Out[1] = {{0, 0, 4/5, 1/5}, {1, 0, 0, 0}, {1/2, 1/2, 0, 0}, {3/4, 1/4, 0, 0}}

In[2]  = RoutingProbability[network, 1]
Out[2] = {0, 0, 4/5, 1/5}

In[3]  = RoutingProbability[network, 1, 3]
Out[3] = 4/5
```

### 3. Calculating values
For the next set of examples we will introduce another queueing network:
```Mathematica
variableNetwork = QueueingNetwork[
  {{FCFS, s1}, {FCFS, s2}, {FCFS, s3}},
  {{1 -> 3, r13}, {2 -> 1, r21}, {2 -> 2, r22}, {3 -> 1, r31}, {3 -> 2, r32}}
]
```
Which yields the following network:

![Example queueing network with variables](https://github.com/meteoorkip/MathematicaMVA/raw/master/images/network2.svg?sanitize=true "Example queueing network with variables")

We will refer to this network as `variableNetwork` in the examples.

#### 3.1 Calculating the visit counts
The visit counts can be calculated using the `VisitCount` function. The `VisitCount` function requires a queueing network as argument and yields a list of visit counts. An index argument can be added to calculate the visit count of a single station.

:information_source: `VisitCount` is a [Functions That Remember Values They Have Found](https://reference.wolfram.com/language/tutorial/FunctionsThatRememberValuesTheyHaveFound.html) to improve speed.

:warning: Visit count calculation is currently in an experimental state and might yield incorrect results. If needed, visit counts can be manually set using:
```Mathematica
VisitCount[network] = {v1, v2, v3, v4}
```

##### 3.1.1 Examples
```Mathematica
In[1]  = VisitCount[network]
Out[1] = {1, 9/20, 4/5, 1/5}

In[2]  = VisitCount[network, 4]
Out[2] = 1/5

In[3]  = VisitCount[variableNetwork]
Out[3] = {1, -(r32/(-1 + r22)), 1}
```

#### 3.2 Calculating the service demands
The service demands can be calculated using the `ServiceDemand` function. The `ServiceDemand` function requires a queueing network as argument and yields a list of service demands. An index argument can be added to calculate the service demand of a single station.

##### 3.2.1 Examples
```Mathematica
In[1]  = ServiceDemand[network]
Out[1] = {10, 45, 16, 24}

In[2]  = ServiceDemand[network, 1]
Out[2] = 10

In[3]  = ServiceDemand[variableNetwork]
Out[3] = {s1, -((r32 s2)/(-1 + r22)), s3}
```

#### 3.3 Calculating the throughput
The throughput is calculated using the following formula, in a queueing network with <img src="https://latex.codecogs.com/svg.latex?M" alt="M"/> stations and <img src="https://latex.codecogs.com/svg.latex?K" alt="K"/> customers:

<img src="https://latex.codecogs.com/svg.latex?X(K)=K\cdot\frac{1}{\sum^M_{i=1}E[\hat{R}_i(K)]}" alt="X(K)=K\cdot\frac{1}{\sum^M_{i=1}E[\hat{R}_i(K)]}"/>

The throughput of the whole queueing network can be calculated using the `Throughput` function. The `Throughput` function requires a queueing network and the total number of customers as arguments. The result can be a number or, if there are free variables in the queueing network, an expression.

##### 3.3.1 Examples
```Mathematica
In[1]  = Throughput[network, 1]
Out[1] = 1/95

In[2]  = Throughput[network, 2]
Out[2] = 190/9957

In[3]  = Throughput[variableNetwork, 1]
Out[3] = 1/(s1 - (r32 s2)/(-1 + r22) + s3)
```

#### 3.4 Calculating the expected number of customers
The expected number of customers is calculated using the following formula, in a queueing network with <img src="https://latex.codecogs.com/svg.latex?K" alt="K"/> customers:

<img src="https://latex.codecogs.com/svg.latex?E[N_i(K)]=X(K)\cdot&space;E[\hat{R}_i(K)]" alt="E[N_i(K)]=X(K)\cdot&space;E[\hat{R}_i(K)]"/>

The expected number of customers can be calculated using the `ExpectedNumberOfCustomers` function. The `ExpectedNumberOfCustomers` function requires a queueing network and the total number of customers as arguments and yields a list of expected customer counts. An index argument can be added to calculate the expected number of customers of a single station.

##### 3.4.1 Examples
```Mathematica
In[1]  = ExpectedNumberOfCustomers[network, 1]
Out[1] = {2/19, 9/19, 16/95, 24/95}

In[2]  = ExpectedNumberOfCustomers[network, 2]
Out[2] = {2850/3319, 700/3319, 1184/3319, 1904/3319}

In[3]  = ExpectedNumberOfCustomers[network, 1, 1]
Out[3] = 2/19

In[4]  = ExpectedNumberOfCustomers[variableNetwork, 1, 1]
Out[4] = s1/(s1 - (r32 s2)/(-1 + r22) + s3)
```

#### 3.5 Calculating the expected response time
The expected response time is calculated using the following formula, in a queueing network with <img src="https://latex.codecogs.com/svg.latex?K" alt="K"/> customers; with <img src="https://latex.codecogs.com/svg.latex?E[S_i]" alt="E[S_i]"/> denoting the service time of station <img src="https://latex.codecogs.com/svg.latex?i" alt="i"/>:

<img src="https://latex.codecogs.com/svg.latex?\begin{align*}\text{FCFS:&space;}E[R_i(K)]&=(E[N_i(K-1)]&plus;1)\cdot&space;E[S_i]\\\text{IS:&space;}E[R_i(K)]&=E[S_i]\end{align*}" alt="\begin{align*}\text{FCFS:&space;}E[R_i(K)]&=(E[N_i(K-1)]&plus;1)\cdot&space;E[S_i]\\\text{IS:&space;}E[R_i(K)]&=E[S_i]\end{align*}"/>

The expected response time can be calculated using the `ExpectedResponseTime` function. The `ExpectedResponseTime` function requires a queueing network and the total number of customers as arguments and yields a list of expected response times. An index argument can be added to calculate the expected response time of a single station.

##### 3.5.1 Examples
```Mathematica
In[1]  = ExpectedResponseTime[network, 1]
Out[1] = {10, 100, 20, 120}

In[2]  = ExpectedResponseTime[network, 2]
Out[2] = {210/19, 100, 444/19, 2856/19}

In[3]  = ExpectedResponseTime[network, 2, 2]
Out[3] = 100

In[4]  = ExpectedResponseTime[variableNetwork, 2, 2]
Out[4] = s2 (1 - (r32 s2)/((-1 + r22) (s1 - (r32 s2)/(-1 + r22) + s3)))
```

#### 3.6 Calculating the expected response time per passage
The expected response time per passage is calculated using the following formula, in a queueing network with <img src="https://latex.codecogs.com/svg.latex?K" alt="K"/> customers; with <img src="https://latex.codecogs.com/svg.latex?V_i" alt="V_i"/> denoting the visit count of station <img src="https://latex.codecogs.com/svg.latex?i" alt="i"/>:

<img src="https://latex.codecogs.com/svg.latex?E[\hat{R}_i(K)]=E[R_i(K)]\cdot&space;V_i" alt="E[\hat{R}_i(K)]=E[R_i(K)]\cdot&space;V_i"/>

The expected response time per passage can be calculated using the `ExpectedResponseTimePerPassage` function. The `ExpectedResponseTimePerPassage` function requires a queueing network and the total number of customers as arguments and yields a list of expected response times per passage. An index argument can be added to calculate the expected response time per passage of a single station.

##### 3.5.1 Examples
```Mathematica
In[1]  = ExpectedResponseTimePerPassage[network, 1]
Out[1] = {10, 45, 16, 24}

In[2]  = ExpectedResponseTimePerPassage[network, 2]
Out[2] = {210/19, 45, 1776/95, 2856/95}

In[3]  = ExpectedResponseTimePerPassage[network, 1, 2]
Out[3] = 45

In[4]  = ExpectedResponseTimePerPassage[variableNetwork, 2, 2]
Out[4] = (r32 s2 (1 - (r32 s2)/((-1 + r22) (s1 - (r32 s2)/(-1 + r22) + s3))))/(-1 + r22)
```

### 4. Using the formulas
For the next set of examples we will introduce another queueing network:
```Mathematica
twoFCFSnetwork = QueueingNetwork[
  {{FCFS, s1}, {FCFS, s2}},
  {{1 -> 2, 1}, {2 -> 1, 1}}
]
```
Which yields the following network:

![Example queueing network with variables](https://github.com/meteoorkip/MathematicaMVA/raw/master/images/network3.svg?sanitize=true "Example queueing network with two FCFS stations")

We will refer to this network as `twoFCFSnetwork` in the examples.

#### 4.1 Calculating the state space
The state space uses the following formula, in a queueing network with <img src="https://latex.codecogs.com/svg.latex?M" alt="M"/> stations and <img src="https://latex.codecogs.com/svg.latex?K" alt="K"/> customers:

<img src="https://latex.codecogs.com/svg.latex?\mathcal{I}(M,K)=\{(n_1&plus;\dotsb&plus;n_m)\in\mathbb{N}^M|\sum^M_{i=1}n_i=K\}" alt="\mathcal{I}(M,K)=\{(n_1&plus;\dotsb&plus;n_m)\in\mathbb{N}^M|\sum^M_{i=1}n_i=K\}"/>

The state space can be calculated using the `StateSpace` function. The `StateSpace` function requires the number of station and the total number of customers as arguments and yields the state space.

##### 4.1.1 Examples
```Mathematica
In[1]  = StateSpace[3, 2]
Out[1] = {{2, 0, 0}, {0, 2, 0}, {0, 0, 2}, {1, 1, 0}, {1, 0, 1}, {0, 1, 1}}

In[2]  = StateSpace[2, 3]
Out[2] = {{3, 0}, {0, 3}, {2, 1}, {1, 2}}
```

#### 4.2 Using the 2 FCFS formula
The following formulas have been derived for queueing networks with 2 FCFS stations and <img src="https://latex.codecogs.com/svg.latex?K" alt="K"/> customers; with <img src="https://latex.codecogs.com/svg.latex?D_i" alt="D_i"/> denoting the service demand of station <img src="https://latex.codecogs.com/svg.latex?i" alt="i"/>:

<img src="https://latex.codecogs.com/svg.latex?\begin{align*}E[N_a(K)]&=\frac{\sum^K_{i=0}((K-i){D_a}^{K-1}{D_b}^i)}{\sum^K_{j=0}({D_a}^{K-j}{D_b}^j)}\\E[\hat{R}_a(K)]&=\frac{\sum^K_{i=0}((K-i){D_a}^{K-i}{D_b}^i)}{\sum^{K-1}_{j=0}({D_a}^{K-1-j}{D_b}^j)}\end{align*}" alt="\begin{align*}E[N_a(K)]&=\frac{\sum^K_{i=0}((K-i){D_a}^{K-1}{D_b}^i)}{\sum^K_{j=0}({D_a}^{K-j}{D_b}^j)}\\E[\hat{R}_a(K)]&=\frac{\sum^K_{i=0}((K-i){D_a}^{K-i}{D_b}^i)}{\sum^{K-1}_{j=0}({D_a}^{K-1-j}{D_b}^j)}\end{align*}"/>

The formulas can be applied with the `ExpectedResponseTimePerPassageTwoFCFSFormula` and the `ExpectedNumberOfCustomersTwoFCFSFormula` functions. There are two ways to call these functions.

The first way is by using the queueing network and the total number of customers as arguments. This applies the formula to all stations and returns a list of results. An index argument can be added to apply the formula for a single station

The second way is using the service demand of the first station (a), the service demand of the second station (b) and the total number of customers as arguments. This applies the formula to the first station.

##### 4.2.1 Examples
```Mathematica
In[1]  = ExpectedNumberOfCustomersTwoFCFSFormula[twoFCFSnetwork, 1]
Out[1] = {s1/(s1 + s2), s2/(s1 + s2)}

In[2]  = ExpectedNumberOfCustomersTwoFCFSFormula[twoFCFSnetwork, 2, 1]
Out[2] = (2 s1^2 + s1 s2)/(s1^2 + s1 s2 + s2^2)

In[3]  = ExpectedNumberOfCustomersTwoFCFSFormula[d1, d2, 2]
Out[3] = (2 d1^2 + d1 d2)/(d1^2 + d1 d2 + d2^2)

In[4]  = ExpectedResponseTimePerPassageTwoFCFSFormula[twoFCFSnetwork, 1]
Out[4] = {s1, s2}

In[5]  = ExpectedResponseTimePerPassageTwoFCFSFormula[twoFCFSnetwork, 2, 2]
Out[5] = (s1 s2 + 2 s2^2)/(s1 + s2)

In[6]  = ExpectedResponseTimePerPassageTwoFCFSFormula[d1, d2, 2]
Out[6] = (2 d1^2 + d1 d2)/(d1 + d2)
```

#### 4.3 Using the M FCFS formula
The following formulas have been derived for queueing networks with <img src="https://latex.codecogs.com/svg.latex?M" alt="M"/> FCFS stations and <img src="https://latex.codecogs.com/svg.latex?K" alt="K"/> customers; with <img src="https://latex.codecogs.com/svg.latex?D_i" alt="D_i"/> denoting the service demand of station <img src="https://latex.codecogs.com/svg.latex?i" alt="i"/>:

<img src="https://latex.codecogs.com/svg.latex?\begin{align*}E[N_i(K)]&=\frac{\sum_{\underline{n}\in\mathcal{I}(M,K)}(n_i\prod^M_{j=1}{D_j}^{n_j})}{\sum_{\underline{n}\in\mathcal{I}(M,K)}(\prod^M_{j=1}{D_j}^{n_j})}\\E[\hat{R}_i(K)]&=\frac{\sum_{\underline{n}\in\mathcal{I}(M,K)}(n_i\prod^M_{j=1}{D_j}^{n_j})}{\sum_{\underline{n}\in\mathcal{I}(M,K-1)}(\prod^M_{j=1}{D_j}^{n_j})}\end{align*}" alt="\begin{align*}E[N_i(K)]&=\frac{\sum_{\underline{n}\in\mathcal{I}(M,K)}(n_i\prod^M_{j=1}{D_j}^{n_j})}{\sum_{\underline{n}\in\mathcal{I}(M,K)}(\prod^M_{j=1}{D_j}^{n_j})}\\E[\hat{R}_i(K)]&=\frac{\sum_{\underline{n}\in\mathcal{I}(M,K)}(n_i\prod^M_{j=1}{D_j}^{n_j})}{\sum_{\underline{n}\in\mathcal{I}(M,K-1)}(\prod^M_{j=1}{D_j}^{n_j})}\end{align*}"/>

The formulas can be applied with the `ExpectedResponseTimePerPassageFCFSFormula` and the `ExpectedNumberOfCustomersFCFSFormula` functions. There are two ways to call these functions.

The first way is by using the queueing network and the total number of customers as arguments. This applies the formula to all stations and returns a list of results. An index argument can be added to apply the formula for a single station.

The second way is using a list of service demands and the total number of customers as arguments. This applies the formula to the first station. An index argument can be added to apply the formula for a single station.

##### 4.3.1 Examples
```Mathematica
In[1]  = ExpectedNumberOfCustomersFCFSFormula[twoFCFSnetwork, 1]
Out[1] = {s1/(s1 + s2), s2/(s1 + s2)}

In[2]  = ExpectedNumberOfCustomersFCFSFormula[variableNetwork, 1, 2]
Out[2] = -((r32 s2)/((-1 + r22) (s1 - (r32 s2)/(-1 + r22) + s3)))

In[3]  = ExpectedNumberOfCustomersFCFSFormula[{d1, d2, d3}, 1]
Out[3] = {d1/(d1 + d2 + d3), d2/(d1 + d2 + d3), d3/(d1 + d2 + d3)}

In[4]  = ExpectedNumberOfCustomersFCFSFormula[{d1, d2, d3}, 1, 2]
Out[4] = d2/(d1 + d2 + d3)

In[5]  = ExpectedResponseTimePerPassageFCFSFormula[twoFCFSnetwork, 1]
Out[5] = {s1, s2}

In[6]  = ExpectedResponseTimePerPassageFCFSFormula[variableNetwork, 1, 2]
Out[6] = -((r32 s2)/(-1 + r22))

In[7]  = ExpectedResponseTimePerPassageFCFSFormula[{d1, d2, d3}, 1]
Out[7] = {d1, d2, d3}

In[8]  = ExpectedResponseTimePerPassageFCFSFormula[{d1, d2, d3}, 2, 1]
Out[8] = (2 d1^2 + d1 d2 + d1 d3)/(d1 + d2 + d3)
```

#### 4.4 Using the M FCFS and N IS formula
The following formulas for FCFS stations have been derived for queueing networks with <img src="https://latex.codecogs.com/svg.latex?M" alt="M"/> FCFS stations, <img src="https://latex.codecogs.com/svg.latex?N" alt="N"/> IS stations and <img src="https://latex.codecogs.com/svg.latex?K" alt="K"/> customers; with <img src="https://latex.codecogs.com/svg.latex?D_i" alt="D_i"/> denoting the service demand of station <img src="https://latex.codecogs.com/svg.latex?i" alt="i"/>, <img src="https://latex.codecogs.com/svg.latex?\underline{M}" alt="\underline{M}"/> denoting the indices of the FCFS stations and <img src="https://latex.codecogs.com/svg.latex?\underline{N}" alt= "\underline{N}"/> denoting the indices of the IS stations:

<img src="https://latex.codecogs.com/svg.latex?\begin{align*}E[N_i(K)]&=\frac{\sum_{\underline{n}\in\mathcal{I}(M,K)}(K!\cdot&space;n_i\cdot\prod_{j\in\underline{M}}({D_j}^{n_j})\cdot\prod_{j\in\underline{N}}(\frac{{D_j}^{n_j}}{n_j!}))}{\sum_{\underline{n}\in\mathcal{I}(M,K)}(K!\cdot\prod_{j\in\underline{M}}({D_j}^{n_j})\cdot\prod_{j\in\underline{N}}(\frac{{D_j}^{n_j}}{n_j!}))}\\E[\hat{R}_i(K)]&=\frac{\sum_{\underline{n}\in\mathcal{I}(M,K-1)}((K-1)!\cdot(n_i&plus;1)D_i\cdot\prod_{j\in\underline{M}}({D_j}^{n_j})\cdot\prod_{j\in\underline{N}}(\frac{{D_j}^{n_j}}{n_j!}))}{\sum_{\underline{n}\in\mathcal{I}(M,K-1)}((K-1)!\cdot\prod_{j\in\underline{M}}({D_j}^{n_j})\cdot\prod_{j\in\underline{N}}(\frac{{D_j}^{n_j}}{n_j!}))}\end{align*}" alt="\begin{align*}E[N_i(K)]&=\frac{\sum_{\underline{n}\in\mathcal{I}(M,K)}(K!\cdot&space;n_i\cdot\prod_{j\in\underline{M}}({D_j}^{n_j})\cdot\prod_{j\in\underline{N}}(\frac{{D_j}^{n_j}}{n_j!}))}{\sum_{\underline{n}\in\mathcal{I}(M,K)}(K!\cdot\prod_{j\in\underline{M}}({D_j}^{n_j})\cdot\prod_{j\in\underline{N}}(\frac{{D_j}^{n_j}}{n_j!}))}\\E[\hat{R}_i(K)]&=\frac{\sum_{\underline{n}\in\mathcal{I}(M,K-1)}((K-1)!\cdot(n_i&plus;1)D_i\cdot\prod_{j\in\underline{M}}({D_j}^{n_j})\cdot\prod_{j\in\underline{N}}(\frac{{D_j}^{n_j}}{n_j!}))}{\sum_{\underline{n}\in\mathcal{I}(M,K-1)}((K-1)!\cdot\prod_{j\in\underline{M}}({D_j}^{n_j})\cdot\prod_{j\in\underline{N}}(\frac{{D_j}^{n_j}}{n_j!}))}\end{align*}"/>

The formulas can be applied with the `ExpectedResponseTimePerPassageFCFSAndISFormula` and the `ExpectedNumberOfCustomersFCFSAndISFormula` functions. There are two ways to call these functions.

The first way is by using the queueing network and the total number of customers as arguments. This applies the formula to all stations and returns a list of results. An index argument can be added to apply the formula for a single station.

The second way is using a list of service demands, a list of station scheduling and the total number of customers as arguments. This applies the formula to the first station. An index argument can be added to apply the formula for a single station.

##### 4.4.1 Examples
```Mathematica
In[1]  = ExpectedNumberOfCustomersFCFSAndISFormula[network, 1]
Out[1] = {2/19, 9/19, 16/95, 24/95}

In[2]  = ExpectedResponseTimePerPassageFCFSAndISFormula[twoFCFSnetwork, 2, 1]
Out[2] = (2 s1^2 + s1 s2)/(s1 + s2)

In[3]  = ExpectedNumberOfCustomersFCFSAndISFormula[{d1, d2}, {IS, FCFS}, 1]
Out[3] = {d1/(d1 + d2), d2/(d1 + d2)}

In[4]  = ExpectedNumberOfCustomersFCFSAndISFormula[{d1, d2, d3}, {IS, FCFS, FCFS}, 1, 2]
Out[4] = d2/(d1 + d2 + d3)

In[5]  = ExpectedResponseTimePerPassageFCFSAndISFormula[network, 1]
Out[5] = {10, 45, 16, 24}

In[6]  = ExpectedResponseTimePerPassageFCFSAndISFormula[exampleNetwork, 1, 2]
Out[6] = -((r32 s2)/(-1 + r22))

In[7]  = ExpectedResponseTimePerPassageFCFSAndISFormula[{10, 15}, {IS, FCFS}, 4]
Out[7] = {2590/157, 7890/157}

In[8]  = ExpectedResponseTimePerPassageFCFSAndISFormula[{10, 15, d3}, {IS, FCFS, IS}, 2, 2]
Out[8] = (600 + 15 d3)/(25 + d3)
```
