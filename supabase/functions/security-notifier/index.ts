// lib/supabase/functions/security-notifier/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const payload = await req.json()
    const { record } = payload // From Database Webhook

    if (!record || !record.id) {
      throw new Error('No user record found in payload')
    }

    const userId = record.id
    const userEmail = record.email
    const lastSignIn = record.last_sign_in_at

    console.log(`🛡️ Security Notifier: Processing login for user ${userEmail} (${userId})`)

    // In a real scenario, you'd check if this is a "New Device" by comparing
    // with previously known device tokens. For this implementation, we'll
    // generate a high-priority security alert.

    const { error: insertError } = await supabaseClient
      .from('notifications_table')
      .insert({
        user_id: userId,
        title: 'New Device Login Detected',
        description: `Your account was just accessed from a new device. If this wasn't you, lock your wallet immediately.`,
        category: 'security',
        is_unread: true,
        metadata: {
          type: 'new_login',
          // You can parse User-Agent / IP here if your trigger passes them
          device: 'Detected Device',
          location: 'Recent Login Location',
          timestamp: lastSignIn
        }
      })

    if (insertError) throw insertError

    return new Response(JSON.stringify({ success: true }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })

  } catch (error) {
    console.error('❌ Error in security-notifier:', error.message)
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})
