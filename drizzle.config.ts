import type { Config } from "drizzle-kit";

const databaseUrl = process.env.DATABASE_URL_EXTERNAL;
if (!databaseUrl) {
	throw new Error("DATABASE_URL_EXTERNAL environment variable is required");
}

export default {
	schema: "./app/db/schema.ts",
	out: "./app/db/migrations",
	dialect: "postgresql",
	dbCredentials: {
		url: databaseUrl,
	},
} satisfies Config;
