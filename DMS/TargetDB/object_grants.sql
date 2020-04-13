-- Sample script to grant permissions on objects in Target PostgreSQL database

GRANT ALL ON SEQUENCE dms_sample.player_seq TO dms_user;
GRANT ALL ON SEQUENCE dms_sample.sport_location_seq TO dms_user;
GRANT ALL ON SEQUENCE dms_sample.sport_team_seq TO dms_user;
GRANT ALL ON SEQUENCE dms_sample.sporting_event_seq TO dms_user;
GRANT ALL ON SEQUENCE dms_sample.sporting_event_ticket_seq TO dms_user;
GRANT ALL ON TABLE dms_sample.mlb_data TO dms_user;
GRANT ALL ON TABLE dms_sample.name_data TO dms_user;
GRANT ALL ON TABLE dms_sample.nfl_data TO dms_user;
GRANT ALL ON TABLE dms_sample.nfl_stadium_data TO dms_user;
GRANT ALL ON TABLE dms_sample.person TO dms_user;
GRANT ALL ON TABLE dms_sample.player TO dms_user;
GRANT ALL ON TABLE dms_sample.seat TO dms_user;
GRANT ALL ON TABLE dms_sample.seat_type TO dms_user;
GRANT ALL ON TABLE dms_sample.sport_division TO dms_user;
GRANT ALL ON TABLE dms_sample.sport_league TO dms_user;
GRANT ALL ON TABLE dms_sample.sport_location TO dms_user;
GRANT ALL ON TABLE dms_sample.sport_team TO dms_user;
GRANT ALL ON TABLE dms_sample.sport_type TO dms_user;
GRANT ALL ON TABLE dms_sample.sporting_event TO dms_user;
GRANT ALL ON TABLE dms_sample.sporting_event_ticket TO dms_user;
