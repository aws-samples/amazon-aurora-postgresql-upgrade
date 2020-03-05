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
