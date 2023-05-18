# Author: Pascual Villalba-Bermell

## CONDA ENVIRONMENT
#conda source r4-base

## LIBRARIES
library(DMRcaller) #BiocManager::install(DMRcaller)

## VARIABLES
CX_path = "/storage/ncRNA/Projects/CUCUMBER_HSVd/Methylome/Results/01-Bismark/CX_reports/"
times = c("1", "2", "3")

## PIPELINE

setwd(CX_path)

for (i in times) {
  
  ## 1-READING CX REPORTS COMING FROM BISMARK
  
  time = paste0('D22_', i)
  list_of_files = list.files(".")[grepl(x = list.files("."), pattern = time)]
  
  HSVd_files = list_of_files[1:3] 
  mock_files = list_of_files[4:6]
  
  metData_HSVd = readBismarkPool(HSVd_files)
  metData_mock = readBismarkPool(mock_files)
  
  metDataList = GRangesList("HSVd" = metData_HSVd, "mock" = metData_mock)
  
  ## 2-CALLING DMRS
  
  DMRsBinsCG = computeDMRs(metDataList[["mock"]],
                           metDataList[["HSVd"]],
                           regions = NULL,
                           context = "CG",
                           method = "bins",
                           binSize = 50,
                           test = "fisher",
                           pValueThreshold = 0.05,
                           minCytosinesCount = 3,
                           minProportionDifference = 0.15,
                           minGap = 300,
                           minSize = 50,
                           minReadsPerCytosine = 8,
                           cores = 40)
  
  DMRsBinsCHG = computeDMRs(metDataList[["mock"]],
                            metDataList[["HSVd"]],
                            regions = NULL,
                            context = "CHG",
                            method = "bins",
                            binSize = 50,
                            test = "fisher",
                            pValueThreshold = 0.05,
                            minCytosinesCount = 3,
                            minProportionDifference = 0.15,
                            minGap = 300,
                            minSize = 50,
                            minReadsPerCytosine = 8,
                            cores = 40)
  
  DMRsBinsCHH = computeDMRs(metDataList[["mock"]], 
                            metDataList[["HSVd"]],
                            regions = NULL,
                            context = "CHH",
                            method = "bins",
                            binSize = 50,
                            test = "fisher",
                            pValueThreshold = 0.05,
                            minCytosinesCount = 3,
                            minProportionDifference = 0.15,
                            minGap = 300,
                            minSize = 50,
                            minReadsPerCytosine = 8,
                            cores = 40)
  
  ## 3-MERGING DMRS
  
  DMRsBinsCGMerged = mergeDMRsIteratively(DMRsBinsCG,
                                          minGap = 200,
                                          respectSigns = TRUE,
                                          metDataList[["mock"]],
                                          metDataList[["HSVd"]],
                                          context = "CG",
                                          minProportionDifference = 0.15,
                                          minReadsPerCytosine = 8,
                                          pValueThreshold = 0.05,
                                          test = "fisher",
                                          cores = 40)
  
  DMRsBinsCHGMerged = mergeDMRsIteratively(DMRsBinsCHG,
                                           minGap = 200,
                                           respectSigns = TRUE,
                                           metDataList[["mock"]],
                                           metDataList[["HSVd"]],
                                           context = "CHG",
                                           minProportionDifference = 0.15,
                                           minReadsPerCytosine = 8,
                                           pValueThreshold = 0.05,
                                           test = "fisher",
                                           cores = 40)
  
  DMRsBinsCHHMerged = mergeDMRsIteratively(DMRsBinsCHH,
                                           minGap = 200,
                                           respectSigns = TRUE,
                                           metDataList[["mock"]],
                                           metDataList[["HSVd"]],
                                           context = "CHH",
                                           minProportionDifference = 0.15,
                                           minReadsPerCytosine = 8,
                                           pValueThreshold = 0.05,
                                           test = "fisher",
                                           cores = 40)
  
  ## 4-WRITING REPORTS
  
  if (!dir.exists("/storage/ncRNA/Projects/CUCUMBER_HSVd/Methylome/Results/02-DMRcaller")) {
    dir.create("/storage/ncRNA/Projects/CUCUMBER_HSVd/Methylome/Results/02-DMRcaller")
  }
  
  write.table(x = as(DMRsBinsCGMerged, "data.frame"), 
              file = paste0("/storage/ncRNA/Projects/CUCUMBER_HSVd/Methylome/Results/02-DMRcaller/T", i, "_DMRs_Bins_CG_V4.tsv"), 
              sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE )
  write.table(x = as(DMRsBinsCHGMerged, "data.frame"), 
              file = paste0("/storage/ncRNA/Projects/CUCUMBER_HSVd/Methylome/Results/02-DMRcaller/T", i, "_DMRs_Bins_CHG_V4.tsv"), 
              sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE )
  write.table(x = as(DMRsBinsCHHMerged, "data.frame"), 
              file = paste0("/storage/ncRNA/Projects/CUCUMBER_HSVd/Methylome/Results/02-DMRcaller/T", i, "_DMRs_Bins_CHH_V4.tsv"), 
              sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE )
}
