##  ALIAS2SYMBOL.R

alias2Symbol <- function(alias,species="Hs",expand.symbols=FALSE)
#  Convert a set of alias names to official gene symbols
#  via Entrez Gene identifiers
#  Di Wu, Gordon Smyth and Yifang Hu
#  4 Sep 2008. Last revised 23 June 2016.
{
	alias <- as.character(alias)

#	Get access to required annotation functions
	suppressPackageStartupMessages(OK <- requireNamespace("AnnotationDbi",quietly=TRUE))
	if(!OK) stop("AnnotationDbi package required but not installed (or can't be loaded)")

#	Load appropriate organism package
	orgPkg <- paste0("org.",species,".eg.db")
	suppressPackageStartupMessages(OK <- requireNamespace(orgPkg,quietly=TRUE))
	if(!OK) stop(orgPkg," package required but not not installed (or can't be loaded)")

#	Get alias to Entrez Gene mappings
	obj <- paste0("org.",species,".egALIAS2EG")
	egALIAS2EG <- tryCatch(getFromNamespace(obj,orgPkg), error=function(e) FALSE)
	if(is.logical(egALIAS2EG)) stop("Can't find alias mappings in package ",orgPkg)

#	Get symbol to Entrez Gene mappings
	obj <- paste0("org.",species,".egSYMBOL")
	egSYMBOL <- tryCatch(getFromNamespace(obj,orgPkg), error=function(e) FALSE)
	if(is.logical(egSYMBOL)) stop("Can't find symbol mappings in package ",orgPkg)

	if(expand.symbols) {
		alias <- intersect(alias,AnnotationDbi::Rkeys(egALIAS2EG))
		eg <- AnnotationDbi::mappedLkeys(egALIAS2EG[alias])
		AnnotationDbi::mappedRkeys(egSYMBOL[eg])
	} else {
		isSymbol <- alias %in% AnnotationDbi::Rkeys(egSYMBOL) 
		alias2 <- intersect(alias[!isSymbol],AnnotationDbi::Rkeys(egALIAS2EG))
		eg <- AnnotationDbi::mappedLkeys(egALIAS2EG[alias2])
		c(alias[isSymbol],AnnotationDbi::mappedRkeys(egSYMBOL[eg]))
	}
}

alias2SymbolTable <- function(alias,species="Hs")
#  Convert a vector of alias names to the vector of corresponding official gene symbols
#  via Entrez Gene identifiers
#  Di Wu, Gordon Smyth and Yifang Hu
#  Created 3 Sep 2009.  Last modified 23 April 2016.
{
	alias <- as.character(alias)

#	Get access to required annotation functions
	suppressPackageStartupMessages(OK <- requireNamespace("AnnotationDbi",quietly=TRUE))
	if(!OK) stop("AnnotationDbi package required but not installed (or can't be loaded)")

#	Load appropriate organism package
	orgPkg <- paste0("org.",species,".eg.db")
	suppressPackageStartupMessages(OK <- requireNamespace(orgPkg,quietly=TRUE))
	if(!OK) stop(orgPkg," package required but not not installed (or can't be loaded)")

#	Get alias to Entrez Gene mappings
	obj <- paste0("org.",species,".egALIAS2EG")
	egALIAS2EG <- tryCatch(getFromNamespace(obj,orgPkg), error=function(e) FALSE)
	if(is.logical(egALIAS2EG)) stop("Can't find alias mappings in package ",orgPkg)

#	Get symbol to Entrez Gene mappings
	obj <- paste0("org.",species,".egSYMBOL")
	egSYMBOL <- tryCatch(getFromNamespace(obj,orgPkg), error=function(e) FALSE)
	if(is.logical(egSYMBOL)) stop("Can't find symbol mappings in package ",orgPkg)

#	Output vector same length as input
	Symbol <- alias

#	Check which aliases are already symbols
	isSymbol <- alias %in% AnnotationDbi::Rkeys(egSYMBOL)
	Symbol[!isSymbol] <- NA

#	Now deal with rest
	OtherAliases <- alias[!isSymbol]
	isAlias <- OtherAliases %in% AnnotationDbi::Rkeys(egALIAS2EG)
	if(!any(isAlias)) return(Symbol)
	OtherAliases <- OtherAliases[isAlias]
	AliasTbl <- AnnotationDbi::toTable(egALIAS2EG[OtherAliases])
	if(anyDuplicated(AliasTbl$alias_symbol)) warning("Multiple symbols ignored for one or more aliases")
	SymbolTbl <- AnnotationDbi::toTable(egSYMBOL[AliasTbl$gene_id])
	m <- match(OtherAliases,AliasTbl$alias_symbol)
	GeneID <- AliasTbl$gene_id[m]
	m <- match(GeneID,SymbolTbl$gene_id)
	Symbol[!isSymbol][isAlias] <- SymbolTbl$symbol[m]

	Symbol
}
