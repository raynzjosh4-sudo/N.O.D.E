-- lib/tables/users/notifications.sql

-- 1. Create the Notifications Table
CREATE TABLE IF NOT EXISTS public.notifications_table (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users_table(id) ON DELETE CASCADE,
    
    title TEXT NOT NULL,
    description TEXT,
    
    -- Categories match the NotificationCategory enum in Flutter
    category TEXT NOT NULL CHECK (category IN (
        'all', 'orders', 'inventory', 'logistics', 'security', 'finance', 'system', 'ai', 'messages'
    )),
    
    is_unread BOOLEAN DEFAULT true,
    
    -- Metadata stores deep links or IDs (e.g., { "order_id": "..." })
    metadata JSONB DEFAULT '{}'::jsonb,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- 2. Index for quick lookup of unread notifications
CREATE INDEX idx_notifications_unread ON public.notifications_table(user_id, is_unread);

-- 3. Enable RLS
ALTER TABLE public.notifications_table ENABLE ROW LEVEL SECURITY;

-- Policy: Users only see their own notifications
CREATE POLICY "Users can view own notifications" ON public.notifications_table
    FOR SELECT USING (auth.uid() = user_id);

-- Policy: Users can mark their own notifications as read
CREATE POLICY "Users can manage own notifications" ON public.notifications_table
    FOR ALL USING (auth.uid() = user_id);
