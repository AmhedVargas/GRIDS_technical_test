# GRIDS test
- Repository describing curated code, methodology, and programs used to answer GRIDS test

- Please note that while I structure my work in online repositories for sharing and publication purpouses, day to day basis I keep my notes and advances in a simple shell file. This project was no exception, and you can find my notes in this root directory.

- This repository is composed by three main folders, `data` which contains scripts to download and prep the data for analysis, `analysis` which contains the code used to perform analysis on the machines I had available, and `results` which is mainly composed by graphs and scripts used to produce them.

## Notes to the team
The first thing I noticed after downloading the vcf for the dataset was that the number of samples did not matched the description of the test. Particularly, the pdf file for the test mentions 575 samples while the vcf I received contains 1575. 

For the sake of the test, I tried to figure out where the error was coming from and, by looking at the sample names, I've in mind that most likely the command for individual selection was not properly performed and most of the EAS and SAS samples from Gnomad's hgdp + 1k panel ended up in the vcf test dataset. 

Originally, I tried to avoid using that very same panel for the stratification analysis (admixture/structure) as duplicated data would cause  a large bias, however, due to some SNPs being called either at the hgdp or the 1k separatedly (I guess I could have also called the variants from the original bam files). I ended up using the same panel and did tests on how the data would have look like with and withouth the duplicated individuals. On that note, accessing gnomad's data storage requires credentials, while Rodrigo was kind enough to install AWS CLI on the VM, he did not configure the iam user.

Similarly, I considered that for the sake of the test, it would have been better to change the name of the vcf (the main answer for the first question was there even with its surprise elements) as well as the sample names. Here's below simple code for data parsing that I wrote to do so.

```
##Note head -n 5000 is only to process faster the command 
head -n 5000 grids-technical-test-datasets/gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf | grep "#CHROM" | awk -F"\t" '{OFS="\t"; printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9; for(i=10; i<= NF; i++){printf "\tGRIDS-"(i-9)}; print ""}' > NewNames.txt

head -n 5000 grids-technical-test-datasets/gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf | grep "#" | head -n -1 | cat - NewNames.txt > Newheader

grep -v "#" grids-technical-test-datasets/gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf | cat Newheader - > grids-technical-test.vcf
```
All those points said, I think the test was fair and one week is more than enough for its completion thanks to the beefy virtual machine that you provide from amazon. Unfortunately, due to constrains with my free time and data downloads, I could not explore the exercises as much as I wanted nor provide more documentation than the minimum required (I though writting a small report in pdf with references and interpretation would have been nice), nonetheless, I hope you find my work or feedback usefull for the next time someone else has to perform this test.

Cheers,
Amhed
