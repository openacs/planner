create table blocks_course_mode
(
        community_id            number(38)      not null,
        course_mode             varchar2(40)    not null,
        number_of_blocks        number(38),
        start_date              date,
        enabled_p               char(1)         not null,
        constraint bcm_pk primary key (community_id),
        constraint bcm_community_id_fk foreign key (community_id) references dotlrn_communities_all(community_id) on delete cascade
);

create table blocks_blocks
(
        community_id            number(38)      not null,
        block_id                number(38)      not null,
        block_name              varchar2(400),
        summary                 varchar2(4000),
        block_index             number(38)      not null,
        display_p               char(1)         not null,
        constraint bb_pk primary key (block_id),
        constraint bb_community_id_fk foreign key (community_id) references blocks_course_mode(community_id) on delete cascade
);

create table blocks_objects
(
        block_object_id         number(38)      not null,
        block_id                number(38)      not null,
        resource_type           varchar2(40)    not null,
        object_id               number(38),
        label                   varchar2(400),
        object_index            number(38)      not null,
        indent                  number(38),
        display_p               char(1)         not null,
        constraint bo_pk primary key (block_object_id),
        constraint bo_object_id_fk foreign key (object_id) references acs_objects(object_id) on delete cascade,
        constraint bo_block_id_fk foreign key (block_id) references blocks_blocks(block_id) on delete cascade
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
