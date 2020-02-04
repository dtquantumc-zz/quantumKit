import dimod
from dwave.system import EmbeddingComposite, DWaveSampler

import math
import networkx as nx
from bokeh.models.graphs import from_networkx
from bokeh.io import show, output_file
from bokeh.plotting import figure
from bokeh.models import GraphRenderer, StaticLayoutProvider, Oval, LabelSet, ColumnDataSource, Range1d, Label, Circle
from bokeh.models import MultiLine, Plot
from bokeh.palettes import Spectral8, d3
import matplotlib.pyplot as plt
# import matplotlib
import warnings

# housekeeping - matplot deprecation warning
warnings.filterwarnings("ignore", category=UserWarning)
# matplotlib.use('Agg')



'''
Draw the initial graph showing the nodes and color coded edges depending on the type of relationship
'''
def draw_initial_graph(graph, pos, node_list, labels):
    # nodes - all the same color
    nx.draw_networkx_nodes(graph, pos,
                           nodelist=node_list,
                           node_color='k',
                           node_size=500)

    # edges - blue = frustrated, red = agreement
    nx.draw_networkx_edges(graph, pos, width=1.0, alpha=0.5)
    nx.draw_networkx_edges(graph, pos,
                           edgelist=edges_agreement,
                           width=2, alpha=0.5, edge_color='r')
    nx.draw_networkx_edges(graph, pos,
                           edgelist=edges_frustrated,
                           width=2, alpha=0.5, edge_color='b')

    # labels
    nx.draw_networkx_labels(graph, pos, labels, font_color='w', font_size=16)

    output_file("problem.html")
    plt.title.text = "Initial Problem"
    plt.axis('off')
    plt.show()


def draw_solution(solution):
    nodes1 = []
    nodes2 = []
    edges1_strong = []
    edges1_frustrated = []
    edges2_strong = []
    edges2_frustrated = []
    edges_between_strong = []
    edges_between_frustrated = []

    # pos = nx.spring_layout(graph)
    positions = [(-1, 1), (-2, 0), (-1, -1), (1, -1), (2, 0), (1, 1)]
    pos1 = {}
    pos2 = {}

    # divide nodes into two sets
    for node in solution.keys():
        if solution[node] == 1:
            nodes1.append(node)
            pos1[node] = positions.pop(0)
        else:
            nodes2.append(node)
            pos2[node] = positions.pop(len(positions)-1)

    pos_all = dict(pos1)
    pos_all.update(pos2)

    # divide edges into four sets - strong relationships in the same set, frustrated relationships in the same set
    # and strong vs. frustrated relationships between sets
    for edge in list(relationships.keys()):
        # find edges in set 1
        if edge[0] in nodes1 and edge[1] in nodes1:
            if relationships[edge] == 1:
                edges1_frustrated.append(edge)
            else:
                edges1_strong.append(edge)

        # find edges in set 2
        elif edge[0] in nodes2 and edge[1] in nodes2:
            if relationships[edge] == 1:
                edges2_frustrated.append(edge)
            else:
                edges2_strong.append(edge)

        # find edges between sets
        else:
            if relationships[edge] == 1:
                edges_between_frustrated.append(edge)
            else:
                edges_between_strong.append(edge)

    # nodes - color coded depending on set
    nx.draw_networkx_nodes(graph, pos1,
                           nodelist=nodes1,
                           node_color='#021a96',    # blue
                           node_size=500)
    nx.draw_networkx_nodes(graph, pos2,
                           nodelist=nodes2,
                           node_color='#990909',    # red
                           node_size=500)

    # edges - blue = frustrated, red = agreement
    nx.draw_networkx_edges(graph, pos_all,
                           edgelist=edges1_strong,
                           width=3, alpha=1, edge_color='#f50a0a')    # red
    nx.draw_networkx_edges(graph, pos_all,
                           edgelist=edges1_frustrated,
                           width=3, alpha=1, edge_color='#0c33fa')    # blue
    nx.draw_networkx_edges(graph, pos_all,
                           edgelist=edges2_strong,
                           width=3, alpha=1, edge_color='#f50a0a')  # red
    nx.draw_networkx_edges(graph, pos_all,
                           edgelist=edges2_frustrated,
                           width=3, alpha=1, edge_color='#0c33fa')  # blue
    nx.draw_networkx_edges(graph, pos_all,
                           edgelist=edges_between_strong,
                           width=2, alpha=0.2, edge_color='#f50a0a')  # red
    nx.draw_networkx_edges(graph, pos_all,
                           edgelist=edges_between_frustrated,
                           width=2, alpha=0.2, edge_color='#0c33fa')  # blue

    # labels
    nx.draw_networkx_labels(graph, pos_all, labels, font_color='w', font_size=16)

    print(plt.get_fignums())

    # plt.figure()
    plt.axis('off')
    plt.show()

'''
Solve the problem on the QPU
'''
def solve_bqm(linear, quadratic):
    # Create the BQM using the linear and quadratic QUBO biases
    bqm = dimod.BinaryQuadraticModel(linear, quadratic, 0, dimod.BINARY)

    # Send the problem to the QPU
    sampler = EmbeddingComposite(DWaveSampler())
    response = sampler.sample(bqm, num_reads=10)

    # print("BINARY")
    print(response)
    # to print a column of sampleset: response.record.energy, response.record.num_occurrences

    return response.samples()

'''
    Start of the program
'''
# Problem information
linear_bias = {'L': 0, 'K': 0, 'R': 0, 'P': 0, 'A': 1, 'M': -1}     # A and M want to be on different teams
linear_no_bias = {'L': 0, 'K': 0, 'R': 0, 'P': 0, 'A': 0, 'M': 0}   # People don't care what teams they are on.

relationships = {('L', 'K'): 1, ('L', 'R'): 1, ('L', 'P'): -1, ('K', 'A'): 1, ('K', 'M'): -1, ('K', 'P'): -1,
                 ('R', 'A'): -1, ('R', 'M'): 1, ('P', 'M'): 1, ('P', 'A'): 1, ('A', 'M'): -1}   # -1 = they want to be on the same team


# Problem set up
graph = nx.Graph()
graph.add_nodes_from(linear_no_bias.keys())
graph.add_edges_from(relationships.keys())

node_list = list(linear_no_bias)

edges_frustrated = []
edges_agreement = []

labels = {}

for i in node_list:
    labels[i] = i

for i in relationships.keys():
    # Create list of colors for the edges
    if relationships[i] == 1:
        edges_frustrated.append(i)
    else:
        edges_agreement.append(i)


pos = nx.circular_layout(graph)  # positions for all nodes
draw_initial_graph(graph, pos, node_list, labels)

# samples = solve_bqm(linear_no_bias, relationships)
# draw_solution(samples[0])               #, "Solution to BQM with no linear biases"
#
samples = solve_bqm(linear_bias, relationships)
draw_solution(samples[0])             #, "Solution to BQM with linear biases"


