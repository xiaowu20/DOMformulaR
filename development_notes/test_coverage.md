# Test coverage

The public test suite currently reports 78 passing assertions with no failed assertion, warning, or skip.

Numeric line coverage is not reported as complete. `covr::package_coverage()` installs the package and runs all 78 assertions, but its child R process terminates with Windows access-violation code `-1073741819` after the successful test output. Covr therefore correctly treats the child process as failed and does not calculate a percentage.

This defect is reproducible by loading the installed `rlang` DLL in an otherwise minimal R session and affects all four locally installed R 4.5.x runtimes. It is not acceptable to invent a coverage percentage from the passing assertion count.

The GitHub Actions coverage workflow is configured to run in a clean Ubuntu R environment. Its result must be reviewed after the repository exists. A release should not advertise a Codecov badge until that workflow succeeds.
