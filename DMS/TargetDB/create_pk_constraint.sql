 -- Sample script to create primary key constraints in target PostgreSQL datatabase

ALTER TABLE ONLY dms_sample.mlb_data
    ADD CONSTRAINT mlb_data_pkey PRIMARY KEY (mlb_id);
ALTER TABLE ONLY dms_sample.name_data
    ADD CONSTRAINT name_data_pk PRIMARY KEY (name_type, name);
ALTER TABLE ONLY dms_sample.nfl_data
    ADD CONSTRAINT nfl_data_pkey PRIMARY KEY ("position", name, team);
ALTER TABLE ONLY dms_sample.nfl_stadium_data
    ADD CONSTRAINT nfl_stadium_data_pkey PRIMARY KEY (stadium, team);
ALTER TABLE ONLY dms_sample.person
    ADD CONSTRAINT person_pk PRIMARY KEY (id);
ALTER TABLE ONLY dms_sample.player
    ADD CONSTRAINT player_pk PRIMARY KEY (id);
ALTER TABLE ONLY dms_sample.seat_type
    ADD CONSTRAINT st_seat_type_pk PRIMARY KEY (name);
ALTER TABLE ONLY dms_sample.sport_division
    ADD CONSTRAINT sport_division_pk PRIMARY KEY (sport_type_name, sport_league_short_name, short_name);
ALTER TABLE ONLY dms_sample.sport_league
    ADD CONSTRAINT sport_league_pk PRIMARY KEY (short_name);
ALTER TABLE ONLY dms_sample.sport_location
    ADD CONSTRAINT sport_location_pk PRIMARY KEY (id);
ALTER TABLE ONLY dms_sample.sport_team
    ADD CONSTRAINT sport_team_pk PRIMARY KEY (id);
ALTER TABLE ONLY dms_sample.sport_type
    ADD CONSTRAINT sport_type_pk PRIMARY KEY (name);
ALTER TABLE ONLY dms_sample.sporting_event
    ADD CONSTRAINT sporting_event_pk PRIMARY KEY (id);
ALTER TABLE ONLY dms_sample.sporting_event_ticket
    ADD CONSTRAINT sporting_event_ticket_pk PRIMARY KEY (id);
ALTER TABLE ONLY dms_sample.ticket_purchase_hist
    ADD CONSTRAINT ticket_purchase_hist_pk PRIMARY KEY (sporting_event_ticket_id, purchased_by_id, transaction_date_time);
