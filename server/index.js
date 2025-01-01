const http = require("http");

/**
 * Set up different use-case endpoints and load test
 * them to see where bottlenecks occur and how to fix them.
 *
 * Use cases:
 * 1. simple server response
 * 2. server response with a delay
 * 3. server response with a CPU intensive task
 * 4. read from DB and return response
 * 5. write to DB and return response
 */

const server = http.createServer((req, res) => {
  const hostContainerId = process.env.HOSTNAME || "Unknown";
  const response = { hostContainerId };

  if (req.url === "/") {
    response.msg = "Welcome to the homepage!";

    res.end(JSON.stringify(response));
  } else if (req.url === "/delay") {
    response.msg = "Welcome to the delayed homepage!";

    setTimeout(() => {
      res.end(response.toString());
    }, 3000);
  } else if (req.url === "/cpu-intensive") {
    const start = Date.now();
    const result = heavyComputation();
    console.log(`CPU intensive task took: ${Date.now() - start}ms`);

    response.msg = `Result of CPU intensive task is: ${result}`;

    res.end(response.toString());
  } else {
    response.msg = "Page not found";

    res.end(response.toString());
  }
});

server.listen(3000, () => {
  console.log("Server is listening on port 3000");
});

// Simulate arbitrary, heavy computation
function heavyComputation() {
  let result = 0;

  // random number between 1M - 20M
  const iterations = Math.floor(Math.random() * 20000000) + 1000000;

  for (let i = 0; i < iterations; i++) {
    result += Math.sin(i) * Math.cos(i) * Math.tan(i);
  }

  return result;
}
