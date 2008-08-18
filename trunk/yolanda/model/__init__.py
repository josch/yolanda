import elixir

# replace the elixir session with our own
Session = elixir.session(autoflush=True, transactional=True)

# use the elixir metadata
metadata = elixir.metadata

# import your entities, and set them up
from entities import *
elixir.setup_all()

