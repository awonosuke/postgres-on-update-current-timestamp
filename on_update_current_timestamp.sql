-- define function
CREATE FUNCTION trg_update_timestamp_none() RETURNS trigger AS
$$
BEGIN
  IF NEW._updated_at = OLD._updated_at THEN
    NEW._updated_at := NULL;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION trg_update_timestamp_same() RETURNS trigger AS
$$
BEGIN
  IF NEW._updated_at IS NULL THEN
    NEW._updated_at := OLD._updated_at;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION trg_update_timestamp_current() RETURNS trigger AS
$$
BEGIN
  IF NEW._updated_at IS NULL THEN
    NEW._updated_at := current_timestamp;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- difine trigger
CREATE TRIGGER update_users_updated_at_step1
  BEFORE UPDATE ON users FOR EACH ROW
  EXECUTE PROCEDURE trg_update_timestamp_none();

CREATE TRIGGER update_users_updated_at_step2
  BEFORE UPDATE OF _updated_at ON users FOR EACH ROW
  EXECUTE PROCEDURE trg_update_timestamp_same();

CREATE TRIGGER update_users_updated_at_step3
  BEFORE UPDATE ON users FOR EACH ROW
  EXECUTE PROCEDURE trg_update_timestamp_current();
