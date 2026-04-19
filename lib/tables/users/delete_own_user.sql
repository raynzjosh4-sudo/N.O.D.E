-- 🛡️ SECURITY DEFINER Function to allow "Wiping" a fresh, unconfirmed account.
-- This solves the problem where a user wants to cancel a signup but their 
-- email is stuck until it expires.

CREATE OR REPLACE FUNCTION delete_fresh_unconfirmed_user(target_user_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER -- Runs with elevated permissions to access auth.users
AS $$
BEGIN
    -- SECURITY CHECKS:
    -- 1. User must NOT be confirmed (email_confirmed_at IS NULL)
    -- 2. User must be "Fresh" (created in the last 15 minutes)
    -- This prevents malicious deletion of older or active accounts.
    
    DELETE FROM auth.users 
    WHERE id = target_user_id
      AND email_confirmed_at IS NULL
      AND created_at > (now() - interval '15 minutes');
END;
$$;

-- 🏷️ Grant permission to anon and authenticated users
-- The unconfirmed user is technically "anon" or has a basic session.
GRANT EXECUTE ON FUNCTION delete_fresh_unconfirmed_user(UUID) TO authenticated, anon;
