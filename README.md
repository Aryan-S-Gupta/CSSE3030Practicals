# CSSE3030 Practical Resources

## Part 3: Randoop & Java PathFinder

`Roots.java` is the class under test for both tools.

### Randoop

Download `randoop-all-<version>.jar` from the
[Randoop releases page](https://github.com/randoop/randoop/releases) and follow
the steps in the practical handout. Any JDK 8+ works.

### Java PathFinder (Symbolic PathFinder)

jpf-core and jpf-symbc are pre-built and committed under `jpf/`, so no cloning
or building is required. The only thing you need to install yourself is
**JDK 8** (JPF's own VM model requires it specifically — newer JDKs won't work):

```
winget install --id EclipseAdoptium.Temurin.8.JDK
```

Then, from the repo root:

1. Add a `main` method to your `Roots.java` so JPF has an entry point:
   ```java
   public static void main(String[] args) {
       numRoots(0, 0, 0);
   }
   ```
   (The concrete values don't matter — SPF overrides them symbolically.)
2. Compile with debug info: `javac -g Roots.java`
3. Create a `Roots.jpf` in the same directory as `Roots.java`
   ```
   target = Roots
   classpath = .
   symbolic.method = Roots.numRoots(sym#sym#sym)
   listener = gov.nasa.jpf.symbc.SymbolicListener
   search.multiple_errors = true
   symbolic.dp = z3
   ```
4. Run it: `.\run-jpf.bat Roots.jpf`

`run-jpf.bat` auto-detects JDK 8 (if installed via the winget command above,
or already on `JAVA_HOME`), wires up `jpf-core`/`jpf-symbc` regardless of
where the repo was cloned to, and puts the bundled Z3 solver library on
`PATH`.
