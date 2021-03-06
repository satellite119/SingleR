#' Combining results from different references
#'
#' It is often desirable to combine information from separate references,
#' thus improving the quality and breadth of the cell type annotation.
#' However, it is not trivial due to the presence of batch effects across references 
#' (from differences in technology, experimental protocol or the biological system)
#' as well as differences in the annotation vocabulary between investigators.
#' This page describes some of the considerations with choosing a strategy
#' to combine information from multiple reference datasets.
#'
#' @section Option 1 - using reference-specific labels:
#' This option nests each label within each reference data, (e.g., \dQuote{Ref1-Bcell} vs \dQuote{Ref2-Bcell}).
#' It is most applicable if there are relevant biological differences between the references,
#' e.g., one reference is concerned with healthy tissue while the other reference considers diseased tissue.
#'
#' In practical terms, this option is easily implemented by just \code{cbind}ing the expression matrices together 
#' and \code{paste}ing the reference name onto the corresponding character vector of labels. 
#' There is no need for time-consuming label harmonization between references.
#'
#' However, the fact that we are comparing across references means that the marker set is likely to contain genes responsible for uninteresting batch effects. 
#' This will increase noise during the calculation of the score in each reference, possibly leading to a loss of precision and a greater risk of technical variation dominating the classification results.
#'
#' @section Option 2 - using harmonized labels:
#' This option also involves combining the reference datasets into a single matrix but with harmonization of the labels so that the same cell type is given the same label across references. 
#' This would allow feature selection methods to identify robust sets of label-specific markers that are more likely to generalize to other datasets. 
#' It would also simplify interpretation, as there is no need to worry about the reference from which the labels came.
#'
#' The most obvious problem with this approach is that it assumes that harmonized labels are available.
#' This is not always the case due to differences in naming schemes (e.g. \code{"B cell"} vs \code{"B"}) between references.
#' Another problem is that of differences in label resolution across references (e.g., how to harmonize \code{"B cell"} to another reference that splits to \code{"naive B cell"} and \code{"mature B cell"}).
#'
#' To mitigate this, \pkg{SingleR} datasets (e.g., \code{\link{ImmGenData}}) have all their labels mapped to the Cell Ontology,
#' allowing the use of standard terms to refer to the same cell type across references.
#' Users can then traverse the ontology graph to achieve a consistent label resolution across references.
#'
#' @section Option 3 - comparing scores across the union of markers:
#' This option involves performing classification separately within each reference, then collating the results to choose the label with the highest score across references. 
#' This is a relatively expedient approach that avoids the need for explicit harmonization while also reduces the potential for reference-specific markers.
#' It is also logistically simpler as it allows each reference to be processed separately (more or less, depending on the exact algorithm) for embarrassing parallelization.
#'
#' It leaves a mixture of labels in the final results that is up to the user to resolve, though perhaps this may be considered a feature as it smoothly handles differences in resolution between references, e.g., a cell that cannot be resolved as a CD4+ or CD8+ T cell may simply fall back to \code{"T cell"}.
#' It will also be somewhat suboptimal if there are many reference-specific labels, as markers are not identified with the aim of distinguishing a label in one reference from another label in another reference.
#'
#' @author Aaron Lun
#' @name combine-predictions
#' @seealso
#' \code{\link{combineCommonResults}} and \code{\link{combineRecomputedResults}},
#' for the functions that implement variants of Option 3.
#'
#' \code{\link{matchReferences}}, to harmonize labels between reference datasets.
NULL
