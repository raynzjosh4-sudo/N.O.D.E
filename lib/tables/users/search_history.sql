-- lib/tables/users/search_history.sql

-- 1. Create the Search History Table
CREATE TABLE IF NOT EXISTS public.search_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users_table(id) ON DELETE CASCADE,
    
    -- The search term entered by the user
    query TEXT NOT NULL,
    
    -- Track when the search was performed for recency sorting
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- 2. Index for quick lookup of a user's recent searches
CREATE INDEX idx_search_history_user_date ON public.search_history(user_id, created_at DESC);

-- 3. Enable RLS
ALTER TABLE public.search_history ENABLE ROW LEVEL SECURITY;

-- Policy: Users only manage their own search history
CREATE POLICY "Users can manage own search history" ON public.search_history
    FOR ALL USING (auth.uid() = user_id);
