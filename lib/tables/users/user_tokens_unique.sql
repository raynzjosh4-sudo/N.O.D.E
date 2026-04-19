-- lib/tables/users/user_tokens_unique.sql

-- Add a unique constraint to device_token to allow for clean upserts
-- This ensures that a single token won't exists multiple times in the table
ALTER TABLE public.user_tokens 
ADD CONSTRAINT user_tokens_device_token_key UNIQUE (device_token);

-- Update RLS policy to be more explicit if needed
-- (Existing policy "Users can manage own tokens" is already FOR ALL)
