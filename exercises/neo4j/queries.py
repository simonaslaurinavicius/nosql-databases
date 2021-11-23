from service import Service

service = Service()


def execute_query(query, params={}):
    with service.neo4j.session(database=service.NEO4J_DATABASE) as session:
        result = session.run(query, **params)

        return result.data()


def match_all():
    return execute_query("MATCH(n) RETURN n")


def add_player():
    name = input("Please enter player name: ")
    query = "CREATE (p:Player {name: $name}) RETURN p"
    result = execute_query(query, {"name": name})

    for record in result:
        print("Player:", record["p"]["name"])


def get_player():
    name = input("Please enter player name: ")
    query = "MATCH (p:Player {name: $name}) RETURN p"

    result = execute_query(query, {"name": name})

    for record in result:
        print("Player:", record["p"]["name"])


def get_player_friends():
    name = input("Please enter player name: ")
    query = """
    MATCH (p:Player {name: $name})-[:IS_FRIENDS_WITH]-(players)
    RETURN players"""
    result = execute_query(query, {"name": name})

    for record in result:
        print("Friend:", record["players"]["name"])


def get_player_ability_points():
    name = input("Please enter player name: ")
    query = """
    MATCH (p:Player {name: $name}) RETURN p.ability_points as ap"""

    result = execute_query(query, {"name": name})
    print("Ability points:", result[0]["ap"])


def get_player_bought_abilities():
    name = input("Please enter player name: ")
    query = """
    MATCH (p:Player {name: $name})-[:BOUGHT]->(a:Ability)
    return p, a
    """
    result = execute_query(query, {"name": name})

    for record in result:
        print("Bought:", record["a"]["name"])


def get_player_unlocked_abilities():
    name = input("Please enter player name: ")
    query = """
        MATCH (p:Player {name: $name})-[:BOUGHT]->(a:Ability)
        MATCH (a:Ability)-[:UNLOCKS*]->(ua:Ability)
        return DISTINCT(ua)
    """
    result = execute_query(query, {"name": name})

    for record in result:
        print("Unlocked:", record["ua"]["name"])


def get_shortest_path_between_abilities():
    source = input("Please enter starting ability: ")
    target = input("Please enter ending ability: ")
    query = """
    MATCH (source:Ability {name: $source}), (target:Ability {name: $target})
    CALL gds.shortestPath.dijkstra.stream('skillGraph', {
        sourceNode: source,
        targetNode: target,
        relationshipWeightProperty: 'ability_points'
    })
    YIELD totalCost, path
    RETURN
        totalCost as cost,
        [node IN  nodes(path) | node.name] AS resulting_path
    """
    result = execute_query(query, {"source": source, "target": target})
    cost = result[0]["cost"]
    path = result[0]["resulting_path"]
    print("\nPath:")
    for record in path:
        print(record)
        if record != target:
            print("UNLOCKS")
    print("\nCost:", cost, "ability points")
