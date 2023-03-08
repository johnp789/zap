# ⚡blazingly slow⚡

I tried out a few more popular frameworks, FastAPI+Uvicorn for Python and
Express for Node.js.  They weren't blazingly fast, but at least FastAPI with
uvloop was several times faster than the built-in Python HTTP server.

Updated March 8, 2023: adding bun.  Results for bun are widely varying,
from 174k req/s to 270k req/s.

## FastAPI code
```python
from fastapi import FastAPI, Response

app = FastAPI()

RESPONSE = Response(content="Hi from FastAPI!", media_type="text/plain")

@app.get("/")
async def root() -> Response:
    return RESPONSE
```

## Express code
```javascript
const express = require('express')
const app = express()
const port = 8080

app.get('/', (req, res) => {
  res.send('Hi from Express!')
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
```

## Bun code
```javascript
export default {
    port: 8080,
    fetch(request) {
        return new Response("Hello from Bun!");
    },
};
```

## wrk output

wrk debian/4.1.0-3build1 [epoll] Copyright (C) 2012 Will Glozer
```
$ wrk/measure.sh python
Server started http://127.0.0.1:8080
========================================================================
                          python
========================================================================
Running 10s test @ http://127.0.0.1:8080
  4 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    16.85ms  114.53ms   1.69s    96.81%
    Req/Sec     1.69k     1.98k    8.26k    82.22%
  Latency Distribution
     50%  204.00us
     75%  309.00us
     90%  335.00us
     99%  616.16ms
  49670 requests in 10.06s, 6.35MB read
  Socket errors: connect 0, read 49670, write 0, timeout 31
Requests/sec:   4939.62
Transfer/sec:    646.40KB
----------------------------------------
Exception occurred during processing of request from ('127.0.0.1', 48728)
$ wrk/measure.sh python
Server started http://127.0.0.1:8080
========================================================================
                          python
========================================================================
Running 10s test @ http://127.0.0.1:8080
  4 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     2.27ms   38.58ms   1.76s    99.51%
    Req/Sec     2.52k     2.44k    8.49k    56.28%
  Latency Distribution
     50%  204.00us
     75%  316.00us
     90%  326.00us
     99%  491.00us
  49730 requests in 10.04s, 6.36MB read
  Socket errors: connect 0, read 49730, write 0, timeout 12
Requests/sec:   4952.13
Transfer/sec:    648.03KB
$ wrk/measure.sh zig
Listening on 0.0.0.0:3000
========================================================================
                          zig
========================================================================
Running 10s test @ http://127.0.0.1:3000
  4 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   418.40us   95.06us   1.41ms   72.24%
    Req/Sec   198.65k    13.16k  247.84k    69.00%
  Latency Distribution
     50%  427.00us
     75%  481.00us
     90%  529.00us
     99%  617.00us
  7905567 requests in 10.07s, 1.17GB read
Requests/sec: 785329.16
Transfer/sec:    119.08MB
$ wrk/measure.sh zig
Listening on 0.0.0.0:3000
========================================================================
                          zig
========================================================================
Running 10s test @ http://127.0.0.1:3000
  4 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   424.51us  107.59us   2.47ms   78.18%
    Req/Sec   196.44k    17.55k  232.70k    82.75%
  Latency Distribution
     50%  426.00us
     75%  481.00us
     90%  533.00us
     99%  811.00us
  7820220 requests in 10.07s, 1.16GB read
Requests/sec: 776294.11
Transfer/sec:    117.71MB
$ wrk/measure.sh go
listening on 0.0.0.0:8090
========================================================================
                          go
========================================================================
Running 10s test @ http://127.0.0.1:8090/hello
  4 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   505.72us  550.16us  14.71ms   88.36%
    Req/Sec   152.73k     4.28k  161.25k    83.25%
  Latency Distribution
     50%  300.00us
     75%  464.00us
     90%    1.22ms
     99%    2.67ms
  6080550 requests in 10.08s, 777.05MB read
Requests/sec: 603257.41
Transfer/sec:     77.09MB
$ wrk/measure.sh go
listening on 0.0.0.0:8090
========================================================================
                          go
========================================================================
Running 10s test @ http://127.0.0.1:8090/hello
  4 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   512.43us  575.05us  16.25ms   88.52%
    Req/Sec   152.27k     5.18k  160.43k    80.30%
  Latency Distribution
     50%  300.00us
     75%  481.00us
     90%    1.23ms
     99%    2.71ms
  5999221 requests in 10.02s, 766.65MB read
Requests/sec: 598698.18
Transfer/sec:     76.51MB
$ wrk/measure.sh fastapi
========================================================================
                          fastapi
========================================================================
Running 10s test @ http://127.0.0.1:8080
  4 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     4.33ms    1.16ms  18.61ms   87.14%
    Req/Sec    23.24k     1.39k   25.50k    72.00%
  Latency Distribution
     50%    4.16ms
     75%    4.41ms
     90%    5.08ms
     99%    8.74ms
  924978 requests in 10.06s, 132.32MB read
Requests/sec:  91936.47
Transfer/sec:     13.15MB
$ wrk/measure.sh fastapi
========================================================================
                          fastapi
========================================================================
Running 10s test @ http://127.0.0.1:8080
  4 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     4.42ms    1.38ms  21.38ms   87.43%
    Req/Sec    22.87k     1.43k   26.24k    67.25%
  Latency Distribution
     50%    4.02ms
     75%    5.10ms
     90%    5.84ms
     99%   10.25ms
  910268 requests in 10.09s, 130.21MB read
Requests/sec:  90182.16
Transfer/sec:     12.90MB
$ wrk/measure.sh express
Example app listening on port 8080
========================================================================
                          express
========================================================================
Running 10s test @ http://127.0.0.1:8080
  4 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    42.08ms    3.62ms  80.12ms   93.10%
    Req/Sec     2.38k   192.65     2.73k    86.75%
  Latency Distribution
     50%   41.30ms
     75%   42.59ms
     90%   44.54ms
     99%   60.52ms
  94880 requests in 10.07s, 22.08MB read
Requests/sec:   9421.40
Transfer/sec:      2.19MB
$ wrk/measure.sh express
Example app listening on port 8080
========================================================================
                          express
========================================================================
Running 10s test @ http://127.0.0.1:8080
  4 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    41.52ms    4.74ms 133.44ms   95.74%
    Req/Sec     2.42k   319.41     3.03k    70.00%
  Latency Distribution
     50%   40.80ms
     75%   41.70ms
     90%   43.16ms
     99%   61.22ms
  96393 requests in 10.08s, 22.43MB read
Requests/sec:   9564.82
Transfer/sec:      2.23MB
$ wrk/measure.sh bun
========================================================================
                          bun
========================================================================
Running 10s test @ http://127.0.0.1:8080
  4 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     2.00ms    1.10ms  34.59ms   98.67%
    Req/Sec    51.28k     5.29k   59.13k    65.00%
  Latency Distribution
     50%    1.82ms
     75%    2.12ms
     90%    2.38ms
     99%    3.23ms
  2040171 requests in 10.05s, 254.88MB read
Requests/sec: 203006.65
Transfer/sec:     25.36MB
$ wrk/measure.sh bun
========================================================================
                          bun
========================================================================
Running 10s test @ http://127.0.0.1:8080
  4 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.76ms  362.14us   5.97ms   77.40%
    Req/Sec    56.95k     4.64k   68.64k    68.75%
  Latency Distribution
     50%    1.63ms
     75%    1.93ms
     90%    2.35ms
     99%    2.90ms
  2266866 requests in 10.06s, 283.20MB read
Requests/sec: 225342.72
Transfer/sec:     28.15MB
```

## test machine

```
CPU: AMD Ryzen 9 5900X 12-Core Processor
Memory: 29GiB/31GiB
Kernel: 5.15.79.1-microsoft-standard-WSL2
$ go version
go version go1.18.1 linux/amd64$ node --version
v19.7.0
$ python --version
Python 3.10.6
$ zig version
0.11.0-dev.1862+e7f128c20
```
