# CSSE3030 Week 4 on macOS

This repository contains the Week 4 Part 3 exercise: run Randoop and Symbolic
PathFinder against the faulty `Roots.numRoots` method. The setup below works on
Apple Silicon and does not change the system-wide Java version.

The data-flow and hand-worked symbolic execution questions in Parts 1 and 2 are
completed on the tutor sheet. This repository supplies the automated Part 3.

## Expected result

Both tools should find the same fault:

```text
Roots.numRoots(0, 0, c)
```

For any integer `c`, `a = 0` and `b = 0` make the discriminant zero and the
method divide by `2*a`, which is zero.

Symbolic PathFinder should report exactly five method summaries. Randoop's test
counts vary because its search is random and stops after 30 seconds.

## 1. Download the three tools

Run these commands from the repository root:

```sh
cd /Users/aryansg/IdeaProjects/CSSE3030Practicals

W4_TOOLS="$PWD/.week4-tools"
mkdir -p "$W4_TOOLS"

curl -fL https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-macos-jdk.tar.gz \
  -o "$W4_TOOLS/corretto8.tar.gz"
tar -xzf "$W4_TOOLS/corretto8.tar.gz" -C "$W4_TOOLS"

curl -fL https://github.com/Z3Prover/z3/releases/download/z3-5.1.0/z3-5.1.0-arm64-osx-13.3.zip \
  -o "$W4_TOOLS/z3.zip"
unzip -q -o "$W4_TOOLS/z3.zip" -d "$W4_TOOLS"

curl -fL https://github.com/randoop/randoop/releases/download/v4.3.4/randoop-all-4.3.4.jar \
  -o "$W4_TOOLS/randoop-all-4.3.4.jar"
```

The `.week4-tools` directory is ignored by Git.

## 2. Run Randoop

```sh
cd /Users/aryansg/IdeaProjects/CSSE3030Practicals
W4_TOOLS="$PWD/.week4-tools"

mkdir -p week4-results/randoop
javac Roots.java
java -classpath ".:$W4_TOOLS/randoop-all-4.3.4.jar" \
  randoop.main.Main gentests \
  --testclass=Roots \
  --time-limit=30 \
  --unchecked-exception=ERROR \
  --junit-output-dir=week4-results/randoop \
  2>&1 | tee week4-results/randoop/randoop-console.txt
```

Check the result:

```sh
grep -E 'Error-revealing test count|Regression test count' \
  week4-results/randoop/randoop-console.txt
grep -n 'Roots.numRoots(0, 0,' week4-results/randoop/ErrorTest0.java | head
```

Expected observations:

- `ErrorTest0.java` is created.
- It contains calls with `a = 0` and `b = 0`.
- Those calls are labelled as throwing `ArithmeticException`.
- Exact regression/error counts differ between runs.

## 3. Run Symbolic PathFinder

`RootsDriver.java` gives JPF an entry point without changing `Roots.java`.
`Roots.jpf` makes the three `numRoots` parameters symbolic and selects Z3 for
the nonlinear discriminant expression.

```sh
cd /Users/aryansg/IdeaProjects/CSSE3030Practicals
./run-jpf-macos.sh 2>&1 | tee week4-results/jpf-console.txt
```

The launcher:

- verifies that `JAVA8_HOME` really contains JDK 8;
- fixes the downloaded Z3 library's local macOS lookup path when necessary;
- creates a temporary JPF `site.properties` file;
- compiles with `javac -g`; and
- runs the committed JPF/SPF Java artifacts with the macOS Z3 library.

Expected output:

```text
Roots.numRoots(-1,2147483647,2147483647)  --> Return Value: 2
Roots.numRoots(0,-1,0)                    --> Return Value: 0
Roots.numRoots(-1,0,0)                    --> Return Value: 1
Roots.numRoots(0,0,0)                     --> ArithmeticException: div by 0
Roots.numRoots(2147483647,-4,2147483647)  --> Return Value: 0
```

The particular witnesses can vary with solver versions, but there should be
five paths and the exception witness should reduce to `a = 0, b = 0`.

## 4. Fill in the practical table

| Question | Randoop | Symbolic PathFinder |
|---|---|---|
| Tests/paths reported | Record the two counts printed by your run; they vary | 5 distinct paths |
| Fault found? | Yes | Yes |
| Fault-triggering input | `a = 0, b = 0`, any `c` | `a = 0, b = 0`, any `c`; witness `(0,0,0)` |

For the reflection question: Symbolic PathFinder can solve a constraint such as
`a = 37` and `b = -104`, so it should find that special input if the path is
feasible. Default Randoop is unlikely to guess both values because they are not
in its small primitive seed pool.

## Troubleshooting

- `Set JAVA8_HOME`: check that the path ends in `Contents/Home` and run
  `"$JAVA8_HOME/bin/java" -version`; it must print `1.8.0`.
- `Set Z3_HOME`: use the extracted Z3 `bin` directory containing both
  `libz3.dylib` and `libz3java.dylib`.
- `ERROR: you need to turn debug option on`: use `run-jpf-macos.sh`; it compiles
  with `-g` automatically.
- The warning about `jpf-core/build/examples` is harmless for this exercise.
