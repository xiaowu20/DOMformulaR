# Method validation and known limits

The package implementation was cross-checked against an independently
implemented Matlab workflow using a local DXC peak table. The public
repository does not contain the real peak table, Matlab workbooks, or
publisher PDFs.

The audited legacy workflow produced 850 CHONPS assignments. The
corrected, candidate-preserving Matlab and R implementations produced
719 assignments from calibrated m/z; all 719 formulae and formula-level
metrics agreed between the two independent implementations. Of the
legacy assignments, 686 m/z values aligned within 0.01 ppm, 660
normalized formulae agreed, and 26 differed. Differences were
attributable to explicit ion-mass conversion, chemical filters, ranking,
and legacy implementation defects.

These results validate implementation consistency for the tested data.
They do not validate formulae as structures or establish performance for
other instruments, positive ions, multiple charges, or other element
systems.
