
import dimod
import itertools
from dwave.system import DWaveSampler, EmbeddingComposite




people = ['A', 'B', 'C']
roles = ['PM', 'SW', 'HW']
gamma = 1

# people_roles = {'A PM': 3, 'A SW': 2, 'A HW': 1,
#                 'B PM': 1, 'B SW': 3, 'B HW': 3,
#                 'C PM': 2, 'C SW': 1, 'C HW': 3}

people_roles = {'A PM': 3, 'A SW': 2, 'A HW': 1, 'A Des': 1, 'A Rep': 3,
                'B PM': 1, 'B SW': 3, 'B HW': 3,'B Des': 1, 'B Rep': 2,
                'C PM': 2, 'C SW': 1, 'C HW': 3, 'C Des': 2, 'C Rep': 2,
                'D PM': 3, 'D SW': 1, 'D HW': 1, 'D Des': 2, 'D Rep': 3,
                'E PM': 1, 'E SW': 1, 'E HW': 3, 'E Des': 1, 'E Rep': 3}

# change the linear biases
for x in people_roles.keys():
    people_roles[x] = (people_roles[x] - 2)*gamma

bqm = dimod.BinaryQuadraticModel.empty(dimod.BINARY)
bqm.linear = people_roles
bqm.offset = 5              # this helps us choose 5 people from the set



# Evaluate every potential edge in the graph
for i, j in itertools.combinations(range(len(people_roles)), 2):
    k = list(people_roles.keys())

    [person1, role1] = k[i].split()
    [person2, role2] = k[j].split()

    if person1 == person2 or role1 == role2:
        bqm.add_interaction(k[i], k[j], 4, dimod.BINARY)    # enforce strong pos quad bias if nodes have same person or role
    else:
        bqm.add_interaction(k[i], k[j], -1, dimod.BINARY)

# print(bqm)

sampler = EmbeddingComposite(DWaveSampler())
response = sampler.sample(bqm, chain_strength=8, num_reads=100)

# print('\n')
print(response)

# Print the variables chosen in the lowest energy sample
# sample = response.samples()[0]
# result = ''
for x in range(20):
    result = ''
    sample = response.samples()[x]

    for i in sample.keys():
        if sample[i] == 1:
            result = result + i + ', '

    result += ' cbf = ' + str(response.record['chain_break_fraction'][x])

    print(result)

# print(result)




