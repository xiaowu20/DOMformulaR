# Formula assignment rules

Version 0.1.0 searches neutral molecular formulae containing exactly C, H, O, N, P, and S. The ion model is singly charged negative-ion `[M-H]-`; neutral mass equals observed or calibrated ion mass plus the proton mass stored in the configuration.

The default inclusive atom ranges are C 4–50, H 0–120, O 1–57, N 0–5, P 0–1, and S 0–3. The default mass tolerance is 0.75 ppm. Defaults are project parameters retained for reproducibility, not universal FT-ICR-MS settings.

Candidates must satisfy the configured H/C, O/C, N/C, P/C, and S/C ranges; DBE must be non-negative and integer when that option is enabled; DBE minus O must lie in its configured interval; and N+P+S must not exceed the configured maximum. The nominal-valence screen requires an even valence sum and a sufficient total valence. The nitrogen rule compares nominal-mass parity with nitrogen-count parity.

The exact ppm condition is

\[
\left|\frac{m_{\mathrm{obs}}-m_{\mathrm{theory}}}{m_{\mathrm{theory}}}\right|10^6 \leq \epsilon.
\]

The candidate search therefore uses the mathematically equivalent inclusive theoretical-mass interval \(m_{\mathrm{obs}}/(1+\epsilon 10^{-6})\) to \(m_{\mathrm{obs}}/(1-\epsilon 10^{-6})\). This avoids excluding candidates exactly on the negative ppm boundary.

Candidate ranking is deterministic. The score combines absolute mass error, N+P+S count, and P+S count with explicit weights. A ranked candidate is not a probability or structural identification. Alternative candidates are retained, and peaks exceeding the configured candidate-count limit are marked `ambiguous_excess`.
