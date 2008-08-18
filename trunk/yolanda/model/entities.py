from elixir import *

class Video(Entity):
    using_options(tablename='videos')

    title = Field(Unicode(255))
