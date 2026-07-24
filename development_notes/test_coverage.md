# Test coverage

The public test suite currently reports 78 passing assertions with no failed assertion, warning, or skip.

GitHub Actions calculated overall line coverage of 90.29% in a clean Ubuntu R environment. File-level coverage ranged from 79.78% for plotting to 98.28% for classification. The workflow enforces a minimum overall coverage of 85% and uploads a plain-text summary artifact.

Local `covr::package_coverage()` remains unusable because its child R process terminates with Windows access-violation code `-1073741819` after successful test output. The clean CI result supersedes that local environment defect.

The first Codecov upload attempt was rate-limited with HTTP 429 even though coverage calculation succeeded. The package therefore uses a GitHub Actions status badge and stored summary artifact instead of presenting an unverified Codecov percentage badge.
