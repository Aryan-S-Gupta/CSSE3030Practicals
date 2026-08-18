# CSSE3030 Practical Resources

## Week 4 on Apple Silicon macOS

If you have not cloned the repository yet:

```sh
git clone --branch mac-test https://github.com/mferr11/CSSE3030Practicals.git
cd CSSE3030Practicals
```

From the repository root, install the required tools locally:

```sh
./setup-week4-macos.sh
```

Run Randoop:

```sh
mkdir -p week4-results/randoop
.week4-tools/amazon-corretto-8.jdk/Contents/Home/bin/javac Roots.java
.week4-tools/amazon-corretto-8.jdk/Contents/Home/bin/java \
  -classpath ".:.week4-tools/randoop-all-4.3.4.jar" \
  randoop.main.Main gentests \
  --testclass=Roots \
  --time-limit=30 \
  --unchecked-exception=ERROR \
  --junit-output-dir=week4-results/randoop
```

Run Symbolic PathFinder:

```sh
./run-jpf-macos.sh
```

Symbolic PathFinder should report five paths, including an
`ArithmeticException: div by 0` for `Roots.numRoots(0, 0, 0)`. Randoop's test
counts may vary between runs.
