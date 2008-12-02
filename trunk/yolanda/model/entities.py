from elixir import *

class Video(Entity):
    using_options(tablename='videos')

    # Important: Keep this in sync with upload.py !

    # Dublin Core terms
    dc_title = Field(Unicode(255))
    dc_creator = Field(Unicode(255))
    dc_subject = Field(UnicodeText)

    dc_abstract = Field(UnicodeText)

    dc_contributor = Field(Unicode(255))

    dc_created = Field(DateTime)
    dc_valid = Field(DateTime)
    dc_available = Field(DateTime)
    dc_issued = Field(DateTime)
    dc_modified = Field(DateTime)
    dc_dateAccepted = Field(DateTime)
    dc_dateCopyrighted = Field(DateTime)
    dc_dateSubmitted = Field(DateTime)

    dc_identifier = Field(Unicode(255))
    dc_source = Field(Unicode(255))
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
