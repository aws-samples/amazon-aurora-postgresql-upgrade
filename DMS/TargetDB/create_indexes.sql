--
-- Name: se_start_date_fcn; Type: INDEX; Schema: dms_sample; Owner: pgadmin
--

CREATE INDEX se_start_date_fcn ON dms_sample.sporting_event USING btree (date(start_date_time));


--
-- Name: seat_sport_location_idx; Type: INDEX; Schema: dms_sample; Owner: pgadmin
--

CREATE INDEX seat_sport_location_idx ON dms_sample.seat USING btree (sport_location_id);


--
-- Name: set_ev_id_tkholder_id_idx; Type: INDEX; Schema: dms_sample; Owner: pgadmin
--

CREATE INDEX set_ev_id_tkholder_id_idx ON dms_sample.sporting_event_ticket USING btree (sporting_event_id, ticketholder_id);


--
-- Name: set_seat_idx; Type: INDEX; Schema: dms_sample; Owner: pgadmin
--

CREATE INDEX set_seat_idx ON dms_sample.sporting_event_ticket USING btree (sport_location_id, seat_level, seat_section, seat_row, seat);


--
-- Name: set_sporting_event_idx; Type: INDEX; Schema: dms_sample; Owner: pgadmin
--

CREATE INDEX set_sporting_event_idx ON dms_sample.sporting_event_ticket USING btree (sporting_event_id);


--
-- Name: set_ticketholder_idx; Type: INDEX; Schema: dms_sample; Owner: pgadmin
--

CREATE INDEX set_ticketholder_idx ON dms_sample.sporting_event_ticket USING btree (ticketholder_id);


--
-- Name: sport_team_u; Type: INDEX; Schema: dms_sample; Owner: pgadmin
--

CREATE UNIQUE INDEX sport_team_u ON dms_sample.sport_team USING btree (sport_type_name, sport_league_short_name, name);


--
-- Name: tph_purch_by_id; Type: INDEX; Schema: dms_sample; Owner: pgadmin
--

CREATE INDEX tph_purch_by_id ON dms_sample.ticket_purchase_hist USING btree (purchased_by_id);


--
-- Name: tph_trans_from_id; Type: INDEX; Schema: dms_sample; Owner: pgadmin
--

CREATE INDEX tph_trans_from_id ON dms_sample.ticket_purchase_hist USING btree (transferred_from_id);

