from neo4j import GraphDatabase


class Service:
    NEO4J_HOST = "bolt://localhost:7687"
    NEO4J_USERNAME = "neo4j"
    NEO4J_PASSWORD = "admin"
    NEO4J_DATABASE = "players"

    def __init__(self):
        self.neo4j = GraphDatabase.driver(
            self.NEO4J_HOST, auth=(self.NEO4J_USERNAME, self.NEO4J_PASSWORD)
        )

    def _get_neo4j(self):
        return self.neo4j

    neo4 = property(_get_neo4j)
