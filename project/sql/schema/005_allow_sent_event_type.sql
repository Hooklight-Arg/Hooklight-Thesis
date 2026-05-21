-- Permite registrar el evento "sent" ademas de open y click
ALTER TABLE events
  DROP CONSTRAINT IF EXISTS events_event_type_check;

ALTER TABLE events
  ADD CONSTRAINT events_event_type_check
  CHECK (event_type IN ('sent', 'open', 'click'));
