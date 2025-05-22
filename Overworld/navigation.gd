extends Node

var current_connections_list := []  # a list of all the areas that currently need to be displayed, their position already globalized by the maps themselves

# currently, loading all the connections works fine BUT
# I need to unload only the maps that currently don't connect
# maybe this navigation manager should do it at runtime?
# the unloading is the thing that doesn't work here
