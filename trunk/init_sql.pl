require "include.pl";

#create or resume session
CGI::Session->name($config->{"page_cookie_name"});
my $session = new CGI::Session;

$dbh->do(qq{drop table config});

$dbh->do(qq{drop table users});

$dbh->do(qq{drop table videos});

$dbh->do(qq{drop table uploaded});

$dbh->do(qq{drop table tagcloud});

$dbh->do(qq{drop table comments});

$dbh->do(qq{create table
    tagcloud
    (
        text    varchar(255)    not null,
        count   int             not null
    )
}) or die $dbh->errstr;

$dbh->do(qq{insert into
    tagcloud values
    (
        'web tv', 68
    )
}) or die $dbh->errstr;

$dbh->do(qq{create table
    users
    (
        id          int auto_increment  not null,
        username    varchar(255)        not null,
        password    char(41)            not null,
        sid         char(32)            not null,
        timestamp   bigint              not null,
        locale      varchar(10)         not null,
        pagesize    tinyint unsigned    default 5,
        primary key    (id)
    )
}) or die $dbh->errstr;

$dbh->do(qq{insert into
    users
    (
        username,
        password
    )
    values
    (
        'test',
        password( 'test' )
    )
}) or die $dbh->errstr;

$dbh->do(qq{create table
    uploaded
    (
        id              int auto_increment  not null,
        title           varchar(255)        not null,
        description     text                not null,
        userid          int                 not null,
        timestamp       bigint              not null,
        creator         varchar(255)        not null,
        subject         varchar(255)        not null,
        source          varchar(255)        not null,
        language        varchar(255)        not null,
        coverage        varchar(255)        not null,
        rights          varchar(255)        not null,
        license         varchar(255)        not null,
        filesize        int                 default -1,
        duration        int                 default -1,
        width           smallint            default -1,
        height          smallint            default -1,
        fps             float               not null,
        hash            char(64)            not null,
        primary key     (id)
    )
}) or die $dbh->errstr;

$dbh->do(qq{create table
    videos
    (
        id              int auto_increment  not null,
        title           varchar(255)        not null,
        description     text                not null,
        userid          int                 not null,
        timestamp       bigint              not null,
        creator         varchar(255)        not null,
        subject         varchar(255)        not null,
        source          varchar(255)        not null,
        language        varchar(255)        not null,
        coverage        varchar(255)        not null,
        rights          varchar(255)        not null,
        license         varchar(255)        not null,
        filesize        int                 not null,
        duration        int                 not null,
        width           smallint            not null,
        height          smallint            not null,
        fps             float               not null,
        hash            char(64)            not null,
        viewcount       int                 default 0,
        downloadcount   int                 default 0,
        primary key     (id),
        fulltext        (title, description, subject)
    )
}) or die $dbh->errstr;

$dbh->do(qq{create table
    comments
    (
        id              int auto_increment  not null,
        userid          int                 not null,
        videoid         int                 not null,
        text            varchar(255)        not null,
        timestamp       bigint              not null,
        primary key     (id)
    )
}) or die $dbh->errstr;

print $session->header();
print "initiated database";
