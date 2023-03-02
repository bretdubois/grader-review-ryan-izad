CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'
OUTPUT_FILE='junit_output.txt'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cp TestListExamples.java student-submission

cd student-submission
if [ -f "ListExamples.java" ]
then
    echo "ListExamples.java file present"
else
    set -e
    echo "Could not find ListExamples.java"
    exit 1
fi

javac -cp $CPATH *.java

if [ $? -eq 0 ]
then
    echo "Java files compiled successfully"
else
    set -e
    echo "Failed to compile"
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > $OUTPUT_FILE

TEST_OK=$(grep 'OK' $OUTPUT_FILE)

if [ -n "$TEST_OK" ]; then
    GRADE=100
    echo "GRADE: $GRADE"
    exit 0
else
    GRADE=0
    echo "GRADE: $GRADE"
    exit 0
fi
