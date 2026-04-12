/**
 * NODE Monopoly Image Pipeline
 * Cloudflare Edge Worker for On-The-Fly Resizing
 * 
 * Usage: cdn.node.ug/assets/net.jpg?w=400&q=75
 */

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    
    // Only intercept image requests from our R2 bucket
    const imageOptions = {
      width: parseInt(url.searchParams.get("w")) || 800,
      quality: parseInt(url.searchParams.get("q")) || 75,
      format: url.searchParams.get("format") || "auto",
    };

    // Forward the request to Cloudflare's Image Resizing service
    // This requires the "Image Resizing" feature enabled in your CF plan.
    // If not enabled, this worker acts as a simple pass-through.
    return fetch(url.toString(), {
      cf: {
        image: imageOptions,
      },
    });
  },
};
