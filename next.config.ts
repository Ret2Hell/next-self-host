import type { NextConfig } from "next";

const nextConfig: NextConfig = {
	// Recommended: this will reduce output
	// Docker image size by 80%+
	output: "standalone",
	images: {
		// We're defaulting to optimizing images with
		// Sharp, which is built-into `next start`
		remotePatterns: [
			{
				protocol: "https",
				hostname: "images.unsplash.com",
				port: "",
				pathname: "/**",
				search: "",
			},
		],
	},
	// Nginx will do gzip compression. We disable
	// compression here so we can prevent buffering
	// streaming responses
	compress: false,
	// Optional: override the default (1 year) `stale-while-revalidate`
	// header time for static pages
	// swrDelta: 3600 // seconds
};

export default nextConfig;
