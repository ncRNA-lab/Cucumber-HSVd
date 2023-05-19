# Multiomic analysis in cucumber plants infected with HSVd

This github page stores the main tables of results as well as the code used to obtain them in the paper "Multiomic analisys reveals that viroid infection induces a temporal reprograming of plant-defence mechanisms at multiple regulatory levels".

## Abstract

Viroids are circular RNAs of minimal complexity compelled to subvert plant-regulatory networks to accomplish their infectious process. Studies focused on the response to viroid infection have mostly addressed specific regulatory levels and considered a unique infection time. Thus, much remains to be done to understand the temporal evolution and complex nature of viroid-host interactions. Here we present an integrative analysis of the temporal evolution and intensity of the genome-wide alterations in cucumber plants infected with hop stunt viroid (HSVd) by integrating differential host transcriptome, sRNAnome and methylome. Our results support that HSVd promotes the redesign of the cucumber regulatory-pathways predominantly affecting specific regulatory layers at different infection-phases. The initial response was characterized by a reconfiguration of the host-transcriptome by differential exon usage, followed by a progressive transcriptional down-regulation modulated by epigenetic changes. Regarding endogenous small RNAs, the alterations were limited and mainly occur at the late stage. The most significant host-alterations were predominantly related to the down-regulation of transcripts involved in plant-defence mechanisms, the restriction of pathogen-movement and the systemic spreading of defence signals. Altogether our data evidence the existence of a dynamic and yet poorly known arms race between the host and the viroid. We expect that these data constituting the first comprehensive map of the plant responses to a viroid infection contribute to elucidate the molecular basis of this multifaceted defence and counter-defence layout.

## Folders

### Omics tables

In this folder we can find the results tables obtained after the analysis of the omics data.

- SRNAnome: Tables from differential expression analysis comparing HSVd vs. mock for each time (10, 17 and 24 dpi). R package: DESeq2 and edgeR.
- Transcriptome: Tables from differential expression analysis comparing HSVd vs. mock for each time (10, 17 and 24 dpi). R package: DESeq2.
- Methylome: Tables from differential methylation analisys comparing HSVd vs. mock for each time (10, 17 and 24 dpi) and for each context (CG, CHG and CHH). R package: DMRcaller.

For more information about the methodology to obtain these tables read the paper.

### Scripts

This section provides the scripts that generate the tables mentioned in the previous section.

- SRNAnome: Script used to perform differential expression analysis of small RNAs.
- Methylome: Script used to perform differential methylation analysis.

Transcriptome folder doesn't exist because the web-based platform Galaxy was used to perform differential expression analysis of transcripts.
