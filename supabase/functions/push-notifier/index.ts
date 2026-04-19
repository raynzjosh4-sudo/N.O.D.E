// supabase/functions/push-notifier/index.ts
// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";
import { initializeApp, cert } from "npm:firebase-admin/app";
import { getMessaging } from "npm:firebase-admin/messaging";

// Initialize Firebase Admin
const serviceAccount = JSON.parse(Deno.env.get('FIREBASE_SERVICE_ACCOUNT') || '{}');

if (Object.keys(serviceAccount).length > 0) {
  try {
    initializeApp({ credential: cert(serviceAccount) });
  } catch (err) {
    // Ignore if already initialized
    console.log('Firebase Admin already initialized or error:', err.message);
  }
}

// Define the webhook payload based on notifications_table
interface WebhookPayload {
  type: 'INSERT';
  table: string;
  record: {
    id: string;
    user_id: string;
    title: string;
    description: string | null;
    category: string;
    is_unread: boolean;
    metadata: any;
    created_at: string;
  };
  schema: string;
  old_record: null;
}

Deno.serve(async (req: Request) => {
  try {
    const payload: WebhookPayload = await req.json();
    console.log('🔔 Received Notification Hook:', payload.record.title);
    
    const { user_id, title, description } = payload.record;

    // Initialize Supabase client with the Service Role key to bypass RLS
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    );

    // Fetch all active device tokens for this user from user_tokens table
    const { data: tokens, error } = await supabase
      .from('user_tokens')
      .select('device_token')
      .eq('user_id', user_id);

    if (error) {
      console.error('❌ Error fetching tokens:', error);
      throw error;
    }

    if (!tokens || tokens.length === 0) {
      console.log('ℹ️ No device tokens found for user:', user_id);
      return new Response(
        JSON.stringify({ success: false, message: 'No tokens found' }),
        { headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Extract just the token strings into an array
    const deviceTokens = tokens.map(t => t.device_token);
    console.log(`📡 Sending to ${deviceTokens.length} devices...`);

    // Send a multicast message to all of the user's devices
    const response = await getMessaging().sendEachForMulticast({
      tokens: deviceTokens,
      notification: {
        title: title,
        body: description || '', // Fallback to empty string if description is null
      },
    });

    console.log('✅ Push sent successfully:', response.successCount, 'successes');

    return new Response(
      JSON.stringify({ success: true, results: response }),
      { headers: { 'Content-Type': 'application/json', 'Connection': 'keep-alive' } }
    );
  } catch (error: any) {
    console.error('❌ Push error:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});
