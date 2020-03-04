CREATE SCHEMA dms_sample;
CREATE TABLE dms_sample.mlb_data (
    mlb_id double precision NOT NULL,
    mlb_name character varying(30),
    mlb_pos character varying(30),
    mlb_team character varying(30),
    mlb_team_long character varying(30),
    bats character varying(30),
    throws character varying(30),
    birth_year character varying(30),
    bp_id double precision,
    bref_id character varying(30),
    bref_name character varying(30),
    cbs_id character varying(30),
    cbs_name character varying(30),
    cbs_pos character varying(30),
    espn_id double precision,
    espn_name character varying(30),
    espn_pos character varying(30),
    fg_id character varying(30),
    fg_name character varying(30),
    lahman_id character varying(30),
    nfbc_id double precision,
    nfbc_name character varying(30),
    nfbc_pos character varying(30),
    retro_id character varying(30),
    retro_name character varying(30),
    debut character varying(30),
    yahoo_id double precision,
    yahoo_name character varying(30),
    yahoo_pos character varying(30),
    mlb_depth character varying(30)
);


ALTER TABLE dms_sample.mlb_data OWNER TO pgadmin;

--
-- Name: name_data; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.name_data (
    name_type character varying(15) NOT NULL,
    name character varying(45) NOT NULL
);


ALTER TABLE dms_sample.name_data OWNER TO pgadmin;

--
-- Name: nfl_data; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.nfl_data (
    "position" character varying(5) NOT NULL,
    player_number numeric(3,0),
    name character varying(40) NOT NULL,
    status character varying(10),
    stat1 character varying(10),
    stat1_val character varying(10),
    stat2 character varying(10),
    stat2_val character varying(10),
    stat3 character varying(10),
    stat3_val character varying(10),
    stat4 character varying(10),
    stat4_val character varying(10),
    team character varying(10) NOT NULL
);


ALTER TABLE dms_sample.nfl_data OWNER TO pgadmin;

--
-- Name: nfl_stadium_data; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.nfl_stadium_data (
    stadium character varying(60) NOT NULL,
    seating_capacity double precision,
    location character varying(40),
    surface character varying(80),
    roof character varying(30),
    team character varying(40) NOT NULL,
    opened character varying(10),
    sport_location_id double precision
);


ALTER TABLE dms_sample.nfl_stadium_data OWNER TO pgadmin;

--
-- Name: person; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.person (
    id double precision NOT NULL,
    full_name character varying(60) NOT NULL,
    last_name character varying(30),
    first_name character varying(30)
);


ALTER TABLE dms_sample.person OWNER TO pgadmin;

--
-- Name: player_seq; Type: SEQUENCE; Schema: dms_sample; Owner: pgadmin
--

CREATE SEQUENCE dms_sample.player_seq
    START WITH 1
    INCREMENT BY 10
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dms_sample.player_seq OWNER TO pgadmin;

--
-- Name: player; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.player (
    id double precision DEFAULT nextval('dms_sample.player_seq'::regclass) NOT NULL,
    sport_team_id double precision NOT NULL,
    last_name character varying(30),
    first_name character varying(30),
    full_name character varying(30)
);


ALTER TABLE dms_sample.player OWNER TO pgadmin;

--
-- Name: seat; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.seat (
    sport_location_id double precision NOT NULL,
    seat_level numeric(1,0) NOT NULL,
    seat_section character varying(15) NOT NULL,
    seat_row character varying(10) NOT NULL,
    seat character varying(10) NOT NULL,
    seat_type character varying(15)
);


ALTER TABLE dms_sample.seat OWNER TO pgadmin;

--
-- Name: seat_type; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.seat_type (
    name character varying(15) NOT NULL,
    description character varying(120),
    relative_quality numeric(2,0)
);


ALTER TABLE dms_sample.seat_type OWNER TO pgadmin;

--
-- Name: sport_division; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.sport_division (
    sport_type_name character varying(15) NOT NULL,
    sport_league_short_name character varying(10) NOT NULL,
    short_name character varying(10) NOT NULL,
    long_name character varying(60),
    description character varying(120)
);


ALTER TABLE dms_sample.sport_division OWNER TO pgadmin;

--
-- Name: sport_league; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.sport_league (
    sport_type_name character varying(15) NOT NULL,
    short_name character varying(10) NOT NULL,
    long_name character varying(60) NOT NULL,
    description character varying(120)
);


ALTER TABLE dms_sample.sport_league OWNER TO pgadmin;

--
-- Name: sport_location_seq; Type: SEQUENCE; Schema: dms_sample; Owner: pgadmin
--

CREATE SEQUENCE dms_sample.sport_location_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dms_sample.sport_location_seq OWNER TO pgadmin;

--
-- Name: sport_location; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.sport_location (
    id numeric(3,0) DEFAULT nextval('dms_sample.sport_location_seq'::regclass) NOT NULL,
    name character varying(60) NOT NULL,
    city character varying(60) NOT NULL,
    seating_capacity numeric(7,0),
    levels numeric(1,0),
    sections numeric(4,0)
);


ALTER TABLE dms_sample.sport_location OWNER TO pgadmin;

--
-- Name: sport_team_seq; Type: SEQUENCE; Schema: dms_sample; Owner: pgadmin
--

CREATE SEQUENCE dms_sample.sport_team_seq
    START WITH 1
    INCREMENT BY 10
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dms_sample.sport_team_seq OWNER TO pgadmin;

--
-- Name: sport_team; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.sport_team (
    id double precision DEFAULT nextval('dms_sample.sport_team_seq'::regclass) NOT NULL,
    name character varying(30) NOT NULL,
    abbreviated_name character varying(10),
    home_field_id numeric(3,0),
    sport_type_name character varying(15) NOT NULL,
    sport_league_short_name character varying(10) NOT NULL,
    sport_division_short_name character varying(10)
);


ALTER TABLE dms_sample.sport_team OWNER TO pgadmin;

--
-- Name: sport_type; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.sport_type (
    name character varying(15) NOT NULL,
    description character varying(120)
);


ALTER TABLE dms_sample.sport_type OWNER TO pgadmin;

--
-- Name: sporting_event_seq; Type: SEQUENCE; Schema: dms_sample; Owner: pgadmin
--

CREATE SEQUENCE dms_sample.sporting_event_seq
    START WITH 1
    INCREMENT BY 10
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dms_sample.sporting_event_seq OWNER TO pgadmin;

--
-- Name: sporting_event; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.sporting_event (
    id bigint DEFAULT nextval('dms_sample.sporting_event_seq'::regclass) NOT NULL,
    sport_type_name character varying(15) NOT NULL,
    home_team_id integer NOT NULL,
    away_team_id integer NOT NULL,
    location_id smallint NOT NULL,
    start_date_time timestamp without time zone NOT NULL,
    start_date date NOT NULL,
    sold_out smallint DEFAULT 0 NOT NULL,
    CONSTRAINT chk_sold_out CHECK ((sold_out = ANY (ARRAY[0, 1])))
);


ALTER TABLE dms_sample.sporting_event OWNER TO pgadmin;

--
-- Name: sporting_event_info; Type: VIEW; Schema: dms_sample; Owner: pgadmin
--

CREATE VIEW dms_sample.sporting_event_info AS
 SELECT e.id AS event_id,
    e.sport_type_name AS sport,
    e.start_date_time AS event_date_time,
    h.name AS home_team,
    a.name AS away_team,
    l.name AS location,
    l.city
   FROM dms_sample.sporting_event e,
    dms_sample.sport_team h,
    dms_sample.sport_team a,
    dms_sample.sport_location l
  WHERE (((e.home_team_id)::double precision = h.id) AND ((e.away_team_id)::double precision = a.id) AND ((e.location_id)::numeric = l.id));


ALTER TABLE dms_sample.sporting_event_info OWNER TO pgadmin;

--
-- Name: sporting_event_ticket_seq; Type: SEQUENCE; Schema: dms_sample; Owner: pgadmin
--

CREATE SEQUENCE dms_sample.sporting_event_ticket_seq
    START WITH 1
    INCREMENT BY 10
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dms_sample.sporting_event_ticket_seq OWNER TO pgadmin;

--
-- Name: sporting_event_ticket; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.sporting_event_ticket (
    id double precision DEFAULT nextval('dms_sample.sporting_event_ticket_seq'::regclass) NOT NULL,
    sporting_event_id double precision NOT NULL,
    sport_location_id double precision NOT NULL,
    seat_level numeric(1,0) NOT NULL,
    seat_section character varying(15) NOT NULL,
    seat_row character varying(10) NOT NULL,
    seat character varying(10) NOT NULL,
    ticketholder_id double precision,
    ticket_price numeric(8,2) NOT NULL
);


ALTER TABLE dms_sample.sporting_event_ticket OWNER TO pgadmin;

--
-- Name: sporting_event_ticket_info; Type: VIEW; Schema: dms_sample; Owner: pgadmin
--

CREATE VIEW dms_sample.sporting_event_ticket_info AS
 SELECT t.id AS ticket_id,
    e.event_id,
    e.sport,
    e.event_date_time,
    e.home_team,
    e.away_team,
    e.location,
    e.city,
    t.seat_level,
    t.seat_section,
    t.seat_row,
    t.seat,
    t.ticket_price,
    p.full_name AS ticketholder
   FROM dms_sample.sporting_event_info e,
    dms_sample.sporting_event_ticket t,
    dms_sample.person p
  WHERE ((t.sporting_event_id = (e.event_id)::double precision) AND (t.ticketholder_id = p.id));


ALTER TABLE dms_sample.sporting_event_ticket_info OWNER TO pgadmin;

--
-- Name: ticket_purchase_hist; Type: TABLE; Schema: dms_sample; Owner: pgadmin
--

CREATE TABLE dms_sample.ticket_purchase_hist (
    sporting_event_ticket_id double precision NOT NULL,
    purchased_by_id double precision NOT NULL,
    transaction_date_time timestamp(0) without time zone NOT NULL,
    transferred_from_id double precision,
    purchase_price numeric(8,2) NOT NULL
);