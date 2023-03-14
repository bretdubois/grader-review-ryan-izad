# Set CPATH using OS type
if [[ $(uname) == "Darwin" ]]; then
    CPATH='.:..lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'
else
    CPATH='.;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar'
fi

# Save JUnit output to txt file
OUTPUT_FILE='junit_output.txt'

# Remove previous student-submission and clone new submission
rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

# Copy file and check if successful
cp TestListExamples.java student-submission

cd student-submission
if [ -f "ListExamples.java" ]
then
    echo "ListExamples.java file present"
else
    set -e
    echo "Could not find ListExamples.java, check file name"
    exit 1
fi

# Compile java files and check for compile errors
javac -cp $CPATH *.java
if [ $? -eq 0 ]
then
    echo "Java files compiled successfully"
else
    set -e
    echo "Failed to compile"
    exit 1
fi

# Run JUnit tests and output results
# Calculate letter grade from output file
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > $OUTPUT_FILE
if grep -q "FAILURES" $OUTPUT_FILE; then
    cat $OUTPUT_FILE
    TESTS=$(grep 'Tests run' $OUTPUT_FILE)
    IFS=", " read -a TESTLINE <<< $TESTS

    TOTAL="${TESTLINE[2]}"
    FAILS="${TESTLINE[4]}"
    PASSES=$((TOTAL - FAILS))

    if [[ $PASSES -eq $TOTAL ]]; then
        LETTER="A+"
    elif [[ $PASSES -gt $((TOTAL / 2)) ]]; then
        LETTER="A"
    elif [[ $PASSES -gt $((TOTAL / 5)) ]]; then
        LETTER="B"
    elif [[ $PASSES -gt $((TOTAL / 10)) ]]; then
        LETTER="C"
    elif [[ $PASSES -gt 0 ]]; then
        LETTER="D"
    else
        LETTER="F"
    fi

    GRADE=$(( PASSES * 100 / TOTAL ))
    echo "$GRADE" "$LETTER"
    exit 0
else
    echo "All passing - A+"
    exit 0
fi
