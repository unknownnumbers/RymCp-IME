# PDE英文詞與專名

本工程對20個一般詞及9個ASCII專名選定初始排序參數。規則為`max(原頻數或新增參照值1,000,000, 8,000,000)`；existence、reduction、critical、functional原值較高而保持。這些是初始權重，不是私人使用次數或從論文重算的詞頻。

一般詞為：elliptic、nonlinear、existence、multiplicity、asymptotic、asymptotics、reduction、bifurcation、variational、compactness、embedding、convergence、coercive、coercivity、nondegenerate、nondegeneracy、regularity、eigenvalue、critical、functional。其中asymptotics、coercivity、nondegenerate、nondegeneracy為新補詞形，其餘保留既有詞身份。

專名為：Sobolev、Laplacian、Fredholm、Banach、Hilbert、Dirichlet、Schauder、Lyapunov、Schmidt。code為ASCII小寫；Banach／Hilbert／Dirichlet／Schmidt重用既有小寫原生身份，另外五項新增規範顯示身份。這四項在case_forms不另登記ordinary形式，是本工程顯示選擇，不是語言上排除其他大小寫。

詞形及研究語境核對來源如下，只用以核對術語／專名，沒有抽取論文段落、語料或論文出現頻數：

- [Grigoryan，Math246B—Partial Differential Equations](https://web.math.ucsb.edu/~grigoryan/246B/lecs/246B.pdf)，2011。
- [Sørensen，Elliptic PDEs: Schauder theory](https://www.math.lmu.de/~sorensen/Lehre/SoSe2025/Schauder/schauder.php)，2025。
- [Moroz／Van Schaftingen，Choquard方程](https://arxiv.org/abs/1205.6286v2)。
- [Brändle／Colorado／de Pablo，fractional Laplacian](https://arxiv.org/abs/1006.4510v2)。
- [Gupta／Bizyaeva／Banavar，Lyapunov–Schmidt約化](https://arxiv.org/abs/2406.00066v2)。
- [Akahori等，基態非退化性](https://arxiv.org/abs/1801.08696v2)。

底層核心仍源自[SymSpell固定成品及Google Books／SCOWL](english-core-sources.md)，Ice擴展沿[原GPL與來源](english-extensions-sources.md)。字典、vocabulary、別名資料及索引同步更新，不合併私人學習資料。
