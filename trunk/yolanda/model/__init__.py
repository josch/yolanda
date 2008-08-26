import elixir

# replace the elixir session with our own
session = elixir.session

# use the elixir metadata
metadata = elixir.metadata

# import your entities, and set them up
from entities import *
elixir.setup_all()

