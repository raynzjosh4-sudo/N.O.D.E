-- lib/tables/users/security_trigger.sql

-- 1. Enable the HTTP extension (if not already enabled)
CREATE EXTENSION IF NOT EXISTS "http" WITH SCHEMA "extensions";

-- 2. Create the Trigger Function
CREATE OR REPLACE FUNCTION public.handle_new_login()
RETURNS TRIGGER AS $$
BEGIN
    -- Only trigger if last_sign_in_at has changed (signifying a new session)
    IF (OLD.last_sign_in_at IS DISTINCT FROM NEW.last_sign_in_at) THEN
        PERFORM
            extensions.http_post(
                'https://lihoygvdnnfqodjjxqnz.functions.supabase.co/security-notifier',
                json_build_object(
                    'record', json_build_object(
                        'id', NEW.id,
                        'email', NEW.email,
                        'last_sign_in_at', NEW.last_sign_in_at
                    )
                )::text,
                'application/json'
            );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Attach the Trigger to auth.users
-- Note: You must run this specifically in the SQL editor as auth schema access is restricted.
DROP TRIGGER IF EXISTS on_auth_user_login ON auth.users;
CREATE TRIGGER on_auth_user_login
    AFTER UPDATE ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_login();
