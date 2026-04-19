-- lib/tables/users/user_tokens.sql

-- 1. Create the Tokens Table (Primarily for FCM Push Notifications)
CREATE TABLE IF NOT EXISTS public.user_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users_table(id) ON DELETE CASCADE,
    
    -- FCM Token or other push notification handle
    device_token TEXT NOT NULL,
    
    -- Device platform info (ios, android, web)
    device_type TEXT,
    
    -- Metadata for tracking active devices
    last_active_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    
    -- Ensure a token is unique per user to prevent duplicate notifications
    UNIQUE(user_id, device_token)
);

-- 2. Trigger for updated_at
CREATE TRIGGER trigger_update_tokens_timestamp
BEFORE UPDATE ON public.user_tokens
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 3. Enable RLS
ALTER TABLE public.user_tokens ENABLE ROW LEVEL SECURITY;

-- Policy: Users only manage their own device tokens
CREATE POLICY "Users can manage own tokens" ON public.user_tokens
    FOR ALL USING (auth.uid() = user_id);
