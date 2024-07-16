import http from "http";
import express from "express";
import pg from "pg";
import GracefulShutdown from "http-graceful-shutdown";
import cors from "cors";

export const app = express();
app.use(cors());

app.get("/hello", (request, response) => {
  console.log("GET /hello");
  const name = request.query?.name;
  console.log("Test", name);
  return response.json({ message: `hello, ${name ?? "world"}` });
});

app.get("/hello-pg", async (_, response) => {
  try {
    console.log("GET /hello-pg");

    const client = new pg.Client({
      connectionString: "postgres://api-user:api-password@database:5432/api-db",
    });
    await client.connect();

    const res = await client.query("SELECT $1::text as message", [
      "hello world from postgres",
    ]);
    const message = res.rows[0].message;

    await client.end();

    response.json({ message });
  } catch (err) {
    console.log("GET /hello-pg failed", err.message);
    response.json({ message: `request failed` });
  }
});

GracefulShutdown(app);

http.createServer(app).listen(8080, "0.0.0.0", () => {
  console.log(`🚀 server running`);
});
