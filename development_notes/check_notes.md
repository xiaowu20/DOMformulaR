# Check notes

Current source-level tests report 78 passes, 0 failures, 0 warnings, and 0 skips. Lintr reports no lints under the repository configuration.

The Windows package library contains compiled packages whose DLLs terminate R with access-violation code `-1073741819` after otherwise successful execution. A minimal `library(rlang)` reproduces the process-level crash under installed R 4.5.0, 4.5.1, 4.5.2, and 4.5.3. Rebuilding `rlang` from source also fails during its temporary-location load test. This is an external local R-library/runtime defect, not a failed package assertion.

An R CMD check of a tarball built without vignettes completed static source, namespace, dependency, installation, load, unload, documentation, and mismatch checks. Its actionable package findings were an unused unavailable `vdiffr` suggestion, an old-style `citEntry()`, an invalid LaRowe DOI, a duplicate top-level `CITATION`, unqualified `ave`, an undeclared `.data` pronoun, and missing prebuilt vignettes. The source-level findings have been corrected. The example and test phases both finish their expected work but are marked as errors when the child process crashes at shutdown. Owner placeholder URLs still return 404 and cannot be corrected without the target GitHub account. Full vignette build and a final clean R CMD check must be rerun in a clean R library or GitHub Actions.

Clean GitHub Actions environments passed R CMD check on Windows R release, macOS R release, Ubuntu R release, and Ubuntu R oldrel, together with lint, pkgdown, and coverage checks. R devel remained in dependency installation and had not reached package checking at the release decision point. This is recorded as pending rather than misreported as passed or failed.
