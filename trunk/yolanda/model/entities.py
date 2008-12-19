from elixir import *
from sqlalchemy import UniqueConstraint

class Video(Entity):
    using_options(tablename='videos')

    # Dublin Core terms
    dc_title = Field(Unicode(255))
    dc_alternative = Field(Unicode(255))
    dc_creator = ManyToOne('DC_Creator')
    dc_subject = ManyToMany('DC_Subject')

    dc_abstract = Field(UnicodeText)

    dc_contributor = ManyToMany('DC_Contributor')

    dc_created = Field(DateTime)
    dc_valid = Field(DateTime)
    dc_available = Field(DateTime)
    dc_issued = Field(DateTime)
    dc_modified = Field(DateTime)
    dc_dateAccepted = Field(DateTime)
    dc_dateCopyrighted = Field(DateTime)
    dc_dateSubmitted = Field(DateTime)

    dc_identifier = Field(Unicode(255)) # URI
    dc_source = Field(Unicode(255)) # URI
    dc_language = Field(Unicode(3)) # see ISO 639-3

    dc_extent = Field(Interval)

    dc_spatial = Field(Unicode(255))
    dc_temporal = Field(DateTime)

    dc_rightsHolder = Field(Unicode(255))

    # Creative Commons properties
    cc_commercial = Field(Boolean)
    cc_sharealike = Field(Boolean)
    cc_derivatives = Field(Boolean)

    # everything else
    sha256 = Field(String(64))

# Dublin Core terms

class DC_Creator(Entity):
    name = Field(Unicode(255), unique = True)
    videos = OneToMany('Video')

class DC_Subject(Entity):
    name = Field(Unicode(32), unique = True)
    videos = ManyToMany('Video')

class DC_Contributor(Entity):
    name = Field(Unicode(255), unique = True)
    videos = ManyToMany('Video')


