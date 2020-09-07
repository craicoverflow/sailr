#!/bin/bash

COMMIT_MSG_SCRIPT=$1

# build ci docs feat fix perf refactor style test chore
allowed_commit_messages=("build: change build details" \
	"ci: make continuous integration change" \
    "docs: updates some documentation" \
	"feat: implements a new feature" \
	"fix: correct typo in function" \
	"perf: improve perf" \
    "refactor: implement a refactor" \
    "style: make a style change" \
    "test(ui): add a new test" \
    "chore: complete a simple chore" \
    "Revert \"test: add a new test\" " \
    "Revert: \"refactor(labels): implement a refactor\" " \
    "revert: \"feat: implements a new feature\" " \
    "Merge branch 'feature-branch'" \
    "merge branch 'Feature-Branch'" \
    "0.1.0")

disallowed_commit_messages=("implements a new feature" \
    "" \
    "docs: implements a new feature that we have been greatly anticipating")

TMPFILE=$(mktemp)
ERROR_FILE=$(mktemp)
COUNT=0
for allowed_commit_message in "${allowed_commit_messages[@]}"
do
    echo "$allowed_commit_message" > $TMPFILE
    $COMMIT_MSG_SCRIPT $TMPFILE
    # Track the number of failed tests
    if [[ "$?" != "0" ]]
    then
        COUNT=$(echo "$COUNT + 1" | bc -l)
        echo "---"
    fi
done

for disallowed_commit_message in "${disallowed_commit_messages[@]}"
do
    echo "$disallowed_commit_message" > $TMPFILE
    # Since it passed, there is no error to be seen.
    $COMMIT_MSG_SCRIPT $TMPFILE >> $TMPFILE
    # Track the number of failed tests
    if [[ "$?" == "0" ]]
    then
        echo -e "\e[1;32mFailed: $disallowed_commit_message\003\e[0m" >> $ERROR_FILE
        COUNT=$(echo "$COUNT + 1" | bc -l)
    fi
done

# Print summary of the number of failed tests
cat $ERROR_FILE
if [[ $COUNT -eq 0 ]]
then
    echo -e "\e[1;32m All tests passed!\033\e[0m"
elif [[ $COUNT -eq 1 ]]
then
    echo -e "\e[1;32m $COUNT test failed\033\e[0m"
elif [[ $COUNT -gt 1 ]]
then
    echo -e "\e[1;32m $COUNT tests failed\033\e[0m"
fi 

# Cleanup
rm $TMPFILE
rm $ERROR_FILE
