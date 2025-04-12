#!/bin/bash

failed=false

mkdir -p results

DB="postgresql://postgres:pass@localhost:4116/postgres"

for problem in sql/*; do
    printf "$problem "
    problem_id=$(basename ${problem%.sql})
    result="results/$problem_id.out"
    expected="expected/$problem_id.out"
    psql "$DB" < $problem > $result 2> /dev/null
    DIFF=$(diff -B $expected $result)
    if [ -z "$DIFF" ]; then
        echo pass
    else
        echo fail
        failed=true
    fi
done

if [ "$failed" = "true" ]; then
    exit 2
fi

