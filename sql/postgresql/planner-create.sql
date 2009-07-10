create table blocks_course_mode
(
        community_id            integer      not null PRIMARY KEY references dotlrn_communities_all(community_id) on delete cascade,
        course_mode             varchar(40)    not null,
        number_of_blocks        integer,
        start_date              date,
        enabled_p               char(1)         not null
);

create table blocks_blocks
(
        community_id            integer      not null references blocks_course_mode(community_id) on delete cascade,
        block_id                integer      not null PRIMARY KEY,
        block_name              varchar(400),
        summary                 varchar(4000),
        block_index             integer      not null,
        display_p               char(1)         not null
);

create table blocks_objects
(
        block_object_id         integer      not null PRIMARY KEY,
        block_id                integer      not null references blocks_blocks(block_id) on delete cascade,
        resource_type           varchar(40)    not null,
        object_id               integer references acs_objects(object_id) on delete cascade,
        label                   varchar(400),
        object_index            integer      not null,
        indent                  integer,
        display_p               char(1)         not null
);

CREATE SEQUENCE blocks_seq
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE SEQUENCE blocks_objects_seq
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1
    CACHE 20;
