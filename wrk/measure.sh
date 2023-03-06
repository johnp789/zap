#! /usr/bin/env bash
THREADS=4
CONNECTIONS=400
DURATION_SECONDS=10

SUBJECT=$1


if [ "$SUBJECT" = "" ] ; then
    echo "usage: $0 subject    # subject: zig or go"
    exit 1
fi

if [ "$SUBJECT" = "zig" ] ; then
    zig build wrk > /dev/null
    ./zig-out/bin/wrk &
    PID=$!
    URL=http://127.0.0.1:3000
fi

if [ "$SUBJECT" = "go" ] ; then
    cd wrk/go && go build main.go 
    ./main &
    PID=$!
    URL=http://127.0.0.1:8090/hello
fi

if [ "$SUBJECT" = "python" ] ; then
    python wrk/python/main.py &
    PID=$!
    URL=http://127.0.0.1:8080
fi

if [ "$SUBJECT" = "fastapi" ] ; then
    cd wrk/fastapi
    ./venv/bin/uvicorn --log-level error --no-access-log --workers 4 --loop uvloop --port 8080 fastapi_demo:app &
    PID=$!
    URL=http://127.0.0.1:8080
fi

if [ "$SUBJECT" = "express" ] ; then
    cd wrk/express
    node index.js &
    PID=$!
    URL=http://127.0.0.1:8080
fi

if [ "$SUBJECT" = "rust" ] ; then
    cd wrk/rust/hello && cargo build --release
    ./target/release/hello &
    PID=$!
    URL=http://127.0.0.1:7878
fi

sleep 1
echo "========================================================================"
echo "                          $SUBJECT"
echo "========================================================================"
wrk -c $CONNECTIONS -t $THREADS -d $DURATION_SECONDS --latency $URL 

kill $PID

