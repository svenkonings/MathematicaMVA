(* ::Package:: *)

(* ::Title:: *)
(*Queueing Networks*)


BeginPackage["QueueingNetworks`"]


(* ::Section:: *)
(*Usage*)


(* ::Subsection:: *)
(*Definition*)


QueueingNetwork::usage="QueueingNetwork[stations, routes] yields a queueing network."


(* ::Subsection:: *)
(*Values*)


Scheduling::usage="Scheduling[network] gives the scheduling of all stations in the queueing network.
Scheduling[network, index] gives the scheduling of the station with the given index in the queueing network."


ServiceTime::usage="ServiceTime[network] gives the service times of all stations in the queueing network.
ServiceTime[network, index] gives the service time of the station with the given index in the queueing network."


RoutingProbability::usage="RoutingProbability[network] gives the routing probabilities of all routes in the queueing network.
RoutingProbability[network, fromIndex] gives the routing probabilities of all routes originating from the station with the fromIndex in the queueing network.
RoutingProbability[network, fromIndex, toIndex] gives the routing probability between the station with the fromIndex and the station with the toIndex in the queueing network."


(* ::Subsection:: *)
(*Computed values*)


VisitCount::usage="VisitCount[network] gives the visit counts of all stations in the queueing network.
VisitCount[network, index] gives the visit count of the station with the given index in the queueing network."


ServiceDemand::usage="ServiceDemand[network] gives the service demands of all stations in the queueing network.
ServiceDemand[network, index] gives the service demands of the statoin with the given index in the queueing network."


Throughput::usage="Throughput[network, customers] gives the throughput of the queueing network for the given number of customers."


ExpectedNumberOfCustomers::usage="ExpectedNumberOfCustomers[network, customers] gives the expected number of customers for all stations in the queueing network with the given number of customers.
ExpectedNumberOfCustomers[network, customers, index] gives the expected number of customers for the station with the given index in the queueing network with the given number of customers."


ExpectedResponseTime::usage="ExpectedResponseTime[network, customers] gives the expected response time for all stations in the queueing network with the given number of customers.
ExpectedResponseTime[network, customers, index] gives the expected response time for the station with the given index in the queueing network with the given number of customers."


ExpectedResponseTimePerPassage::usage="ExpectedResponseTimePerPassage[network, customers] gives the expected response time per passage for all stations in the queueing network with the given number of customers.
ExpectedResponseTime[network, customers, index] gives the expected response time per passage for the station with the given index in the queueing network with the given number of customers."


(* ::Subsection:: *)
(*Formulas*)


(* ::Subsubsection:: *)
(*General*)


StateSpace::usage="StateSpace[m,k] gives the state space of a queueing network with m stations and k customers."


(* ::Subsubsection:: *)
(*Two FCFS*)


ExpectedResponseTimePerPassageTwoFCFSFormula::usage="ExpectedResponseTimePerPassageTwoFCFSFormula[network, customers] gives the expected response time per passage for all stations in the queueing network with two FCFS stations and the given number of customers.
ExpectedResponseTimePerPassageTwoFCFSFormula[network, customers, index] gives the expected response time per passage of the station with the given index in the queueing network with two FCFS stations and the given number of customers.
ExpectedResponseTimePerPassageTwoFCFSFormula[serviceDemand1, serviceDemand2, customers] gives the expected response time for the first station given the service demands of two FCFS stations."


ExpectedNumberOfCustomersTwoFCFSFormula::usage="ExpectedNumberOfCustomersTwoFCFSFormula[network, customers] gives the expected number of customers for all stations in the queueing network with two FCFS stations and the given number of customers.
ExpectedNumberOfCustomersTwoFCFSFormula[network, customers, index] gives the expected number of customers of the station with the given index in the queueing network with two FCFS stations and the given number of customers.
ExpectedNumberOfCustomersTwoFCFSFormula[serviceDemand1, serviceDemand2, customers] gives the expected number of customers for the first station given the service demands of two FCFS stations."


(* ::Subsubsection:: *)
(*M FCFS*)


ExpectedResponseTimePerPassageFCFSFormula::usage="ExpectedResponseTimePerPassageFCFSFormula[network, customers] gives the expected response time per passage for all stations in the queueing network with only FCFS stations and the given number of customers.
ExpectedResponseTimePerPassageFCFSFormula[network, customers, index] gives the expected response time per passage of the station with the given index in the queueing network with only FCFS stations and the given number of customers.
ExpectedResponseTimePerPassageFCFSFormula[serviceDemands, customers] gives the expected response time for all stations given their service demands.
ExpectedResponseTimePerPassageFCFSFormula[serviceDemands, customers, index] gives the expected response time for the station with the given index given the service demands of all FCFS stations."


ExpectedNumberOfCustomersFCFSFormula::usage="ExpectedNumberOfCustomersFCFSFormula[network, customers] gives the expected number of customers for all stations in the queueing network with only FCFS stations and the given number of customers.
ExpectedNumberOfCustomersFCFSFormula[network, customers, index] gives the expected number of customers of the station with the given index in the queueing network with only FCFS stations and the given number of customers.
ExpectedNumberOfCustomersFCFSFormula[serviceDemands, customers] gives the expected number of customers for all stations given their service demands.
ExpectedNumberOfCustomersFCFSFormula[serviceDemands, customers, index] gives the expected number of customers for the station with the given index given the service demands of all FCFS stations."


(* ::Subsubsection:: *)
(*M FCFS and N IS*)


ExpectedResponseTimePerPassageFCFSAndISFormula::usage="ExpectedResponseTimePerPassageFCFSAndISFormula[network, customers] gives the expected response time per passage for all stations in the queueing network with FCFS and IS stations and the given number of customers.
ExpectedResponseTimePerPassageFCFSAndISFormula[network, customers, index] gives the expected response time per passage of the station with the given index in the queueing network with FCFS and IS stations and the given number of customers.
ExpectedResponseTimePerPassageFCFSAndISFormula[serviceDemands, customers] gives the expected response time for all stations given their service demands.
ExpectedResponseTimePerPassageFCFSAndISFormula[serviceDemands, customers, index] gives the expected response time for the station with the given index given the service demands of all stations."


ExpectedNumberOfCustomersFCFSAndISFormula::usage="ExpectedNumberOfCustomersFCFSAndISFormula[network, customers] gives the expected number of customers for all stations in the queueing network with FCFS and IS stations and the given number of customers.
ExpectedNumberOfCustomersFCFSAndISFormula[network, customers, index] gives the expected number of customers of the station with the given index in the queueing network with FCFS and IS stations and the given number of customers.
ExpectedNumberOfCustomersFCFSAndISFormula[serviceDemands, customers] gives the expected number of customers for all stations given their service demands.
ExpectedNumberOfCustomersFCFSAndISFormula[serviceDemands, customers, index] gives the expected number of customers for the station with the given index given the service demands of all stations."


(* ::Section:: *)
(*Code*)


Begin["Private`"]


(* ::Subsection:: *)
(*Helpers*)


mapPart[l_List,i_Integer]:=#[[i]]&/@l


propertyValues[g_Graph,property_]:=Table[PropertyValue[{g,v},property],{v,VertexList[g]}]


(* ::Subsection:: *)
(*Definition*)


QueueingNetwork[
	stations:{{(Global`IS|Global`FCFS),_}..},
	routes:{{(_Rule|_TwoWayRule|_DirectedEdge|_UndirectedEdge),_}..}
]:=Graph[
	MapIndexed[Property[First[#2],scheduling->First[#1]]&,stations],
	mapPart[routes,1],
	VertexWeight->mapPart[stations,2],
	EdgeWeight->mapPart[routes,2],
	VertexLabels->"VertexWeight",
	EdgeLabels->"EdgeWeight"
]


(* ::Subsection:: *)
(*Values*)


Scheduling[g_Graph]:=propertyValues[g,scheduling]
Scheduling[g_Graph,i_Integer]:=PropertyValue[{g,i},scheduling]


ServiceTime[g_Graph]:=propertyValues[g,VertexWeight]
ServiceTime[g_Graph,i_Integer]:=PropertyValue[{g,i},VertexWeight]


RoutingProbability[g_Graph]:=Normal[WeightedAdjacencyMatrix[g]]
RoutingProbability[g_Graph,i_Integer]:=RoutingProbability[g][[i]]
RoutingProbability[g_Graph,i_Integer,j_Integer]:=RoutingProbability[g][[i]][[j]]


(* ::Subsection:: *)
(*Computed values*)


routingVariables[g_Graph]:=Select[Flatten[RoutingProbability[g]],!NumericQ[#]&]
visitVariables[g_Graph]:=Global`v[#]&/@VertexList[g]
routingFormulas[g_Graph]:=Total[#]==1&/@RoutingProbability[g]
routingValueFormulas[g_Graph]:=Table[0<r<=1,{r,routingVariables[g]}]
visitFormulas[g_Graph]:=Table[Global`v[i]==Total[RoutingProbability[g,#,i]*Global`v[#]&/@VertexList[g]],{i,VertexList[g]}]
visitValueFormulas[g_Graph]:=Table[v>0,{v,visitVariables[g]}]
visitCountFormulas[g_Graph]:=Join[{Global`v[1]==1},routingFormulas[g],visitFormulas[g],routingValueFormulas[g],visitValueFormulas[g]]
visitCountVariables[g_Graph]:=Join[routingVariables[g],visitVariables[g]]
visitCountSolutions[g_Graph]:=Quiet[Solve[visitCountFormulas[g],visitCountVariables[g],MaxExtraConditions->All]]
(*Cached visit count values to improve speed (Solve is a demanding calculation)*)
VisitCount[g_Graph]:=VisitCount[g]=Normal[visitVariables[g]/.First[visitCountSolutions[g]]]
VisitCount[g_Graph,i_Integer]:=VisitCount[g][[i]]


ServiceDemand[g_Graph]:=VisitCount[g]*ServiceTime[g]
ServiceDemand[g_Graph,i_Integer]:=VisitCount[g,i]*ServiceTime[g,i]


Throughput[g_Graph,0]=0
Throughput[g_Graph,k_Integer]:=k/Total[ExpectedResponseTimePerPassage[g,k]]


ExpectedNumberOfCustomers[g_Graph,k_Integer]:=Table[ExpectedNumberOfCustomers[g,k,i],{i,VertexList[g]}]
ExpectedNumberOfCustomers[g_Graph,0,i_Integer]=0
ExpectedNumberOfCustomers[g_Graph,k_Integer,i_Integer]:=Throughput[g,k]*ExpectedResponseTimePerPassage[g,k,i]


ExpectedResponseTime[g_Graph,k_Integer]:=Table[ExpectedResponseTime[g,k,i],{i,VertexList[g]}]
ExpectedResponseTime[g_Graph,0,i_Integer]=0
ExpectedResponseTime[g_Graph,k_Integer,i_Integer]:=If[Scheduling[g,i]===Global`IS,ServiceTime[g,i],(ExpectedNumberOfCustomers[g,k-1,i]+1)*ServiceTime[g,i]]


ExpectedResponseTimePerPassage[g_Graph,k_Integer]:=ExpectedResponseTime[g,k]*VisitCount[g]
ExpectedResponseTimePerPassage[g_Graph,k_Integer,i_Integer]:=ExpectedResponseTime[g,k,i]*VisitCount[g,i]


(* ::Subsection:: *)
(*Formulas*)


(* ::Subsubsection:: *)
(*General*)


StateSpace[m_Integer,k_Integer]:=Flatten[Permutations/@IntegerPartitions[k,{m},Range[0,k]],1]


(* ::Subsubsection:: *)
(*Two FCFS*)


ExpectedResponseTimePerPassageTwoFCFSFormula[g_Graph,k_Integer]:=Table[ExpectedResponseTimePerPassageTwoFCFSFormula[g,k,i],{i,VertexList[g]}]
ExpectedResponseTimePerPassageTwoFCFSFormula[g_Graph,k_Integer,main_Integer]:=Module[{other},
other=Mod[main+1,2,1];
ExpectedResponseTimePerPassageTwoFCFSFormula[ServiceDemand[g,main],ServiceDemand[g,other],k]]
ExpectedResponseTimePerPassageTwoFCFSFormula[d1_,d2_,k_Integer]:=(\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(i = 0\), \(k\)]\(\((k - i)\) 
\*SuperscriptBox[\(d1\), \(k - i\)] 
\*SuperscriptBox[\(d2\), \(i\)]\)\))/(\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(j = 0\), \(k - 1\)]\(
\*SuperscriptBox[\(d1\), \(k - 1 - j\)] 
\*SuperscriptBox[\(d2\), \(j\)]\)\))


ExpectedNumberOfCustomersTwoFCFSFormula[g_Graph,k_Integer]:=Table[ExpectedNumberOfCustomersTwoFCFSFormula[g,k,i],{i,VertexList[g]}]
ExpectedNumberOfCustomersTwoFCFSFormula[g_Graph,k_Integer,main_Integer]:=Module[{other},
other=Mod[main+1,2,1];
ExpectedNumberOfCustomersTwoFCFSFormula[ServiceDemand[g,main],ServiceDemand[g,other],k]]
ExpectedNumberOfCustomersTwoFCFSFormula[d1_,d2_,k_Integer]:=(\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(i = 0\), \(k\)]\(\((k - i)\) 
\*SuperscriptBox[\(d1\), \(k - i\)] 
\*SuperscriptBox[\(d2\), \(i\)]\)\))/(\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(j = 0\), \(k\)]\(
\*SuperscriptBox[\(d1\), \(k - j\)] 
\*SuperscriptBox[\(d2\), \(j\)]\)\))


(* ::Subsubsection:: *)
(*M FCFS*)


ExpectedResponseTimePerPassageFCFSFormula[g_Graph,k_Integer]:=ExpectedResponseTimePerPassageFCFSFormula[ServiceDemand[g],k]
ExpectedResponseTimePerPassageFCFSFormula[g_Graph,k_Integer,main_Integer]:=ExpectedResponseTimePerPassageFCFSFormula[ServiceDemand[g],k,main]
ExpectedResponseTimePerPassageFCFSFormula[d_List,k_Integer]:=Table[ExpectedResponseTimePerPassageFCFSFormula[d,k,i],{i,Length[d]}]
ExpectedResponseTimePerPassageFCFSFormula[d_List,k_Integer,main_Integer]:=Module[{m},
m=Length[d];
Sum[n[[main]]\!\(
\*UnderoverscriptBox[\(\[Product]\), \(i = 1\), \(m\)]
\*SuperscriptBox[\(d[\([i]\)]\), \(n[\([i]\)]\)]\),{n,StateSpace[m,k]}]/Sum[\!\(
\*UnderoverscriptBox[\(\[Product]\), \(i = 1\), \(m\)]
\*SuperscriptBox[\(d[\([i]\)]\), \(n[\([i]\)]\)]\),{n,StateSpace[m,k-1]}]]


ExpectedNumberOfCustomersFCFSFormula[g_Graph,k_Integer]:=ExpectedNumberOfCustomersFCFSFormula[ServiceDemand[g],k]
ExpectedNumberOfCustomersFCFSFormula[g_Graph,k_Integer,main_Integer]:=ExpectedNumberOfCustomersFCFSFormula[ServiceDemand[g],k,main]
ExpectedNumberOfCustomersFCFSFormula[d_List,k_Integer]:=Table[ExpectedNumberOfCustomersFCFSFormula[d,k,i],{i,Length[d]}]
ExpectedNumberOfCustomersFCFSFormula[d_List,k_Integer,main_Integer]:=Module[{m},
m=Length[d];
Sum[n[[main]]\!\(
\*UnderoverscriptBox[\(\[Product]\), \(i = 1\), \(m\)]
\*SuperscriptBox[\(d[\([i]\)]\), \(n[\([i]\)]\)]\),{n,StateSpace[m,k]}]/Sum[\!\(
\*UnderoverscriptBox[\(\[Product]\), \(i = 1\), \(m\)]
\*SuperscriptBox[\(d[\([i]\)]\), \(n[\([i]\)]\)]\),{n,StateSpace[m,k]}]]


(* ::Subsubsection:: *)
(*M FCFS N IS*)


ExpectedResponseTimePerPassageFCFSAndISFormula[g_Graph,k_Integer]:=ExpectedResponseTimePerPassageFCFSAndISFormula[ServiceDemand[g],Scheduling[g],k]
ExpectedResponseTimePerPassageFCFSAndISFormula[g_Graph,k_Integer,main_Integer]:=ExpectedResponseTimePerPassageFCFSAndISFormula[ServiceDemand[g],Scheduling[g],k,main]
ExpectedResponseTimePerPassageFCFSAndISFormula[d_List,s_List,k_Integer]:=Table[ExpectedResponseTimePerPassageFCFSAndISFormula[d,s,k,i],{i,Length[d]}]
ExpectedResponseTimePerPassageFCFSAndISFormula[d_List,scheduling_List,k_Integer,main_Integer]:=Module[{m,n},
m=Flatten[Position[scheduling,Global`FCFS,{1}],1];
n=Flatten[Position[scheduling,Global`IS,{1}],1];
Sum[
  (k-1)!*(s[[main]]+1)*d[[main]]*
  Product[d[[p]]^s[[p]],{p,m}]*
  Product[1/s[[q]]! d[[q]]^s[[q]],{q,n}],
  {s,StateSpace[Length[d],k-1]}]
/
Sum[
  (k-1)!*
  Product[d[[p]]^s[[p]],{p,m}]*
  Product[1/s[[q]]! d[[q]]^s[[q]],{q,n}],
  {s,StateSpace[Length[d],k-1]}]
]


ExpectedNumberOfCustomersFCFSAndISFormula[g_Graph,k_Integer]:=ExpectedNumberOfCustomersFCFSAndISFormula[ServiceDemand[g],Scheduling[g],k]
ExpectedNumberOfCustomersFCFSAndISFormula[g_Graph,k_Integer,main_Integer]:=ExpectedNumberOfCustomersFCFSAndISFormula[ServiceDemand[g],Scheduling[g],k,main]
ExpectedNumberOfCustomersFCFSAndISFormula[d_List,s_List,k_Integer]:=Table[ExpectedNumberOfCustomersFCFSAndISFormula[d,s,k,i],{i,Length[d]}]
ExpectedNumberOfCustomersFCFSAndISFormula[d_List,scheduling_List,k_Integer,main_Integer]:=Module[{m,n},
m=Flatten[Position[scheduling,Global`FCFS,{1}],1];
n=Flatten[Position[scheduling,Global`IS,{1}],1];
Sum[
  k!*s[[main]]*
  Product[d[[p]]^s[[p]],{p,m}]*
  Product[1/s[[q]]! d[[q]]^s[[q]],{q,n}],
  {s,StateSpace[Length[d],k]}]
/
Sum[
  k!*
  Product[d[[p]]^s[[p]],{p,m}]*
  Product[1/s[[q]]! d[[q]]^s[[q]],{q,n}],
  {s,StateSpace[Length[d],k]}]
]


End[]


EndPackage[]
