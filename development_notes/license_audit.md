# License audit

`DOMformulaR` is released under the MIT License. The package code is a clean R implementation based on documented methods and validation behavior. Original Matlab source, third-party manuscript text, article PDFs, vendor exports, and unpublished DXC data are not redistributed.

Runtime imports are `ggplot2` under MIT, `rlang` under MIT, and `yaml` under BSD-3-Clause. Suggested development dependencies include MIT-licensed packages and GPL-licensed `knitr` and `rmarkdown`; these are dependencies and are not vendored into the repository. Their use does not place copied dependency code in this package.

The package includes only simulated example data created for tests. No third-party dataset license is asserted. KEGG content is not bundled or queried; `join_pmd_kegg()` accepts a user-supplied, versioned mapping, and users remain responsible for its license.

The confirmed author and repository identity is `xiaowu20`, the maintainer email is `wlymusic@qq.com`, and the target repository is public at `https://github.com/xiaowu20/DOMformulaR`.
