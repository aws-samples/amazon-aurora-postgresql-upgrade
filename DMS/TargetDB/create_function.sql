-- Sample script to create functions in target PostgreSQL database
CREATE FUNCTION dms_sample.edate_add(expr1 timestamp with time zone, expr2 text, unit anyelement) RETURNS anyelement
    LANGUAGE plpgsql
    AS $$
BEGIN
  CASE upper(unit)
      WHEN 'MICROSECOND' THEN return expr1::timestamptz + concat(expr2,' microseconds')::interval;
      WHEN 'SECOND' THEN return expr1::timestamp + concat(expr2,' second')::interval;
      WHEN 'MINUTE' THEN return expr1::timestamp + concat(expr2,' minute')::interval;
      WHEN 'HOUR' THEN return expr1::timestamp + concat(expr2,' hour')::interval;
      WHEN 'DAY' THEN return expr1::timestamp + concat(expr2,' day')::interval;
      WHEN 'MONTH' THEN return expr1::timestamp + concat(expr2,' month')::interval;
      WHEN 'QUARTER' THEN return expr1::timestamp + concat(expr2,' quarter')::interval;
      WHEN 'YEAR' THEN return expr1::timestamp + concat(expr2,' year')::interval;
      WHEN 'SECOND_MICROSECOND' THEN return expr1::timestamptz + concat(expr2,' microseconds')::interval;
      WHEN 'MINUTE_MICROSECOND' THEN return expr1::timestamptz + concat(expr2,' microseconds')::interval;
      WHEN 'MINUTE_SECOND' THEN return expr1::timestamp + concat(expr2,' second')::interval;
      WHEN 'HOUR_MICROSECOND' THEN return expr1::timestamp + concat(expr2,' microseconds')::interval;
      WHEN 'HOUR_SECOND' THEN return expr1::timestamp + concat(expr2,' second')::interval;
      WHEN 'HOUR_MINUTE' THEN return expr1::timestamp + concat(expr2,' minute')::interval;
      WHEN 'DAY_MICROSECOND' THEN return expr1::timestamp + concat(expr2,' microseconds')::interval;
      WHEN 'DAY_SECOND' THEN return expr1::timestamp + concat(expr2,' second')::interval;
      WHEN 'DAY_MINUTE' THEN return expr1::timestamp + concat(expr2,' minute')::interval;
      WHEN 'DAY_HOUR' THEN return expr1::timestamp + concat(expr2,' hour')::interval;
      WHEN 'YEAR_MONTH' THEN return expr1::timestamp + concat(expr2,' month')::interval;
      WHEN 'WEEK' THEN return expr1::timestamp + concat(expr2,' week')::interval;
      ELSE RAISE EXCEPTION 'Incorrect value for parameter "unit"!';
  END CASE;
END;
$$;

ALTER FUNCTION dms_sample.edate_add(expr1 timestamp with time zone, expr2 text, unit anyelement) OWNER TO pgadmin;
CREATE FUNCTION dms_sample.edate_format(expr timestamp with time zone, format text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE res text;
DECLARE pos integer;
BEGIN
/*
Version: 2
Developer: Pogorelov
Created: 20160215
Last Updated: 20160309
*/
	SELECT position('%U' in format) INTO pos;
    IF pos <> 0 THEN
     RAISE EXCEPTION 'Format parameter % is not supported!', '''%U''';
    END if;
	SELECT position('%u' in format) INTO pos;
    IF pos <> 0 THEN
     RAISE EXCEPTION 'Format parameter % is not supported!', '''%u''';
    END if;
	SELECT position('%V' in format) INTO pos;
    IF pos <> 0 THEN
     RAISE EXCEPTION 'Format parameter % is not supported!', '''%V''';
    END if;
	SELECT position('%X' in format) INTO pos;
    IF pos <> 0 THEN
     RAISE EXCEPTION 'Format parameter % is not supported!', '''%X''';
    END if;
/*
%U	Week (00..53), where Sunday is the first day of the week; WEEK() mode 0
%u	Week (00..53), where Monday is the first day of the week; WEEK() mode 1
%V	Week (01..53), where Sunday is the first day of the week; WEEK() mode 2; used with %X
%X	Year for the week where Sunday is the first day of the week, numeric, four digits; used with %V
*/
    CASE date_part('DAY', expr::date)
      WHEN 1,21,31 THEN format := replace(format, '%D', 'FMDD"st"');
      WHEN 2,22 THEN format := replace(format, '%D', 'FMDD"nd"');
      WHEN 3,23 THEN format := replace(format, '%D', 'FMDD"rd"');
      ELSE format := replace(format, '%D', 'FMDD"th"');
    END CASE;
	format := replace(format, '%a', 'DY');
	format := replace(format, '%b', 'MON');
	format := replace(format, '%c', 'FMMM');
	format := replace(format, '%d', 'DD');
	format := replace(format, '%e', 'FMDD');
	format := replace(format, '%f', 'US');
	format := replace(format, '%H', 'HH24');
	format := replace(format, '%h', 'HH');
	format := replace(format, '%j', 'DDD');
	format := replace(format, '%I', 'HH');
	format := replace(format, '%i', 'MI');
	format := replace(format, '%k', 'FMHH24');
	format := replace(format, '%l', 'FMHH');
	format := replace(format, '%M', 'MONTH');
	format := replace(format, '%m', 'MM');
	format := replace(format, '%p', 'AM');
	format := replace(format, '%r', 'HH:MI:SS AM');
	format := replace(format, '%S', 'SS');
	format := replace(format, '%s', 'SS');
	format := replace(format, '%T', 'HH24:MI:SS');
	format := replace(format, '%v', 'IW');
	format := replace(format, '%W', 'Day');
	format := replace(format, '%w', 'D');
	format := replace(format, '%x', 'IYYY');
	format := replace(format, '%Y', 'YYYY');
	format := replace(format, '%y', 'YY');
	BEGIN
		res := TO_CHAR(expr, format);
    EXCEPTION
    WHEN OTHERS THEN
    	res := null;
	END;
    return res;
END;
$$;

ALTER FUNCTION dms_sample.edate_format(expr timestamp with time zone, format text) OWNER TO pgadmin;
CREATE FUNCTION dms_sample.estr_to_date(str text, format text) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
	res date;
BEGIN
	format := replace(format, '%Y', 'YYYY');
	format := replace(format, '%y', 'YY');
	format := replace(format, '%b', 'MON');
	format := replace(format, '%M', 'MONTH');
	format := replace(format, '%m', 'MM');
	format := replace(format, '%a', 'DY');
	format := replace(format, '%d', 'DD');
	format := replace(format, '%H', 'HH24');
	format := replace(format, '%h', 'HH');
	format := replace(format, '%i', 'MI');
	format := replace(format, '%s', 'SS');
	BEGIN
		res := TO_DATE(str, format);
    EXCEPTION
    WHEN OTHERS THEN
    	res := null;
	END;
    return res;
END;
$$;

ALTER FUNCTION dms_sample.estr_to_date(str text, format text) OWNER TO pgadmin;
CREATE FUNCTION dms_sample.esubstr(str character varying, pos integer, cnt integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
declare
	len int;
begin
	if str is null or pos is null or cnt is null then
		return null;
	elsif cnt <= 0 or pos = 0 then
		return '';
	elsif pos > 0 then
		return substr(str, pos, cnt);
	elsif pos < 0 then
		len := length(str);
		return substr(str, len+pos+1, cnt);
	end if;
end;
$$;

ALTER FUNCTION dms_sample.esubstr(str character varying, pos integer, cnt integer) OWNER TO pgadmin;
CREATE FUNCTION dms_sample.generatemlbseason() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_v_date_offset INTEGER DEFAULT 0;
    var_v_t1_id INTEGER;
    var_v_t1_home_id INTEGER;
    var_v_event_date TIMESTAMP WITHOUT TIME ZONE;
    var_v_day_increment INTEGER;
    var_t1_done varchar(10) DEFAULT FALSE;
    team1 CURSOR FOR
    SELECT
        id, home_field_id
        FROM dms_sample.sport_team
        WHERE LOWER(sport_league_short_name) = LOWER('MLB'::VARCHAR(10)) AND LOWER(sport_type_name) = LOWER('baseball'::VARCHAR(15))
        ORDER BY id NULLS FIRST;
    var_v_t2_id INTEGER;
    var_v_t2_home_id INTEGER;
    var_t2_done varchar(10) DEFAULT FALSE;
    team2 CURSOR FOR
    SELECT
        id, home_field_id
        FROM dms_sample.sport_team
        WHERE id > var_v_t1_id::INTEGER AND LOWER(sport_league_short_name) = LOWER('MLB'::VARCHAR(10)) AND LOWER(sport_type_name) = LOWER('baseball'::VARCHAR(15))
        ORDER BY id NULLS FIRST;
    var_v_t3_id INTEGER;
    var_v_t3_home_id INTEGER;
    var_t3_done varchar(10) DEFAULT FALSE;
    team3 CURSOR FOR
    SELECT
        id, home_field_id
        FROM dms_sample.sport_team
        WHERE id < var_v_t1_id::INTEGER AND LOWER(sport_league_short_name) = LOWER('MLB'::VARCHAR(10)) AND LOWER(sport_type_name) = LOWER('baseball'::VARCHAR(15))
        ORDER BY id NULLS FIRST;
BEGIN
    OPEN team1;
    <<team1_loop>>
    LOOP
        FETCH FROM team1 INTO var_v_t1_id, var_v_t1_home_id;
        IF NOT FOUND THEN
            CLOSE team1;
            EXIT team1_loop;
        END IF;
        var_v_day_increment := (7::NUMERIC - date_part('DOW', dms_sample.estr_to_date(CONCAT('31,3,', dms_sample.edate_format(clock_timestamp()::TIMESTAMP::TIMESTAMPTZ, '%Y'))::TEXT, '%d,%m,%Y')::DATE))::INTEGER;
        var_v_event_date := dms_sample.edate_add(dms_sample.estr_to_date(CONCAT('31,3,', dms_sample.edate_format(clock_timestamp()::TIMESTAMP::TIMESTAMPTZ, '%Y'))::TEXT, '%d,%m,%Y')::TIMESTAMP, (var_v_day_increment::NUMERIC + 7::NUMERIC * var_v_date_offset::NUMERIC)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
        <<block2>>
        BEGIN
            OPEN team2;
            <<team2_loop>>
            LOOP
                FETCH FROM team2 INTO var_v_t2_id, var_v_t2_home_id;
                IF NOT FOUND THEN
                    CLOSE team2;
                    EXIT team2_loop;
                END IF;
                INSERT INTO dms_sample.sporting_event (sport_type_name, home_team_id, away_team_id, location_id, start_date_time, start_date)
                VALUES ('baseball', var_v_t1_id, var_v_t2_id, var_v_t1_home_id, var_v_event_date, dms_sample.edate_add(var_v_event_date::TIMESTAMP, 
                (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT)::TIMESTAMP WITHOUT TIME ZONE);
                
                var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
            END LOOP;
        END BLOCK2;
        <<block3>>
        BEGIN
            OPEN team3;
            <<team3_loop>>
            LOOP
                FETCH FROM team3 INTO var_v_t3_id, var_v_t3_home_id;
                IF NOT FOUND THEN
                    CLOSE team3;
                    EXIT team3_loop;
                END IF;
                var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
                INSERT INTO dms_sample.sporting_event (sport_type_name, home_team_id, away_team_id, location_id, start_date_time, start_date)
                VALUES ('baseball', var_v_t1_id, var_v_t3_id, var_v_t1_home_id, var_v_event_date, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT)::TIMESTAMP WITHOUT TIME ZONE);
            END LOOP;
        END BLOCK3;
    END LOOP;
END;
$$;

ALTER FUNCTION dms_sample.generatemlbseason() OWNER TO pgadmin;
CREATE FUNCTION dms_sample.generatenflseason() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_v_date_offset INTEGER DEFAULT 0;
    var_v_event_date TIMESTAMP WITHOUT TIME ZONE;
    var_v_sport_division_short_name VARCHAR(10);
    var_v_day_increment INTEGER;
    var_div_done VARCHAR(10) DEFAULT FALSE;
    div_cur CURSOR FOR
    SELECT DISTINCT
        sport_division_short_name
        FROM dms_sample.sport_team
        WHERE LOWER(sport_type_name) = LOWER('football'::VARCHAR(15)) AND LOWER(sport_league_short_name) = LOWER('NFL'::VARCHAR(10));
    var_v_team1_id INTEGER;
    var_v_team1_home_field_id INTEGER;
    var_team1_done VARCHAR(10) DEFAULT FALSE;
    team1 CURSOR FOR
    SELECT
        id, home_field_id
        FROM dms_sample.sport_team
        WHERE LOWER(sport_division_short_name) = LOWER(var_v_sport_division_short_name) AND LOWER(sport_type_name) = LOWER('football'::VARCHAR(15)) AND LOWER(sport_league_short_name) = LOWER('NFL'::VARCHAR(10))
        ORDER BY id NULLS FIRST;
    var_v_team2_id INTEGER;
    var_v_team2_home_field_id INTEGER;
    var_team2_done VARCHAR(10) DEFAULT FALSE;
    team2 CURSOR FOR
    SELECT
        id, home_field_id
        FROM dms_sample.sport_team
        WHERE id > var_v_team1_id::INTEGER AND LOWER(sport_division_short_name) = LOWER(var_v_sport_division_short_name) AND LOWER(sport_type_name) = LOWER('football'::VARCHAR(15)) AND LOWER(sport_league_short_name) = LOWER('NFL'::VARCHAR(10))
        ORDER BY id NULLS FIRST;
    var_v_team3_id INTEGER;
    var_v_team3_home_field_id INTEGER;
    var_team3_done VARCHAR(10) DEFAULT FALSE;
    team3 CURSOR FOR
    SELECT
        id, home_field_id
        FROM dms_sample.sport_team
        WHERE id < var_v_team1_id::INTEGER AND LOWER(sport_division_short_name) = LOWER(var_v_sport_division_short_name) AND LOWER(sport_type_name) = LOWER('football'::VARCHAR(15)) AND LOWER(sport_league_short_name) = LOWER('NFL'::VARCHAR(10))
        ORDER BY id NULLS FIRST;
    var_i INTEGER DEFAULT 1;
    var_v_nfc_conf VARCHAR(10);
    var_v_afc_conf VARCHAR(10);
    var_v_rownum INTEGER DEFAULT 1;
    var_v_t2_id INTEGER;
    var_v_t2_field_id INTEGER;
    var_v_t1_id INTEGER;
    var_v_t1_field_id INTEGER;
    var_v_dt TIMESTAMP WITHOUT TIME ZONE;
    var_cross_div_done VARCHAR(10) DEFAULT FALSE;
    cross_div_cur CURSOR FOR
    SELECT
        a.id AS t2_id, a.home_field_id AS t2_field_id, b.id AS t1_id, b.home_field_id AS t1_field_id
        FROM dms_sample.sport_team AS a, dms_sample.sport_team AS b
        WHERE LOWER(a.sport_division_short_name) = LOWER(var_v_afc_conf) AND LOWER(b.sport_division_short_name) = LOWER(var_v_nfc_conf)
        ORDER BY LOWER(a.name) NULLS FIRST, LOWER(b.name) NULLS FIRST;
  
BEGIN
    OPEN div_cur;
    <<div_loop>>
    LOOP
        FETCH FROM div_cur INTO var_v_sport_division_short_name;
        IF NOT FOUND THEN
            CLOSE div_cur;
            EXIT div_loop;
        END IF;
        var_v_date_offset := 0::INTEGER;
        <<block1>>
        BEGIN
            OPEN team1;
            <<team1_loop>>
            LOOP
                FETCH FROM team1 INTO var_v_team1_id, var_v_team1_home_field_id;
                IF NOT FOUND THEN
                    CLOSE team1;
                    EXIT team1_loop;
                END IF;
                var_v_day_increment := (1::NUMERIC - date_part('DOW', dms_sample.estr_to_date(CONCAT('01,9,', dms_sample.edate_format(clock_timestamp()::TIMESTAMP::TIMESTAMPTZ, '%Y'))::TEXT, '%d,%m,%Y')::DATE))::INTEGER;
                var_v_event_date := dms_sample.edate_add(dms_sample.estr_to_date(CONCAT('01,9,', dms_sample.edate_format(clock_timestamp()::TIMESTAMP::TIMESTAMPTZ, '%Y'))::TEXT, '%d,%m,%Y')::TIMESTAMP, (var_v_day_increment::NUMERIC + 7::NUMERIC * var_v_date_offset::NUMERIC)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
                <<block2>>
                BEGIN
                    OPEN team2;
                    <<team2_loop>>
                    LOOP
                        FETCH FROM team2 INTO var_v_team2_id, var_v_team2_home_field_id;
                        IF NOT FOUND THEN
                            CLOSE team2;
                            EXIT team2_loop;
                        END IF;
                        INSERT INTO dms_sample.sporting_event (sport_type_name, home_team_id, away_team_id, location_id, start_date_time, start_date)
                        VALUES ('football', var_v_team1_id, var_v_team2_id, var_v_team1_home_field_id, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT)::TIMESTAMP WITHOUT TIME ZONE, var_v_event_date);
                        var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
                    END LOOP;
                END BLOCK2;
                <<block3>>
                BEGIN
                    OPEN team3;
                    <<team3_loop>>
                    LOOP
                        FETCH FROM team3 INTO var_v_team3_id, var_v_team3_home_field_id;
                        IF NOT FOUND THEN
                            CLOSE team3;
                            EXIT team3_loop;
                        END IF;
                        INSERT INTO dms_sample.sporting_event (sport_type_name, home_team_id, away_team_id, location_id, start_date_time, start_date)
                        VALUES ('football', var_v_team1_id, var_v_team3_id, var_v_team1_home_field_id, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT)::TIMESTAMP WITHOUT TIME ZONE, var_v_event_date);
                        var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
                    END LOOP;
                END BLOCK3;
                var_v_date_offset := (var_v_date_offset::NUMERIC + 1::NUMERIC)::INTEGER;
            END LOOP;
        END BLOCK1;
    END LOOP;
    DROP TABLE IF EXISTS v_date_tab;
    CREATE TEMPORARY TABLE v_date_tab
    (id INTEGER PRIMARY KEY,
        dt VARCHAR(100));
    var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
    INSERT INTO v_date_tab
    VALUES (1, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    INSERT INTO v_date_tab
    VALUES (6, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    INSERT INTO v_date_tab
    VALUES (11, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    INSERT INTO v_date_tab
    VALUES (16, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
    INSERT INTO v_date_tab
    VALUES (2, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    INSERT INTO v_date_tab
    VALUES (7, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    INSERT INTO v_date_tab
    VALUES (12, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    INSERT INTO v_date_tab
    VALUES (13, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
    INSERT INTO v_date_tab
    VALUES (3, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    INSERT INTO v_date_tab
    VALUES (8, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    INSERT INTO v_date_tab
    VALUES (9, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    INSERT INTO v_date_tab
    VALUES (14, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
    INSERT INTO v_date_tab
    VALUES (4, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    INSERT INTO v_date_tab
    VALUES (5, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    INSERT INTO v_date_tab
    VALUES (10, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    INSERT INTO v_date_tab
    VALUES (15, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
    DROP TABLE IF EXISTS v_nfc_tab;
    CREATE TEMPORARY TABLE v_nfc_tab
    (id INTEGER,
        conf VARCHAR(10));
    INSERT INTO v_nfc_tab
    VALUES (1, 'NFC North'),
    (2, 'NFC East'),
    (3, 'NFC South'),
    (4, 'NFC West');
    DROP TABLE IF EXISTS v_afc_tab;
    CREATE TEMPORARY TABLE v_afc_tab
    (id INTEGER,
        conf VARCHAR(10));
    INSERT INTO v_afc_tab
    VALUES (1, 'AFC North'),
    (2, 'AFC East'),
    (3, 'AFC South'),
    (4, 'AFC West');
    <<cross_conf_block>>
    BEGIN
        WHILE var_i <= 4::INTEGER LOOP
            SELECT
                conf
                INTO var_v_nfc_conf
                FROM v_nfc_tab
                WHERE id = var_i;
            SELECT
                conf
                INTO var_v_afc_conf
                FROM v_afc_tab
                WHERE id = 1::INTEGER;
            <<cc_block1>>
            BEGIN
                OPEN cross_div_cur;
                <<cross_div_cur_loop>>
                LOOP
                    FETCH FROM cross_div_cur INTO var_v_t2_id, var_v_t2_field_id, var_v_t1_id, var_v_t1_field_id;
                    IF NOT FOUND THEN
                        CLOSE cross_div_cur;
                        EXIT cross_div_cur_loop;
                    END IF;
                    SELECT
                        dt
                        INTO var_v_dt
                        FROM v_date_tab
                        WHERE id = var_v_rownum;
                    IF (var_v_rownum::NUMERIC % 2::NUMERIC) = 0 THEN
                        INSERT INTO dms_sample.sporting_event (sport_type_name, home_team_id, away_team_id, location_id, start_date_time, start_date)
                        VALUES ('football', var_v_t2_id, var_v_t1_id, var_v_t2_field_id, var_v_dt, var_v_dt);
                    ELSE
                        INSERT INTO dms_sample.sporting_event (sport_type_name, home_team_id, away_team_id, location_id, start_date_time, start_date)
                        VALUES ('football', var_v_t1_id, var_v_t2_id, var_v_t1_field_id, var_v_dt, var_v_dt);
                    END IF;
                END LOOP;
            END CC_BLOCK1;
            var_i := (var_i::NUMERIC + 1::NUMERIC)::INTEGER;
        END LOOP;
        DELETE FROM v_date_tab;
        var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
        INSERT INTO v_date_tab
        VALUES (1, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (6, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (11, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (16, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
        INSERT INTO v_date_tab
        VALUES (2, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (7, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (12, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (13, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
        INSERT INTO v_date_tab
        VALUES (3, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (8, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (9, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (14, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
        INSERT INTO v_date_tab
        VALUES (4, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (5, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (10, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (15, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        DELETE FROM v_nfc_tab;
        INSERT INTO v_nfc_tab
        VALUES (1, 'NFC North'),
        (2, 'NFC East'),
        (3, 'NFC South'),
        (4, 'NFC West');
        DELETE FROM v_afc_tab;
        INSERT INTO v_afc_tab
        VALUES (1, 'AFC West'),
        (2, 'AFC North'),
        (3, 'AFC East'),
        (4, 'AFC South');
        var_i := 1::INTEGER;
        WHILE var_i <= 4::INTEGER LOOP
            SELECT
                conf
                INTO var_v_nfc_conf
                FROM v_nfc_tab
                WHERE id = var_i;
            SELECT
                conf
                INTO var_v_afc_conf
                FROM v_afc_tab
                WHERE id = 1::INTEGER;
            <<cc_block2>>
            BEGIN
                OPEN cross_div_cur;
                <<cross_div_cur_loop>>
                LOOP
                    FETCH FROM cross_div_cur INTO var_v_t2_id, var_v_t2_field_id, var_v_t1_id, var_v_t1_field_id;
                    IF NOT FOUND THEN
                        CLOSE cross_div_cur;
                        EXIT cross_div_cur_loop;
                    END IF;
                    SELECT
                        dt
                        INTO var_v_dt
                        FROM v_date_tab
                        WHERE id = var_v_rownum;
                    IF (var_v_rownum::NUMERIC % 2::NUMERIC) = 0 THEN
                        INSERT INTO dms_sample.sporting_event (sport_type_name, home_team_id, away_team_id, location_id, start_date_time, start_date)
                        VALUES ('football', var_v_t2_id, var_v_t1_id, var_v_t2_field_id, var_v_dt, var_v_dt);
                    ELSE
                        INSERT INTO dms_sample.sporting_event (sport_type_name, home_team_id, away_team_id, location_id, start_date_time, start_date)
                        VALUES ('football', var_v_t1_id, var_v_t2_id, var_v_t1_field_id, var_v_dt, var_v_dt);
                    END IF;
                END LOOP;
            END CC_BLOCK2;
            var_i := (var_i::NUMERIC + 1::NUMERIC)::INTEGER;
        END LOOP;
        DELETE FROM v_date_tab;
        var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
        INSERT INTO v_date_tab
        VALUES (1, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (6, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (11, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (16, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
        INSERT INTO v_date_tab
        VALUES (2, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (7, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (12, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (13, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
        INSERT INTO v_date_tab
        VALUES (3, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (8, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (9, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (14, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        var_v_event_date := dms_sample.edate_add(var_v_event_date::TIMESTAMP, (7)::TEXT, 'DAY'::TEXT)::TIMESTAMP WITHOUT TIME ZONE;
        INSERT INTO v_date_tab
        VALUES (4, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (5, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (10, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        INSERT INTO v_date_tab
        VALUES (15, dms_sample.edate_add(var_v_event_date::TIMESTAMP, (FLOOR((RANDOM() * (19::NUMERIC - 12::NUMERIC + 1::NUMERIC))::NUMERIC) + 12::NUMERIC)::TEXT, 'HOUR'::TEXT));
        DELETE FROM v_nfc_tab;
        INSERT INTO v_nfc_tab
        VALUES (1, 'NFC North'),
        (2, 'NFC East'),
        (3, 'NFC South'),
        (4, 'NFC West');
        DELETE FROM v_afc_tab;
        INSERT INTO v_afc_tab
        VALUES (1, 'AFC South'),
        (2, 'AFC West'),
        (3, 'AFC North'),
        (4, 'AFC East');
        var_i := 1::INTEGER;
        WHILE var_i <= 4::INTEGER LOOP
            SELECT
                conf
                INTO var_v_nfc_conf
                FROM v_nfc_tab
                WHERE id = var_i;
            SELECT
                conf
                INTO var_v_afc_conf
                FROM v_afc_tab
                WHERE id = 1::INTEGER;
            <<cc_block3>>
            BEGIN
                OPEN cross_div_cur;
                <<cross_div_cur_loop>>
                LOOP
                    FETCH FROM cross_div_cur INTO var_v_t2_id, var_v_t2_field_id, var_v_t1_id, var_v_t1_field_id;
                    IF NOT FOUND THEN
                        CLOSE cross_div_cur;
                        EXIT cross_div_cur_loop;
                    END IF;
                    SELECT
                        dt
                        INTO var_v_dt
                        FROM v_date_tab
                        WHERE id = var_v_rownum;
                    IF (var_v_rownum::NUMERIC % 2::NUMERIC) = 0 THEN
                        INSERT INTO dms_sample.sporting_event (sport_type_name, home_team_id, away_team_id, location_id, start_date_time, start_date)
                        VALUES ('football', var_v_t2_id, var_v_t1_id, var_v_t2_field_id, var_v_dt, var_v_dt);
                    ELSE
                        INSERT INTO dms_sample.sporting_event (sport_type_name, home_team_id, away_team_id, location_id, start_date_time, start_date)
                        VALUES ('football', var_v_t1_id, var_v_t2_id, var_v_t1_field_id, var_v_dt, var_v_dt);
                    END IF;
                END LOOP;
            END CC_BLOCK3;
            var_i := (var_i::NUMERIC + 1::NUMERIC)::INTEGER;
        END LOOP;
    END CROSS_CONF_BLOCK;
END;
$$;

ALTER FUNCTION dms_sample.generatenflseason() OWNER TO pgadmin;
CREATE FUNCTION dms_sample.generateseats() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_done VARCHAR(50) DEFAULT FALSE;
    var_v_sport_location_id INTEGER;
    var_v_seating_capacity VARCHAR(50);
    var_v_levels VARCHAR(50);
    var_v_sections VARCHAR(50);
    var_v_seat_type VARCHAR(15);
    var_v_rowCt INTEGER;
    var_i INTEGER;
    var_j INTEGER;
    var_k VARCHAR(50);
    var_l VARCHAR(50);
    var_v_tot_seats VARCHAR(50);
    var_v_rows VARCHAR(50);
    var_v_seats VARCHAR(50);
    var_v_seat_count INTEGER;
    var_v_seat_idx INTEGER;
    var_v_max_rows_per_section INTEGER DEFAULT 25;
    var_v_min_rows_per_section INTEGER DEFAULT 15;
    var_s_ref VARCHAR(30) DEFAULT 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    loc_cur CURSOR FOR
    SELECT
        id, seating_capacity, levels, sections
        FROM dms_sample.sport_location;
BEGIN
    DROP TABLE IF EXISTS seat_tab;
    DROP TABLE IF EXISTS seat_type_tab;
    CREATE TEMPORARY TABLE seat_tab as select sport_location_id, seat_level, seat_section, seat_row, seat, seat_type from seat;
    CREATE TEMPORARY TABLE seat_type_tab
    (id INTEGER PRIMARY KEY,
        name VARCHAR(15));
    var_v_rowCt := 0::INTEGER;
    WHILE var_v_rowCt < 100::INTEGER LOOP
        var_v_rowCt := (var_v_rowCt::NUMERIC + 1::NUMERIC)::INTEGER;
        IF var_v_rowCt <= 5::INTEGER THEN
            var_v_seat_type := 'luxury'::VARCHAR(15);
        END IF;
        IF 5 < var_v_rowCt::NUMERIC(10, 0) AND var_v_rowCt <= 35::INTEGER THEN
            var_v_seat_type := 'premium'::VARCHAR(15);
        END IF;
        IF 35 < var_v_rowCt::NUMERIC(10, 0) AND var_v_rowCt <= 89::INTEGER THEN
            var_v_seat_type := 'standard'::VARCHAR(15);
        END IF;
        IF 89 < var_v_rowCt::NUMERIC(10, 0) AND var_v_rowCt <= 99::INTEGER THEN
            var_v_seat_type := 'sub-standard'::VARCHAR(15);
        END IF;
        IF var_v_rowCt = 100::INTEGER THEN
            var_v_seat_type := 'obstructed'::VARCHAR(15);
        END IF;
        INSERT INTO seat_type_tab (id, name)
        VALUES (var_v_rowCt, var_v_seat_type);
    END LOOP;
    OPEN loc_cur;
    <<read_loop>>
    LOOP
        FETCH FROM loc_cur INTO var_v_sport_location_id, var_v_seating_capacity, var_v_levels, var_v_sections;
        IF NOT FOUND THEN
            EXIT read_loop;
        END IF;
        var_v_seat_count := 0::INTEGER;
        var_v_tot_seats := 0::INTEGER;
        var_v_rows := (FLOOR((RANDOM() * (var_v_max_rows_per_section::NUMERIC - var_v_min_rows_per_section::NUMERIC + 1::NUMERIC))::NUMERIC) + var_v_min_rows_per_section::NUMERIC)::INTEGER;
        var_v_seats := TRUNC((var_v_seating_capacity::NUMERIC / (var_v_levels::NUMERIC * var_v_sections::NUMERIC * var_v_rows::NUMERIC) + 1::NUMERIC)::NUMERIC, (0)::INT)::INTEGER;
        var_i := 1::INTEGER;
        var_j := 1::INTEGER;
        var_k := 1::INTEGER;
        var_l := 1::INTEGER;
        WHILE var_i <= var_v_levels::INTEGER LOOP
            var_i := (var_i::NUMERIC + 1::NUMERIC)::INTEGER;
            WHILE var_j <= var_v_sections::INTEGER LOOP
                var_j := (var_j::NUMERIC + 1::NUMERIC)::INTEGER;
                WHILE var_k <= var_v_rows LOOP
                    var_k := (var_k::NUMERIC + 1::NUMERIC)::INTEGER;
                    WHILE var_l <= var_v_seats LOOP
                        var_l := (var_l::NUMERIC + 1::NUMERIC)::INTEGER;
                        var_v_tot_seats := (var_v_tot_seats::NUMERIC + 1::NUMERIC)::INTEGER;
                        IF var_v_tot_seats <= var_v_seating_capacity THEN
                            var_v_seat_idx := (FLOOR((RANDOM() * (100::NUMERIC - 1::NUMERIC + 1::NUMERIC))::NUMERIC) + 1::NUMERIC)::INTEGER;
                            SELECT
                                name
                                INTO var_v_seat_type
                                FROM seat_type_tab
                                WHERE id = var_v_seat_idx;
                            INSERT INTO seat_tab (sport_location_id, seat_level, seat_section, seat_row, seat, seat_type)
                            VALUES (var_v_sport_location_id, var_i, var_j, esubstr(var_s_ref::VARCHAR, var_k::INT, 1::INT), var_l, var_v_seat_type);
                            var_v_seat_count := (var_v_seat_count::NUMERIC + 1::NUMERIC)::INTEGER;
                            IF var_v_seat_count > 1000::INTEGER THEN
                                INSERT INTO dms_sample.seat (sport_location_id, seat_level, seat_section, seat_row, seat, seat_type)
                                SELECT
                                    var_v_sport_location_id, seat_level, seat_section, seat_row, seat, var_v_seat_type
                                    FROM seat_tab;
                                DELETE FROM seat_tab;
                                var_v_seat_count := 1::INTEGER;
                            END IF;
                        END IF;
                    END LOOP;
                    var_l := 0::INTEGER;
                END LOOP;
                var_k := 0::INTEGER;
            END LOOP;
            var_j := 0::INTEGER;
        END LOOP;
        INSERT INTO dms_sample.seat (sport_location_id, seat_level, seat_section, seat_row, seat, seat_type)
        SELECT
            var_v_sport_location_id, seat_level, seat_section, seat_row, seat, var_v_seat_type
            FROM seat_tab;
        DELETE FROM seat_tab;
        var_v_tot_seats := 1::INTEGER;
    END LOOP;
    CLOSE loc_cur;
END;
$$;

ALTER FUNCTION dms_sample.generateseats() OWNER TO pgadmin;
CREATE FUNCTION dms_sample.generatesporttickets(par_p_sport character varying, OUT p_refcur refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_v_event_id BIGINT;
    var_all_done varchar(10) DEFAULT FALSE;
    event_cur2 CURSOR FOR
    SELECT
        id
        FROM dms_sample.sporting_event
        WHERE LOWER(sport_type_name) = LOWER(par_p_sport);
BEGIN
    OPEN p_refcur FOR
    SELECT
        par_p_sport;
    OPEN event_cur2;
    <<event_loop>>
    LOOP
        FETCH event_cur2 INTO var_v_event_id;
        IF NOT FOUND THEN
            CLOSE event_cur2;
            EXIT event_loop;
        END IF;
        
      WITH event_list AS (
        SELECT
          id AS var_v_e_id,
          location_id AS var_v_loc_id
        FROM dms_sample.sporting_event
        WHERE id = var_v_event_id
      ),
      constants AS (
        SELECT 
          ROUND(((RANDOM() * (50::NUMERIC - 30::NUMERIC)) + 30::NUMERIC)::NUMERIC, (2)::INT)::NUMERIC(6, 2)
            AS var_v_standard_price
      )
        INSERT INTO dms_sample.sporting_event_ticket (
          sporting_event_id, 
          sport_location_id, 
          seat_level, 
          seat_section, 
          seat_row, 
          seat, 
          ticket_price
        )
        SELECT
          sporting_event.id, 
          seat.sport_location_id, 
          seat.seat_level, 
          seat.seat_section, 
          seat.seat_row, 
          seat.seat, 
          (CASE
            WHEN LOWER(seat.seat_type) = LOWER('luxury'::VARCHAR(15))
              THEN 3::NUMERIC * var_v_standard_price::NUMERIC
            WHEN LOWER(seat.seat_type) = LOWER('premium'::VARCHAR(15))
              THEN 2::NUMERIC * var_v_standard_price::NUMERIC
            WHEN LOWER(seat.seat_type) = LOWER('standard'::VARCHAR(15))
              THEN var_v_standard_price
            WHEN LOWER(seat.seat_type) = LOWER('sub-standard'::VARCHAR(15))
              THEN 0.8::NUMERIC * var_v_standard_price::NUMERIC
            WHEN LOWER(seat.seat_type) = LOWER('obstructed'::VARCHAR(15))
              THEN 0.5::NUMERIC * var_v_standard_price::NUMERIC
            WHEN LOWER(seat.seat_type) = LOWER('standing'::VARCHAR(15))
              THEN 0.5::NUMERIC * var_v_standard_price::NUMERIC
        END) AS ticket_price
        FROM constants, event_list, dms_sample.sporting_event, dms_sample.seat
        WHERE sporting_event.location_id = seat.sport_location_id
          AND sporting_event.id = var_v_e_id;
              
    END LOOP;
END;
$$;

ALTER FUNCTION dms_sample.generatesporttickets(par_p_sport character varying, OUT p_refcur refcursor) OWNER TO pgadmin;
CREATE FUNCTION dms_sample.generateticketactivity(par_max_transactions integer DEFAULT 10) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	min_person_id INTEGER;
	max_person_id INTEGER;
	rand_person_id INTEGER;
	min_event_id INTEGER;
	max_event_id INTEGER;
	rand_event_id INTEGER;
	tick_quantity INTEGER;
	var_current_txn INTEGER DEFAULT 0;
		
	
BEGIN
	min_person_id := (select MIN(id) FROM dms_sample.person);
	max_person_id := (select MAX(id) FROM dms_sample.person);
	min_event_id := (select MIN(sporting_event_id) FROM dms_sample.sporting_event_ticket);
	max_event_id := (select MAX(sporting_event_id) FROM dms_sample.sporting_event_ticket);
	WHILE var_current_txn < par_max_transactions LOOP
	rand_person_id := floor(random()*(max_person_id-min_person_id+min_person_id))+min_person_id;
	rand_event_id := floor(random()*(max_event_id-min_event_id+min_event_id))+min_event_id;
	tick_quantity := floor(random()*(10000-2000+2000))+2000;
      
    WITH ticket_list AS (
      SELECT
        id AS var_v_ticket_id, 
        seat_level AS var_v_seat_level,
        seat_section AS var_v_seat_section,
        seat_row AS var_v_seat_row
      FROM dms_sample.sporting_event_ticket
      WHERE sporting_event_id = rand_event_id
      ORDER BY seat_level NULLS FIRST, 
        LOWER(seat_section) NULLS FIRST, 
        LOWER(seat_row) NULLS FIRST
      LIMIT tick_quantity
    ),
     ticket_holder_list AS (
      UPDATE dms_sample.sporting_event_ticket
        SET ticketholder_id = rand_person_id
      FROM ticket_list
      WHERE id = var_v_ticket_id
      RETURNING id,
        ticketholder_id,
        ticket_price
    )
    INSERT INTO dms_sample.ticket_purchase_hist (
      sporting_event_ticket_id, 
      purchased_by_id, 
      transaction_date_time, 
      purchase_price)
    SELECT
      id,
      ticketholder_id, 
      clock_timestamp()::TIMESTAMP, 
      ticket_price
    FROM ticket_holder_list;
	var_current_txn := (var_current_txn + 1)::INT;
	END LOOP;
END;
$$;

ALTER FUNCTION dms_sample.generateticketactivity(par_max_transactions integer) OWNER TO pgadmin;
CREATE FUNCTION dms_sample.generatetransferactivity(par_max_transactions numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_txn_count NUMERIC(10, 0) DEFAULT 0;
    var_min_tik_id NUMERIC(20, 0);
    var_max_tik_id NUMERIC(20, 0);
    var_tik_id NUMERIC(20, 0);
    var_max_p_id NUMERIC(10, 0);
    var_min_p_id NUMERIC(10, 0);
    var_person_id NUMERIC(10, 0);
    var_rand_p_max NUMERIC(10, 0);
    var_rand_max NUMERIC(20, 0);
    var_xfer_all NUMERIC(1, 0) DEFAULT 1;
    var_price NUMERIC(10, 4);
    var_price_multiplier NUMERIC(18, 0) DEFAULT 1;
BEGIN
    SELECT
        MIN(sporting_event_ticket_id), MAX(sporting_event_ticket_id)
        INTO var_min_tik_id, var_max_tik_id
        FROM dms_sample.ticket_purchase_hist;
    SELECT
        MIN(id), MAX(id)
        INTO var_min_p_id, var_max_p_id
        FROM dms_sample.person;
    WHILE var_txn_count < par_max_transactions LOOP
        /* find a random upper bound for ticket and person ids */
        var_rand_max := floor(random()*(var_max_tik_id-var_min_tik_id+var_min_tik_id))+var_min_tik_id;
        var_rand_p_max := floor(random()*(var_max_p_id-var_min_p_id+var_min_p_id))+var_min_p_id;
        SELECT
            MAX(sporting_event_ticket_id)
            INTO var_tik_id
            FROM dms_sample.ticket_purchase_hist
            WHERE sporting_event_ticket_id <= var_rand_max;
        SELECT
            MAX(id)
            INTO var_person_id
            FROM dms_sample.person
            WHERE id <= var_rand_p_max
        /* 80% of the time transfer all tickets, 20% of the time don't */;
        IF ((floor(random()*(5-1+1))+1) = 5) THEN
            var_xfer_all := 0;
        END IF
        /* 30% of the time change the price by up to 20% in either direction */;
        IF ((floor(random()*(3-1+1))+1) = 1) THEN
            var_price_multiplier := CAST ((floor(random()*(12-8+8))+8) AS NUMERIC(18, 0)) / 10;            
        END IF;
        SELECT
            var_price_multiplier * ticket_price
            INTO var_price
            FROM dms_sample.sporting_event_ticket
            WHERE id = var_tik_id;
        PERFORM dms_sample.transferticket(var_tik_id, var_person_id, var_xfer_all, var_price)
        /* reset some variables */;
        var_txn_count := (var_txn_count + 1)::INT;
        var_xfer_all := 1;
        var_price_multiplier := 1;
    END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '%', ('Sorry, no tickets are available for transfer.');
END;
$$;

ALTER FUNCTION dms_sample.generatetransferactivity(par_max_transactions numeric) OWNER TO pgadmin;
CREATE FUNCTION dms_sample.loadmlbplayers() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_v_sport_team_id INTEGER;
    var_v_last_name VARCHAR(30);
    var_v_first_name VARCHAR(30);
    var_v_full_name VARCHAR(30);
    var_v_team_name VARCHAR(60);
    var_done VARCHAR(10) DEFAULT FALSE;
    mlb_players CURSOR FOR
    SELECT DISTINCT
        CASE LOWER(LTRIM(RTRIM(mlb_team_long::VARCHAR)::VARCHAR))
            WHEN LOWER('Anaheim Angels') THEN 'Los Angeles Angels'
            ELSE LTRIM(RTRIM(mlb_team_long::VARCHAR)::VARCHAR)
        END AS mlb_team_long, LTRIM(RTRIM(mlb_name::VARCHAR)::VARCHAR) AS name, esubstr(LTRIM(RTRIM(mlb_name::VARCHAR)::VARCHAR)::VARCHAR, 1::INT, POSITION(' '::VARCHAR IN mlb_name::VARCHAR)::INT) AS t_name, esubstr(LTRIM(RTRIM(mlb_name::VARCHAR)::VARCHAR)::VARCHAR, POSITION(' '::VARCHAR IN mlb_name::VARCHAR)::INT, LENGTH(mlb_name::VARCHAR)::INT) AS f_name
        FROM dms_sample.mlb_data;
BEGIN
    OPEN mlb_players;
    <<read_loop>>
    LOOP
        FETCH FROM mlb_players INTO var_v_team_name, var_v_last_name, var_v_first_name, var_v_full_name;
        IF NOT FOUND THEN
            EXIT read_loop;
        END IF;
        SELECT
            id::INTEGER
            INTO var_v_sport_team_id
            FROM dms_sample.sport_team
            WHERE LOWER(sport_type_name) = LOWER('baseball'::VARCHAR(15)) AND LOWER(sport_league_short_name) = LOWER('MLB'::VARCHAR(10)) AND LOWER(name) = LOWER(var_v_team_name::VARCHAR(30));
        INSERT INTO dms_sample.player (sport_team_id, last_name, first_name, full_name)
        VALUES (var_v_sport_team_id, var_v_last_name, var_v_first_name, var_v_full_name);
    END LOOP;
    CLOSE mlb_players;
END;
$$;

ALTER FUNCTION dms_sample.loadmlbplayers() OWNER TO pgadmin;
CREATE FUNCTION dms_sample.loadmlbteams() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_div DMS_SAMPLE.SPORT_DIVISION.short_name%TYPE;
    mlb_teams CURSOR FOR
    SELECT DISTINCT
        CASE TRIM(mlb_team)
            WHEN 'AAA' THEN 'LAA'
            ELSE mlb_team
        END AS a_name,
        CASE TRIM(mlb_team_long)
            WHEN 'Anaheim Angels' THEN 'Los Angeles Angels'
            ELSE mlb_team_long
        END AS l_name
        FROM dms_sample.mlb_data;
BEGIN
    FOR trec IN mlb_teams LOOP
        CASE
            WHEN trec.a_name IN ('BAL', 'BOS', 'TOR', 'TB', 'NYY') THEN
                v_div := 'AL East';
            WHEN trec.a_name IN ('CLE', 'DET', 'KC', 'CWS', 'MIN') THEN
                v_div := 'AL Central';
            WHEN trec.a_name IN ('TEX', 'SEA', 'HOU', 'OAK', 'LAA') THEN
                v_div := 'AL West';
            WHEN trec.a_name IN ('WSH', 'MIA', 'NYM', 'PHI', 'ATL') THEN
                v_div := 'NL East';
            WHEN trec.a_name IN ('CHC', 'STL', 'PIT', 'MIL', 'CIN') THEN
                v_div := 'NL Central';
            WHEN trec.a_name IN ('COL', 'SD', 'LAD', 'SF', 'ARI') THEN
                v_div := 'NL West';
        END CASE;
        INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
        VALUES (trec.l_name, trec.a_name, 'baseball', 'MLB', v_div);
    END LOOP;
END;
$$;

ALTER FUNCTION dms_sample.loadmlbteams() OWNER TO pgadmin;
CREATE FUNCTION dms_sample.loadnflplayers() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_v_team VARCHAR(10);
    var_v_name VARCHAR(60);
    var_v_l_name VARCHAR(30);
    var_v_f_name VARCHAR(30);
    var_v_sport_team_id INTEGER;
    var_done VARCHAR(10) DEFAULT FALSE;
    nfl_players CURSOR FOR
    SELECT
        team, name, esubstr(RTRIM(LTRIM(name::VARCHAR)::VARCHAR)::VARCHAR, 1::INT, POSITION(','::VARCHAR IN name::VARCHAR) - 1::NUMERIC::INT) AS l_name, RTRIM(LTRIM(esubstr(RTRIM(LTRIM(name::VARCHAR)::VARCHAR)::VARCHAR, POSITION(','::VARCHAR IN name::VARCHAR) + 1::NUMERIC::INT, LENGTH(name::VARCHAR)::INT)::VARCHAR)::VARCHAR) AS f_name
        FROM dms_sample.nfl_data;
BEGIN
    OPEN nfl_players;
    <<read_loop>>
    LOOP
        FETCH FROM nfl_players INTO var_v_team, var_v_name, var_v_l_name, var_v_f_name;
        IF NOT FOUND THEN
            EXIT read_loop;
        END IF;
        SELECT
            id::INTEGER
            INTO var_v_sport_team_id
            FROM dms_sample.sport_team
            WHERE LOWER(sport_type_name) = LOWER('football'::VARCHAR(15)) AND LOWER(sport_league_short_name) = LOWER('NFL'::VARCHAR(10)) AND LOWER(abbreviated_name) = LOWER(var_v_team);
        INSERT INTO dms_sample.player (sport_team_id, last_name, first_name, full_name)
        VALUES (var_v_sport_team_id, var_v_l_name, var_v_f_name, var_v_name);
    END LOOP;
    CLOSE nfl_players;
END;
$$;

ALTER FUNCTION dms_sample.loadnflplayers() OWNER TO pgadmin;
CREATE FUNCTION dms_sample.loadnflteams() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_sport_type CHARACTER VARYING(10) DEFAULT 'football';
    v_league CHARACTER VARYING(10) DEFAULT 'NFL';
    v_division CHARACTER VARYING(10);
BEGIN
    v_division := 'AFC North';
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Baltimore Ravens', 'BAL', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Cincinnati Bengals', 'CIN', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Cleveland Browns', 'CLE', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Pittsburgh Steelers', 'PIT', v_sport_type, v_league, v_division);
    v_division := 'AFC South';
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Houston Texans', 'HOU', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Indianapolis Colts', 'IND', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Jacksonville Jaguars', 'JAX', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Tennessee Titans', 'TEN', v_sport_type, v_league, v_division);
    v_division := 'AFC East';
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Buffalo Bills', 'BUF', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Miami Dolphins', 'MIA', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('New England Patriots', 'NE', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('New York Jets', 'NYJ', v_sport_type, v_league, v_division);
    v_division := 'AFC West';
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Denver Broncos', 'DEN', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Kansas City Chiefs', 'KC', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Oakland Raiders', 'OAK', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('San Diego Chargers', 'SD', v_sport_type, v_league, v_division);
    v_division := 'NFC North';
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Chicago Bears', 'CHI', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Detroit Lions', 'DET', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Green Bay Packers', 'GB', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Minnesota Vikings', 'MIN', v_sport_type, v_league, v_division);
    v_division := 'NFC South';
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Atlanta Falcons', 'ATL', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Carolina Panthers', 'CAR', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('New Orleans Saints', 'NO', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Tampa Bay Buccaneers', 'TB', v_sport_type, v_league, v_division);
    v_division := 'NFC East';
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Dallas Cowboys', 'DAL', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('New York Giants', 'NYG', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Philadelphia Eagles', 'PHI', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Washington Redskins', 'WAS', v_sport_type, v_league, v_division);
    v_division := 'NFC West';
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Arizona Cardinals', 'ARI', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Los Angeles Rams', 'LA', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('San Francisco 49ers', 'SF', v_sport_type, v_league, v_division);
    INSERT INTO dms_sample.sport_team (name, abbreviated_name, sport_type_name, sport_league_short_name, sport_division_short_name)
    VALUES ('Seattle Seahawks', 'SEA', v_sport_type, v_league, v_division);
END;
$$;

ALTER FUNCTION dms_sample.loadnflteams() OWNER TO pgadmin;
CREATE FUNCTION dms_sample.setnflteamhomefield() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_v_sport_location_id INTEGER;
    var_v_team VARCHAR(40);
    var_v_loc VARCHAR(40);
    var_done VARCHAR(40) DEFAULT FALSE;
    nsd_cur CURSOR FOR
    SELECT
        sport_location_id, team, location
        FROM dms_sample.nfl_stadium_data;
BEGIN
    OPEN nsd_cur;
    <<read_loop>>
    LOOP
        FETCH FROM nsd_cur INTO var_v_sport_location_id, var_v_team, var_v_loc;
        IF NOT FOUND THEN
            EXIT read_loop;
        END IF;
        UPDATE dms_sample.sport_team AS s
        SET home_field_id = var_v_sport_location_id::SMALLINT
            WHERE LOWER(s.name) = LOWER(var_v_team::VARCHAR(30)) AND LOWER(s.sport_league_short_name) = LOWER('NFL'::VARCHAR(10)) AND LOWER(s.sport_type_name) = LOWER('football'::VARCHAR(15));
    END LOOP;
    CLOSE nsd_cur;
END;
$$;

ALTER FUNCTION dms_sample.setnflteamhomefield() OWNER TO pgadmin;
CREATE FUNCTION dms_sample.transferticket(par_ticket_id numeric, par_new_ticketholder_id numeric, par_transfer_all numeric DEFAULT 0, par_price numeric DEFAULT NULL::numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_last_txn_date TIMESTAMP WITHOUT TIME ZONE;
    var_old_ticketholder_id NUMERIC(10, 0);
    var_sporting_event_ticket_id NUMERIC(20, 0);
    var_purchase_price NUMERIC(10, 4);
    var_xfer_cur refcursor;
BEGIN
    SELECT
        MAX(h.transaction_date_time), t.ticketholder_id
        INTO var_last_txn_date, var_old_ticketholder_id
        FROM dms_sample.ticket_purchase_hist AS h, dms_sample.sporting_event_ticket AS t
        WHERE t.id = par_ticket_id AND h.purchased_by_id = t.ticketholder_id AND ((h.sporting_event_ticket_id = par_ticket_id) OR (par_transfer_all = 1))
        GROUP BY t.ticketholder_id;
    OPEN var_xfer_cur FOR
    SELECT
        sporting_event_ticket_id, purchase_price
        FROM dms_sample.ticket_purchase_hist
        WHERE purchased_by_id = var_old_ticketholder_id AND transaction_date_time = var_last_txn_date;
    FETCH var_xfer_cur INTO var_sporting_event_ticket_id, var_purchase_price;
    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        /* update the sporting event ticket with the new owner */
        UPDATE dms_sample.sporting_event_ticket
        SET ticketholder_id = par_new_ticketholder_id
            WHERE id = var_sporting_event_ticket_id
        /* record the transaction */;
        INSERT INTO dms_sample.ticket_purchase_hist (sporting_event_ticket_id, purchased_by_id, transferred_from_id, transaction_date_time, purchase_price)
        VALUES (var_sporting_event_ticket_id, par_new_ticketholder_id, var_old_ticketholder_id, CURRENT_TIMESTAMP(3), COALESCE(par_price, var_purchase_price));
        FETCH var_xfer_cur INTO var_sporting_event_ticket_id, var_purchase_price;
    END LOOP;
    CLOSE var_xfer_cur
    ;
END;
$$;

ALTER FUNCTION dms_sample.transferticket(par_ticket_id numeric, par_new_ticketholder_id numeric, par_transfer_all numeric, par_price numeric) OWNER TO pgadmin;
SET default_tablespace = '';
SET default_with_oids = false;
