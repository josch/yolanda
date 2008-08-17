from elixir.entity import *
from elixir.fields import *
from sqlalchemy.types import *
from datetime import datetime

class Person(Entity):
    name = Field(Unicode(128))
    birthdate = Field(DateTime, default=datetime.now)
