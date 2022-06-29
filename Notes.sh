##21/06/22
#Mail from Rodrigo
#Hi Amhed,
#
#First of all, apologies for the delay in getting back to you after your interview.
#
#We have prepared a technical test for you to complete, the instructions for which are attached as a PDF document. You have seven days from today to complete the test. We will set up a meeting for next Wednesday 29th of June for you to present your results.
#
#Datasets download link
#DELETE#
#Access to the VM
#IP address: DELETE
#User: eDELETE
#
#The ssh key for the VM (DELETE) is attached to a follow-up email that you will receive shortly. Add the key to your .ssh directory and run:
#sudo chmod 400 .ssh/DELETE
#
#To connect to the VM, use the following command:
#ssh -i .ssh/DELETE
#
#Please let us know if you have any questions.
#
#Best regards,
#Rodrigo
#This e-mail and any attachments are only for the use of the intended recipient and may contain material that is confidential, privileged and/or protected by the Official Secrets Act. If you are not the intended recipient, please delete it or notify the sender immediately. Please do not copy or use it for any purpose or disclose the contents to any other person. 


##Cool, now to get started with the test
#Commands used in /home/velazqam/Documents/Documents/Interview/GRID_Test, i.e.
#cd /home/velazqam/Documents/Documents/Interview/GRID_Test
#sudo chmod 400 DELETE.pem
#ssh -i DELETE-rsa.pem ec2-user@DELETE
##That said is "not compulsory to use the provided VM" so I can use my machine instead. Both machines I have the chance to install programs

#Take note of the specs of my machine so I can compare later how it would have scaled in their virtual machine
##VM specs -> basic top
top
## RAM about 32 GB / CUrrent workstation 128
##CPUs 16 / Current workstation has 32, but potentially both servers are comparable - Platinum vs gold
#Better to use then my current workstation

#"By using the virtual machine provided for this test, you are agreeing to behave responsibly. Any
#potential misuse of materials or equipment provided by A*STAR will be investigated and may
#have legal consequences."
##Yup better use my computer then.
exit

##Now with the test
cd /home/velazqam/Documents/Documents/Interview/GRID_Test

##Download data
wget "https://grids-technical-test-datasets.s3.ap-southeast-1.amazonaws.com/grids-technical-test-datasets.tar?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAQVU6ZJELLQUYN2U6%2F20220621%2Fap-southeast-1%2Fs3%2Faws4_request&X-Amz-Date=20220621T045200Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=033e636d6b873fdac5e9b54a87261474f8c8b1f4509e767b0fd52f2b2084cfd5"

#Note I could have use AWS CLI aswell

#Rename to original file
mv "grids-technical-test-datasets.tar?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAQVU6ZJELLQUYN2U6%2F20220621%2Fap-southeast-1%2Fs3%2Faws4_request&X-Amz-Date=20220621T045200Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Sig" grids-technical-test-datasets.tar

#Extract files
tar -xvf grids-technical-test-datasets.tar
##grids-technical-test-datasets/
##grids-technical-test-datasets/PGS002277.txt.gz
##grids-technical-test-datasets/PGS000344.txt.gz
##grids-technical-test-datasets/gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf.bgz
##grids-technical-test-datasets/PGS000658.txt.gz
##grids-technical-test-datasets/PGS002268.txt.gz
cd grids-technical-test-datasets/

######Admixture Exercise
#You are provided with a VCF with 50,223 variants and 575 samples:
ls gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf.bgz
#Uncompress
bgzip -d gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf.bgz
## From the name I can imagine where the data is coming from, however, for the sake of the test, let's assume I don't know any information of the individuals in this data set
#therefore, the first is to get a cohort panel that will allow me to go deeper with the ancestry analysis.
#I can use it solely as a proxy, and once I've defined the major structure in the dataset, I can correctly perform admixture analysis on the selected ser
##Remember, the question of this exercise is:
#"Infer and plot the ancestry components for each individual sample in the provided VCF."
##So, once I set which panel I need, k to use, and qc standart metrics, I just have to make a barplot with all the admixture. I can use R to do so
#Make sure to use ggplot and nice color pallete from:
#https://htmlcolorcodes.com/

####PRS Exercise
#"Calculate the PRS for the samples in the VCF provided using the polygenic score (PGS) files
#provided."
#4 PGS files coming from the same vcf
##Check files (though I cna use also zcat)
#Uncompress
gzip -d *.gz
#Check files
head PGS00*
###PGS CATALOG SCORING FILE - see https://www.pgscatalog.org/downloads/#dl_ftp_scoring for additional information
#format_version=2.0
##POLYGENIC SCORE (PGS) INFORMATION
#pgs_id=PGS000658
#pgs_name=PRS-TC
#trait_reported=Total cholesterol
#trait_mapped=total cholesterol measurement
#trait_efo=EFO_0004574
#weight_type=BETA
#genome_build=GRCh37
##Genome to use for most of the analysis is  GRCH37 then

##Also, need to check https://www.pgscatalog.org/downloads/#dl_ftp_scoring_scoring , the remaining info is just the citation og the PGS
#Finally, the format of the files goes as follows:
#rsID	chr_name	... it seems PGS002277.txt misses the chr_position column
##It's quite interesting the PGS site
# For PGS002277, I notice that the cohort is Scotland-Indian and different QC metrics there.
#Anyway, let see if the file is actually complete
wget https://ftp.ebi.ac.uk/pub/databases/spot/pgs/scores/PGS002277/ScoringFiles/PGS002277.txt.gz
zcat PGS002277.txt.gz
#Yup
##Probably I should read first the full exercise to understand what I am required to do...
#"Calculate the polygenic risk score for each individual sample for two of the provided PGS files."
## 
#PGS002268.txt.gz : PGS002268, prostate cancer
#PGS002277.txt.gz : PGS002277, type 2 diabetes
#PGS000344.txt.gz : PGS000344, breast cancer
#PGS000658.txt.gz : PGS000658, total cholesterol

##Note, make a table for the presentation

##Bassically, I have to see which make more sense and explain my selection
#PGS002268 - Sample ancestry: East Asian (Korean)
#PGS000658 - Sample ancestry: East Asian
#PGS000344 - Sample ancestry: European
#PGS002277 - Sample ancestry: Mix set with a somewhat good contribution of(~31%): South Asian,East Asian,African American or Afro-Caribbean,Hispanic or Latin American

##PGS catalog also specifies which sample sets have been used for other studies, and indeed this paper shows that European can perform:
#https://www.nature.com/articles/s41467-020-17680-w
#That said, its much much better to perform the admixture analysis first to have an idea of which PGS is better suited for its use

######## Estimation of pop-scale variant cataloguing saturation
#"Develop an algorithmic solution to estimate the level of “saturation” of a given variant catalogue."

##Roberto mentioned at somepoint that this was once his project but could not do it withouth for loops. I wonder if a simple hash strategy will work

#Task
#You are provided with a VCF with 50,223 variants and 575 samples:
#gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf.bgz
#1. Using the VCF provided, develop an algorithmic solution to compute the number of
#novel SNPs uncovered as a function of the number of genomes sequenced & plot the
#results.
#2. With this limited toy dataset, the curve corresponding to the number of novel SNPs
#uncovered as a function of the number of genomes sequenced will likely remain far
#from approaching the desired asymptotic limit.
#However, how would you approach estimating the parameters of the curve and provide
#an estimate of the number of local genomes it will take to have captured 90%, 99% of
#the genetic variation?
#3. What are the eventual limitations of the algorithmic solution you have devised, as the
#number of sequenced genomes to consider will be in the tens of thousands? Whattechnical solution, data representation or approach would you explore that would be
#conducive to alleviating these constraints?

#Let's start by exploring how large is the dataset in a simple awk hash, though the dta structure in the vcf is already paired, and by definition each line is a new snp
## so, I have to identify which ones are indeed a new variant
##ALso note that the vcf has been produced with human GCR38 and not 37, this might cause and issue if I use position instead of RSID number for PGS
#Filter DP:GQ:MIN_DP:PID:RGQ:SB:GT:PGT:AD:PL:
##Basic exploring of the file
grep -v "#" gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf | awk -F"\t" '{key = $3; for(i =10; i<= NF; i++){split($i,info,":"); hash[key][info[1]]++}}END{for(key in hash){printf key; for(typ in hash[key]){printf "\t"typ":"hash[key][typ]}; printf "\n"}}' | head
#rs12200211	1/1:2	0/0:1502	0/1:71
#rs4754483	1/1:527	0/0:493	./.:3	0/1:552
#rs309251	1/1:33	0/0:1188	0/1:354
#rs12201533	1/1:73	0/0:1044	0/1:458
#rs4075242	1/1:99	0/0:910	0/1:566
#rs76489092	1/1:30	0/0:1227	./.:17	0/1:301
#rs814914	1/1:197	0/0:663	./.:2	0/1:713
#rs7518048	1/1:506	0/0:339	./.:1	0/1:729
#rs6690131	1/1:167	0/0:732	0/1:676
#rs11744731	1/1:287	0/0:574	0/1:714

## Cool, it work as I thought and intended. Let get a temporal file before and making sure I can compare
grep -v "#" gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf | awk -F"\t" '{key = $3; for(i =10; i<= NF; i++){split($i,info,":"); hash[key][info[1]]++}}END{for(key in hash){printf key; for(typ in hash[key]){printf "\t"typ":"hash[key][typ]}; printf "\n"}}' > rsIDs_alleles.tsv
head rsIDs_alleles.tsv 
#rs12200211	1/1:2	0/0:1502	0/1:71
#rs4754483	1/1:527	0/0:493	./.:3	0/1:552
###So 1/1 hom for snp, 0/0 hom for ref, 0/1 het, ./. no data, so a simple trick for prob is
#awk -F"\t" '{key=$1; for(i=2; i<= NF; i++){split($i,info,":"); if((info[1]=="1/1")||(info[1]=="0/1")){insid[key]=insid[key]+info[2]}else{out[key]=out[key]+info[2]} } } END{for(key in insid){print key"\t"insid[key]"\t"out[key]"\t"(insid[key]/(insid[key]+out[key]))}}' rsIDs_alleles.tsv | head
#rs12200211	73	1502	0.0463492
#rs4754483	1079	496	0.685079
#rs12201533	531	1044	0.337143

awk -F"\t" '{key=$1; for(i=2; i<= NF; i++){split($i,info,":"); if((info[1]=="1/1")||(info[1]=="0/1")){insid[key]=insid[key]+info[2]}else{out[key]=out[key]+info[2]} } } END{for(key in insid){print key"\t"insid[key]"\t"out[key]"\t"(insid[key]/(insid[key]+out[key]))}}' rsIDs_alleles.tsv > Snp_probability.tsv

##I wonder, does the rarefaction curve is analogous to calculating the histogram chance of getting the snp?
##For that I require to calculate a z value for a random distributed population of snps, but I'm not sure even is the case... lets play with R
R
snpP=read.table("Snp_probability.tsv",sep="\t",header=F)
hist(snpP[,4])

##Not really, more a poisson distribution
summary(snpP[,4])
#     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
#0.0006349 0.1873020 0.3371430 0.3918606 0.5657140 1.0000000
q()

###The easiest to test my hypothesis and perform bootstrap is to convert into matrix and get the scores

##Also, do note again that missing data is really important to consider. So do quality checks and filtering for missingness. considering I'll be working with admixture first,
#it should be straightforward performing analysis with the plink matrix

##In other words, to get most of the SNPs I should approximately sample .33*No. individuals, ~ 575*.33 = 190. However this only works out if there were nomissing data, that screws the frequency we see a snp.
##I could ran some bootstraps to make sure my hypothesis is right (and read about the actual computation of saturation, or, rarefaction curves)
#That said, my whole hypothesis only makes sense if I assume saturation on the vcf, or that the diversity is equal to the effective population sisze
###Reading this article makes me think I'm correct in my assumption
#https://onlinelibrary.wiley.com/doi/pdf/10.1002/ece3.6016


##Ok ok, I need to develop a plan for the following days and analysis

##Given coalescent theorye distribution, I should be able to determine the smapling size 
##That said, this is using for loops to parse and count the discovery sets. A simple yet not sure if fast way to account the snp discovery rate will be to
#perform byte-wise comparison of 'tab'1/1, 'tab'0/1, 'tab'0/1, and 'tab'./.. In principle that should be faster and should anonimize data. Also, if the vcf has been processed 
#with the desired quality filters, this should be a simple way to scale it up. I can do a simple test with 100K GT and see how does this stands to a regexp
##Though basically splitting strings are infact a kind of regexp mmm

##Other notes:
#missing data can be recovered by genotype imputation
#https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6207453/
#And even LD analysis can be done at read level
##Some papers do initial estimation of allee frequencies, and then adjust it given the propability to see an heterozygous
##I have to assume QC control, LD prunning, etc etc. has performed for this last test. Otherwise it gets extensive at making the analysis
##Already good implementation fo tools for plink formats:
#https://www.frontiersin.org/articles/10.3389/fgene.2015.00109/full


##Plan for analysis and next days
##Admixture with plink formatted data. Once I've a better estiamte of the clusters, start analysis on point two. DO aside the analysis of SNP discovery
##Once analysis and conclusions are outlined. Need to do presentation, I could star already git the github ReadMe

#22/06/22
##Rodrigo (and the team) was kind enough to let me send my analysis and presentations before Wednesday 29th. So I should consider finish the analysis before leaving and just polish things during my trip so I submit everything on time.
#Todays plan, convert vcf into plink format, get admixture analysis done, perform QC with badmixture, identify clusters and from there do thePGS analysis.
##So, lets get started
# Move to main directory
cd /home/velazqam/Documents/Documents/Interview/GRID_Test
#subdirectory
cd grids-technical-test-datasets/

#Create one directory for admixture
mkdir Admixture_analisis
#move there
cd Admixture_analisis

###Convert first to plink format
##Technical stop to install plink on my computer
#cd /home/velazqam/Documents/Software
#mkdir plink
#cd plink
#wget https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20220402.zip
#unzip plink_linux_x86_64_20220402.zip
##Add to the path /home/velazqam/Documents/Software/plink
#nano ~/.profile
#cd /home/velazqam/Documents/Documents/Interview/GRID_Test/grids-technical-test-datasets/Admixture_analisis
##Done

##Convert to plink format
plink --vcf ../gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf --make-bed --out GRID_test

##Now thechnical stop for current Novembre's admixture package (though I could have used standart chromopaint or other softwares aswell)
#
#cd /home/velazqam/Documents/Software
#mkdir Admixture
#cd Admixture
#wget https://dalexander.github.io/admixture/binaries/admixture_linux-1.3.0.tar.gz
#tar xvfz admixture_linux-1.3.0.tar.gz 
#cd dist/admixture_linux-1.3.0/
#Add to path /home/velazqam/Documents/Software/Admixture/dist/admixture_linux-1.3.0
#nano ~/.profile
#cd /home/velazqam/Documents/Documents/Interview/GRID_Test/grids-technical-test-datasets/Admixture_analisis
#Open new terminal

##Lets use the basic command for cross validation with up to 10 K
for K in {1..10}; do
admixture --cv GRID_test.bed $K | tee Admixture_${K}.out; done

grep -h CV Admixture_*.out
#Ok, It seems the data is composed by N cluster, now I've to identify those clusters. Let's merge with a large panel first (despite by name I could already identify somewhat the ancestry of the individuals)

##Now I should use a large panel of reference to infer ancestry. I can use the Human Genome Diversity Project panel, that said, reading from the identifiers, HGDP is written in a large set of individuals. e.g.
grep "HGDP" GRID_test.fam | wc -l
#337
wc -l GRID_test.fam
#1575 GRID_test.fam
##That does not make sense, I though the vcf consistet of 50,223 variants and 575 samples
grep -v "#" ../gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf | awk -F"\t" '{print NF}' | sort | uniq -c
#  50223 1584
##Minus 11 column identifiers, 1575. So the naming schema makes sense, hgdp_1kg, and its funny but the name also suggests that EAS, SAS and AMR should be the right ancestry for this set and so for the risk scores to use.
##So not exactly, the vcf contains actually 1584, but probably what they meant is that there are 575 NEW samples while the rest is the panel they used.
##Alternatively I can trace back which identifiers belong to the panel and forget about it
cd ..
#After downloading the list of individuals as individuals_igsr-human\ genome\ diversity\ project.tsv from https://www.internationalgenome.org/data-portal/data-collection/hgdp
awk -F" " '{print $1}' GRID_test.fam | sort > A

tail -n+2 individuals_igsr-human\ genome\ diversity\ project.tsv | awk '{print $1}' | sort > B
comm A B -12 | wc -l
#337
##Same if a simple grp for "HGDP"
grep "HGDP" GRID_test.fam  | wc -l
#337
grep "NA" GRID_test.fam  | wc -l
#358
grep "HG0" GRID_test.fam  | wc -l
#880
grep "DNA" GRID_test.fam  | wc -l
51
##
#A more in depth data parsing and google search, show that the vcf is actually just individuals from reference panels and I can easily get their annotated population. For the sake of the analysis, I'm keen to parse and add the population information from each panel so the clusters are clear in the admixture (after cv).
#That said I'm a bit concerned of doing this for the sake of the test as my impression was that I was intented to assume no information apriori.
##Let's do a ground truth for all the individuals in the vcf using information on the web, do a basic admixture plot and then wait for further information
#HGDP https://www.internationalgenome.org/data-portal/data-collection/hgdp
#SGDP(LP) https://sharehost.hms.harvard.edu/genetics/reich_lab/sgdp/
##The LP IDs were get rid off the underscore part so it cannot be traced back. Good, theme might have been the test set thought 51 is not enough
#HG IDs https://www.internationalgenome.org/data-portal/sample
###Actually this list contains pretty much all the info regardings human WGS
##Lets see how many IDs I can recover
tail -n+2 igsr_samples.tsv | awk -F"\t" '{print $1}' | sort > B
#comm A B -12 | wc -l
#1487
##Most of the individuals... most likely the remaining ones are the v3 and LPs
# comm A B -23 | wc -l
#88
##Yup.... and actually v3 is just an identifier to specify the new version of 1K genomes.. so..
perl -pe 's/v3.1:://g' A > C
tail -n +2 igsr_samples.tsv | awk -F"\t" '{if(NF != 1){info[$1]=$0}else{if(info[$1] ==""){print $1"\tNA"}else{print $1"\t"info[$1]}}}' - C > Fam_dat.tsv
#Ok, admixtures are almost done, lets use the individual info on the FAM column, make a groundtruth then use a panel (maybe coming from the same site) to verify ancestries
## so add things to A
awk -F"\t" '{print $8}' Fam_dat.tsv | sort | uniq -c
#     51 
#     10 American Ancestry
#    153 Central South Asia (HGDP)
#    184 East Asia (HGDP)
#    578 East Asian Ancestry
#      3 East Asia (SGDP),East Asian Ancestry
#    590 South Asian Ancestry
#      6 South Asia (SGDP),South Asian Ancestry
awk -F"\t" '{print $7}' Fam_dat.tsv | sort | uniq -c
#    388 
#     10 AMR
#    581 EAS
#    596 SAS
##EAS_SAS_10AMR_samples.dense.vcf SO bassically the name described everything. Despite the larger set (1575 instead of 575) its fine. Maybe there was a typo in the pdf or the original cml
##What does the admixture analysis show?
##Still K == 7
##https://gnomad.broadinstitute.org/downloads#v3-hgdp-1kg is most likely the palce where they got the genome (I mean is in the name).
#I think is fair to use a larger panel set and redo the admixture with the full ancestry
##For now the admixture analysis are done
grep -h CV Admixture_*.out
#CV error (K=10): 0.51279
#CV error (K=1): 0.54856
#CV error (K=2): 0.51552
#CV error (K=3): 0.51393
#CV error (K=4): 0.51241
#CV error (K=5): 0.51237
#CV error (K=6): 0.51217
#CV error (K=7): 0.51224
#CV error (K=8): 0.51215
#CV error (K=9): 0.51232

#According to this a sensible option is K = 8
grep -h CV Admixture_*.out| perl -pe 's/[\(\)]//g' | perl -pe 's/[\:\=]/\t/g' > CV_errors.tsv
R
tab=read.table("CV_errors.tsv",sep="\t",header=F)
tab=tab[order(tab[,2]),]
plot(tab[,2],tab[,3],type="l",col="blue",main="Cross Validation error for each user defined K",xlab="K",ylab="CV Error")
#4 to 8 looks reasonable
##HOwever I am not really convinced, this could have been due to not properly getting scores?
##For the sake of time, lets
#A) Get a large panel
#B) Change IDs on test samples
#C) Merge accordingly
#D) Run admixture
##Then while admixture runs I can explore nice pplotting programs like pong 
#http://brown.edu/Research/Ramachandran_Lab/projects/
##Ok ok ok
mkdir Large_test
cd Large_test

##Panel to consider 30x data from 1000 genomes project (phase3) basically 5 Super Populations (EAS,SAS,AFR,EUR,AMR)
##Also gnomad v3 seems like the most complete set, however it will take the longest to extract and analyse
##As I'm not certain which sites were used, wether they were phased, or the state of the files, the only exhaustive thing I can do is download all the files, and use tabix to extract sites available, and then merge hopefully properly
#okw get of list seen here https://www.internationalgenome.org/data-portal/data-collection/30x-grch38
for file in `cat list.txt`; do echo $file; wget $file; done
#This will take a while, maybe until tomorrow
##I was thinking that a good way to do the test is to rename the individuals with different id and so it wont be obvious anymore from which population each individual
##Quite interesting actually
#https://www.biorxiv.org/content/10.1101/2021.02.06.430068v1.full.pdf
#Also, documentation of how data was produced is well written and documented
#http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20190425_NYGC_GATK/1000G_README_2019April10_NYGCjointcalls.pdf
##I could get also all from gnomad https://gnomad.broadinstitute.org/downloads#v2-variants
##But it can take longer than expected
##BTW also I was stupid, admixture can run in multitreat, i.e. -jN
##11 was downloaded, I can check it now
##Let's hope all sites are covered, otherwise most likely I have to use gnomad dataset
##So for chr11 there are
grep -v "#" gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf | awk -F"\t" '{if($1=="chr11"){print $1"\t"$2"\t"$3}}' > chr11_sites.tsv
wc -l chr11_sites.tsv 
#2584 chr11_sites.tsv
#tabix -p vcf 20201028_CCDG_14151_B01_GRM_WGS_2020-08-05_chr11.recalibrated_variants.vcf.gz -R pos.tsv | wc -l
#zcat ../20201028_CCDG_14151_B01_GRM_WGS_2020-08-05_chr11.recalibrated_variants.vcf.gz | grep -v "#" | awk -F"\t" '{key=$1"-"$2; if(NF==3){hash[key]++}else{if(hash[key] > 0){print $0}}}' chr11_sites.tsv - | wc -l
tabix -p vcf 20201028_CCDG_14151_B01_GRM_WGS_2020-08-05_chr11.recalibrated_variants.vcf.gz -R pos.tsv | wc -l
#2604
##SO 20 more sites, I imagine this might be by sites with more than a single polymorphism, so so far so good but I have to make sure that theres a unique snp per position
#
awk -F"\t" '{print $1"-"$2}' test_chr11.vcf | sort | uniq | wc -l
##2604
###HOW?
awk -F"\t" '{key=$1"+"$2; if(NF==2){hash[key]=1}else{if(hash[key]>0){print $0}}}' pos.tsv test_chr11.vcf | wc -l
#ah ha, not all the variants are actually snps
#awk -F"\t" '{print length($4)}' test_chr11.vcf | sort | uniq -c
#2582 1
##Now I missed one site, but maybe is due to bein same site?
##Better use the gnomad then, so I will jsut stop the download and get data from the vcf folder of the gnomad

##MM no credentials for aws s3 cp
##aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/mt/genomes/gnomad.genomes.v3.1.2.hgdp_1kg_subset_dense.mt .
##AWS CLi will require to configure credentials for the VM for the test
##I configured credentials from my administrator account
##I'm downloading dense table from hail so I can use as test for panel in case that the data has not been imputed
#aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/mt/genomes/gnomad.genomes.v3.1.2.hgdp_1kg_subset_dense.mt/ . --recursive
##I have the list now  so I can download them with aws
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_1kg_subset_sample_meta.tsv.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr14.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr15.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr16.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr17.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr18.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr19.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr20.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr21.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr22.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chrY.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr1.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr10.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr11.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr12.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr13.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr2.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr3.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr4.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr5.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr6.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr7.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr8.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr9.vcf.bgz.tbi .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chrX.vcf.bgz.tbi .

aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr1.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr10.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr11.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr12.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr13.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr14.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr15.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr16.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr17.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr18.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr19.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr2.vcf.bgz .

aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr20.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr21.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr22.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chrX.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chrY.vcf.bgz .

aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr3.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr4.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr5.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr6.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr7.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr8.vcf.bgz .
aws s3 cp s3://gnomad-public-us-east-1/release/3.1.2/vcf/genomes/gnomad.genomes.v3.1.2.hgdp_tgp.chr9.vcf.bgz .

##and on the 1k genome unrelated samples there are
##Anyway, on the meantime, I can see how to plot with pong
##pong is actually cool, they tested their program with the 1K dataset
#Quite fancy and easy to use, that said, it's much better to ahve a program that can print the admixture plots directly in the terminal
##Oh, actually it does by  --disable_server
#Nope only produces convergence plots of the Ks, better make a simple script in R to plot the admixture based on a file map and pop order, similar to pong
##Hail as software is also interesting

##DOwnloading is still taking long time
#I wonder if there's a way to extract the snps by batch
##Lets also do some MDS or PCA for fun and data exploration. Also, things to consider on top for large scale analysis is to use procrustes and discriminant pcas as in denmark
#smartpca should run fast
##https://www.hsph.harvard.edu/alkes-price/software/

#procurstes will allow to infer ancestry using a simple panel of LD prunned individuals as a first approximation
#dpcas will allow the identification of rare snps in the population that bring large contribution to the cluster an can be caused by a foundfing effect 

#23/06/22
##Just a small set of files have been downloaded in 6h, so, there should be a way to extract all sites with hail
##There are ways to do so, but due to the limited time I have, better extract the positions as I consider, learn hail later
#https://cloud.google.com/blog/products/data-analytics/genomics-data-analytics-with-cloud-pt2
##Anyway, let's extract the regions and corroborate
##Let's try with chr1
grep -v "#" grids-technical-test-datasets/gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf | awk -F"\t" '{print $1"\t"$2}' > gnomad_grid_test.positions.tsv

tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr1.vcf.bgz -R gnomad_grid_test.positions.tsv > chr1.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
##After a while
wc -l chr1.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
#4297 chr1.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
#awk -F"\t" '{print $1}' gnomad_grid_test.positions.tsv | sort |uniq -c
#Same issue
#4094 chr1
##Though as I thought before is due to multi-iallelic sites, e.g.
###GRID Test            #gnomad data
#chr1 1322866 . A C      chr1 1322866 rs3845293 A C
#chr1 1327211 . C T      chr1 1322866 rs3845293 A G
##Not the best, but I can merge the files by using as key position aan ref aand alt, If I get the same number we're green to go
##cat A B | awk '{print $1"-"$2"-"$4"-"$5}' | sort | uniq -c | awk '{print $1}' | sort | uniq -c
 # 46332 1
 #  4094 2
#Cool,  it should work in theory then
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr10.vcf.bgz -R gnomad_grid_test.positions.tsv > chr10.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr11.vcf.bgz -R gnomad_grid_test.positions.tsv > chr11.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr12.vcf.bgz -R gnomad_grid_test.positions.tsv > chr12.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf

tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr13.vcf.bgz -R gnomad_grid_test.positions.tsv > chr13.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr14.vcf.bgz -R gnomad_grid_test.positions.tsv > chr14.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr15.vcf.bgz -R gnomad_grid_test.positions.tsv > chr15.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr16.vcf.bgz -R gnomad_grid_test.positions.tsv > chr16.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr17.vcf.bgz -R gnomad_grid_test.positions.tsv > chr17.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr18.vcf.bgz -R gnomad_grid_test.positions.tsv > chr18.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr19.vcf.bgz -R gnomad_grid_test.positions.tsv > chr19.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf

##grep -v "#" grids-technical-test-datasets/gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf | awk -F"\t" '{OFS="\t"; print $1,$2,$3,$4,$5}' > gnomad_grid_test.pos_with_ref_al.tsv
##Lets make sure the naming schema remains the same for all the hgdp vcgs so I can simple cat them after filtering the sites
zcat gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr1.vcf.bgz | head -n 2000 | grep "#CHROM" > name.test.txt
zcat gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr10.vcf.bgz | head -n 2000 | grep "#CHROM" >> name.test.txt
zcat gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr11.vcf.bgz | head -n 2000 | grep "#CHROM" >> name.test.txt
zcat gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr12.vcf.bgz | head -n 2000 | grep "#CHROM" >> name.test.txt
zcat gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr13.vcf.bgz | head -n 2000 | grep "#CHROM" >> name.test.txt
zcat gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr14.vcf.bgz | head -n 2000 | grep "#CHROM" >> name.test.txt
zcat gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr15.vcf.bgz | head -n 2000 | grep "#CHROM" >> name.test.txt
wc -l name.test.txt 
#7 name.test.txt
sort name.test.txt | uniq  | wc -l
#1
##Yup
##SO, I can extract the positions, cat and add naming schema of chr1 for example. cool coool cool
##Just for the sake of getting all info before removing full datasets
##Lets save the headers
##For now 1 10 11 12 13 14 15 16 17 18 19
mkdir headers
for file in 1 10 11 12 13 14 15 16 17 18 19; do
zcat gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr${file}.vcf.bgz | head -n 2000 | grep "#" > headers/chr${file}.txt; done

##Once header saved aaand vcfs produced with tabix, I can remove them and continue with the download of 20 21 22
##TO speed process I will download 20 21 22 X Y in other computer (thank god for my university network lol)
##OK, plan on how to concat chr*.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
##But seen the files better start removing large chrs and tabix
cd gnomad 
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr1.vcf.bgz
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr1.vcf.bgz.tbi
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr10.vcf.bgz
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr10.vcf.bgz.tbi
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr11.vcf.bgz
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr11.vcf.bgz.tbi
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr12.vcf.bgz
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr12.vcf.bgz.tbi
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr13.vcf.bgz
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr13.vcf.bgz.tbi
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr14.vcf.bgz
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr14.vcf.bgz.tbi
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr15.vcf.bgz
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr15.vcf.bgz.tbi
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr16.vcf.bgz
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr16.vcf.bgz.tbi
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr17.vcf.bgz
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr17.vcf.bgz.tbi
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr18.vcf.bgz
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr18.vcf.bgz.tbi
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr19.vcf.bgz
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr19.vcf.bgz.tbi

##Cool, chromosome 2 is completed I can extract the positions, header and remove, and then forget about space issues
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr2.vcf.bgz -R gnomad_grid_test.positions.tsv > chr2.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
for file in 2; do
zcat gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr${file}.vcf.bgz | head -n 2000 | grep "#" > headers/chr${file}.txt; done
cd gnomad
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr2.vcf.bgz
rm gnomad.genomes.v3.1.2.hgdp_tgp.chr2.vcf.bgz.tbi
cd ..
## Then I just have to wait to download 3 4 5 6 7 8 9; 20 21 22 X and Y are on the other computer, I have to make sure place data on same structure before copying pasting
###Ok, now focus on the saturation plots
###Yeah, no haha. Anyway on main computer 20 21 22 X and Y are now downloaded, I have only to extract the positions
tabix -p vcf Large_test/gnomad.genomes.v3.1.2.hgdp_tgp.chr20.vcf.bgz -R gnomad_grid_test.positions.tsv > chr20.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf Large_test/gnomad.genomes.v3.1.2.hgdp_tgp.chr21.vcf.bgz -R gnomad_grid_test.positions.tsv > chr21.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf Large_test/gnomad.genomes.v3.1.2.hgdp_tgp.chr22.vcf.bgz -R gnomad_grid_test.positions.tsv > chr22.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf Large_test/gnomad.genomes.v3.1.2.hgdp_tgp.chrX.vcf.bgz -R gnomad_grid_test.positions.tsv > chrX.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf Large_test/gnomad.genomes.v3.1.2.hgdp_tgp.chrY.vcf.bgz -R gnomad_grid_test.positions.tsv > chrY.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
##Or on the meantime work on the code for bootstrap from a plink matrix
##I understand now why accessing data might require a specific structure system that allows for easy access
##Sql and spark should work faster
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr3.vcf.bgz -R gnomad_grid_test.positions.tsv > chr3.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr4.vcf.bgz -R gnomad_grid_test.positions.tsv > chr4.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr5.vcf.bgz -R gnomad_grid_test.positions.tsv > chr5.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr6.vcf.bgz -R gnomad_grid_test.positions.tsv > chr6.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr7.vcf.bgz -R gnomad_grid_test.positions.tsv > chr7.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr8.vcf.bgz -R gnomad_grid_test.positions.tsv > chr8.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf
tabix -p vcf gnomad/gnomad.genomes.v3.1.2.hgdp_tgp.chr9.vcf.bgz -R gnomad_grid_test.positions.tsv > chr9.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf


##Current plan
#Basic qc in sample dataset (not required really), LD prunning, MAF >.01 (to avoid missingness), etc.
##Merge with large panel, QC. I could make two analysis one with QC and one withouth and describe advantages and disadvantages of both
#Admixture CV
##smartpca
##With proper identified clusters, define the PGS scores
#All based in the proper plink file
##Then based on the plink file, do bootstrap analysis and SNP rarefaction curves

##On the meantime work in documentation and presentation
#"Prepare a presentation showing your work and results for each exercise completed (expected near-
#publication-quality 1 or 2 slides per exercise)"#


##Today also though in an algorithm for the snp saturation, on one side I do think getting the expected value via the freuqnecy of the snps will be faster than the bootstrap
##That said both methods should be very easy to test
#Mathematical way
##Frequency of allele i seen in pop n is p
#p is equivalent to its probability of being in the first individual sequenced
#Expectation is at one is E(1)=1/p
#Expectation of seen at second is
#equivalent to not being pick in the first individual.
##That said rather than a binomial distribution is a problem of ball selection (finite number of spaces)
#Actually is no binomial as it is wiith no replacement, then is a hyper geometric
##https://en.wikipedia.org/wiki/Hypergeometric_distribution
##Also, we just care at the first event of seeing such snp
##Of course, there are cofounding effects and even after LD prunning, chuncks of relatedness might exist in the data
##A simple test would be
R
tt=read.table("Snp_probability.tsv",sep="\t",header=F)
vals=tt[,4]
nvals=1/vals
round(nvals)
table(round(nvals))
appears=table(round(nvals))
cump=cumsum(appears)
plot(as.integer(names(cump)),cump)
plot(as.integer(names(appears)),as.integer(appears))
##Probably this model assumes total independence aldo that all the variation seen in the population is totally explored.
##Bootstrapping should not break the LD patterns I suppose
##ANyway
##Alternatively, for a simple bootstrap I can do process in paralel, or at least a sequence
#i.e. start with plink matrix
#Recode to 0s and 1s
##Recode into a logical values
##Given a new random sequence (sample, no replacement, in code place same seed)


##Anyway finally I have all the files ready, let fuse, extract snps of test, and add a header
cat chr1.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf > fuse.gnomad.vcf
for num in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y; do
cat chr${num}.gnomad.genomes.v3.1.2.hgdp_tgp.snp_test.vcf >> fuse.gnomad.vcf; done
wc -l fuse.gnomad.vcf
#52969 fuse.gnomad.vcf
awk -F"\t" '{key=$1"_"$2"_"$4"_"$5; if(NF==5){hash[key]++}else{if(hash[key]>0){print $0}}}' gnmoad_grid_test.pos_with_ref_al.tsv fuse.gnomad.vcf > Gnomad_hgdp_tgp_panel.GRIDS_positions.tsv
wc -l Gnomad_hgdp_tgp_panel.GRIDS_positions.tsv 
#50223 Gnomad_hgdp_tgp_panel.GRIDS_positions.tsv

#Also, normally I would allow loss some data at merging with otuher panes or call back the sites via bams, but  I think this is the best alternative time/efficiency
#Anyway, add header and we're fine
cat headers/chr1.txt Gnomad_hgdp_tgp_panel.GRIDS_positions.tsv > Gnomad_hgdp_tgp_panel.GRIDS_positions.vcf
##After making vcf, I have to rename the samples of the GRID test to avoid duplicates. That said, most likely some programs will find the duplication and relatedness
##Ok, now lets rename the samples on the original GRIDS vcf
##There should be a program to change names but is easier with simple data handling programs
##Note head -n 5000 is only to process faster the file 
head -n 5000 grids-technical-test-datasets/gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf | grep "#CHROM" | awk -F"\t" '{OFS="\t"; printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9; for(i=10; i<= NF; i++){printf "\tGRIDS-"(i-9)}; print ""}' > NewNames.txt
head -n 5000 grids-technical-test-datasets/gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf | grep "#" | head -n -1 | cat - NewNames.txt > Newheader
grep -v "#" grids-technical-test-datasets/gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf | cat Newheader - > grids-technical-test.vcf

##Then it should be pretty straightforward to merge them all into a vcf
bgzip -c grids-technical-test.vcf > grids-technical-test.vcf.bgz
bgzip -c Gnomad_hgdp_tgp_panel.GRIDS_positions.vcf > Gnomad_hgdp_tgp_panel.GRIDS_positions.vcf.bgz
tabix -p vcf grids-technical-test.vcf.bgz
tabix -p vcf Gnomad_hgdp_tgp_panel.GRIDS_positions.vcf.bgz
#bcftools merge grids-technical-test.vcf.bgz Gnomad_hgdp_tgp_panel.GRIDS_positions.vcf.bgz > GRIDS-HGDP_1kPanel.vcf
##Merge does not work because the filters on vcf are different. Is not a good practice mixing vcf with different qualities
##That said, processing data of same filters into plink and then merging two plink files sounds okeish
##SO lets convert first into .ped and .map and then merge
plink --vcf grids-technical-test.vcf --set-missing-var-ids @:# --keep-allele-order --make-bed --out GRID_test
#50223 variants and 1575
#plink --vcf Gnomad_hgdp_tgp_panel.GRIDS_positions.vcf --set-missing-var-ids --make-bed --out HGDP_panel
##Error with _; ahh that was the reason why _got lost in some samples
plink --vcf Gnomad_hgdp_tgp_panel.GRIDS_positions.vcf --set-missing-var-ids @:# --double-id --keep-allele-order --make-bed --out HGDP_panel
#50223 variants and 4151
##Let's merge now
#plink --bfile HGDP_panel --bmerge GRID_test --keep-allele-order --make-bed --out HGDP_GRIDS
##plink does not merge by position but by name, lets modify then the  snp ids and then merge again
awk -F"\t" '{OFS="\t"; print $1,"chr"$1":"$4":"$5"-"$6,$3,$4,$5,$6}' HGDP_panel.bim > tmp
mv tmp HGDP_panel.bim
awk -F"\t" '{OFS="\t"; print $1,"chr"$1":"$4":"$5"-"$6,$3,$4,$5,$6}' GRID_test.bim > tmp
mv tmp GRID_test.bim
###Funny, Warning: Variants 'chr1:2593476:T-G' and 'chr1:2593476:G-T' have the same
#position.
#Warning: Variants 'chr1:2601185:T-C' and 'chr1:2601185:C-T' have the same
#position.
#Warning: Variants 'chr1:2925918:T-C' and 'chr1:2925918:C-T' have the same
#position.
#3076 more same-position warnings: see log file.
##This implies than 3078 sites have switched reference by alt. HOw do I fix this mmm
plink --bfile HGDP_panel --bmerge GRID_test --keep-allele-order --make-bed --out HGDP_GRIDS
################Coooool the problem was with plink swtching allele order due to the MAF

##Lets, copy, compress, pass to AWS and then copy to different servers. Then I'll leave running admixture while travelling (just in time)
mkdir MasterPanel_plus_samples
cp HGDP_GRIDS* MasterPanel_plus_samples/
cp grids-technical-test.vcf.bgz MasterPanel_plus_samples/
cp grids-technical-test.vcf.bgz.tbi MasterPanel_plus_samples/
cp Gnomad_hgdp_tgp_panel.GRIDS_positions.vcf.bgz MasterPanel_plus_samples/
cp Gnomad_hgdp_tgp_panel.GRIDS_positions.vcf.bgz.tbi MasterPanel_plus_samples/

##That said, mostlikely I'll have issues with the loadings due to the rs disappeareance. THerefore I'll have to work around again with the original vcf but this time with only ancestris
tar -zcvf To_pass.tar.gz MasterPanel_plus_samples/

cd  MasterPanel_plus_samples/
for K in {1..10}; do
admixture -j34 --cv HGDP_GRIDS.bed $K | tee Admixture_${K}.out; done

##Now in main computer
tar xvfz To_pass.tar.gz

##Also in GRIDS VM
wget https://s3.eu-central-1.amazonaws.com/wormbuilder.dev/Downloads/To_pass.tar.gz
df -h

tar xvfz To_pass.tar.gz
rm To_pass.tar.gz
##After instalaltion of admixture
##Lets go to a screen
screen

for K in {1..10}; do
admixture -j15 --cv HGDP_GRIDS.bed $K | tee Admixture_${K}.out; done

##And finally on main computer
##
##I should try to see what happen when I do QC filtering... anyway
for K in {1..10}; do
admixture -j30 --cv HGDP_GRIDS.bed $K | tee Admixture_${K}.out; done


##24/06/22
##Ok ok, so I left stuff running that I will check once I arrive to the hotel
#For now, lets focus in the saturation plots and keep on mind the larger plan
#* Admixture CV for hgdp + test
#* Admixture CV for hgdp + test prunning
#* Smartpca PCA (eigen loading variance is equal to 100*eigenval/sum(eigenval))
#* Convert back rs id names on GRIDS vcf AND place names from HGDP reference as most likely plink uses rsIDs as way to asses PRS
#* plink --recode 12 for matrix convertion and saturation analysis

#In terms of presentation
##If I'm allowed only 2 slides I should use first to discuss question, how, then result
##then another slide with limitations, challenges, and future perspective on how to scale, for admixture analysis is better to use pcas instead
##and if PCAs is a common routine, better to use procrustes for simple batch imputations
##Also, extra points of challenges when merging data, changing naming schema, AWS credentials, etc etc

#In terms of documentation, I should make a basic github with a readme markdown explaining what I did + curated scripts. 
#No need to complicate myself with juypter notebook + pdf report (if I had the time I would)

##Anyway, should I start with the markdown or the snps?
#My bad, I forgot to install R in Ubuntu for windows. I can still use R on windows though. 
#That said, I cannot access to plink withouth internet so I can only theoretically program the matrix... or awk commands
##Lets create a table of 0s and 1s based on the  frequencies seen in the original vcf write into a table of 0s and 1s and start from there
## ok ok 
##Nope those values got stuck online and the file I passed is corrupt (windows interpreted .vcf as a vcard file and is corrupt)
##Anyway, lets replicate 1575 individuals by 50223 cells, take into consideration the expected allele frequencies though
#     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
#0.0006349 0.1873020 0.3371430 0.3918606 0.5657140 1.0000000
##No, actually I do have the allele frequencies on rsIDs_alleles.tsv, I just have to convert them in Ubuntu
#awk -F"\t" '{key=$1; for(i=2; i<= NF; i++){split($i,info,":"); if((info[1]=="1/1")||(info[1]=="0/1")){insid[key]=insid[key]+info[2]}else{out[key]=out[key]+info[2]} } } END{for(key in insid){print key"\t"insid[key]"\t"out[key]"\t"(insid[key]/(insid[key]+out[key]))}}' rsIDs_alleles.tsv > Snp_probability.tsv
#Cool now to R
##R code on Windows Rstudio
##Im forgetting (should've sleep more and annotate what I wanted to do) why I wanted logical values. I know is to compare
##Right, to check at N events I just have to create a random sequence with no replacement
#Then I start from one
#Then sum, then next sequence I jsut make and OR, then sum, then again, then again, till sample was completed, cool
##Also, as each comparison is independent I can multithreat this, in c++ or matlab will be cool as well, but vector operations seems easier in R
##Just noted that alleles frequencies were lost somehwere somehow, maybe due to rsID? Yeah, most likely, well  still code holds true
R
##Select working directory
setwd("C:/Users/Amhed/OneDrive/Desktop/GRID_test")

##read snp frequencies
tt=read.table("Snp_probability.tsv",sep="\t",header=F)

colnames(tt)=c("id","in","out","freq")

##Some alleles are fixed (i.e. present in all the population, that leads to NAs in out)
tt[is.na(tt[,"out"]),"out"]=rep(0,sum(is.na(tt[,"out"])))
##I should add a seed to maintain analysis comparable
set.seed(42)

mat=matrix( nrow = nrow(tt), ncol = 1575)

for(i in 1:nrow(mat)){
  mat[i,]=sample(x = c(rep(1,tt[i,"in"]),rep(0,tt[i,"out"])), size = 1575, replace = FALSE)
}

##Cool, now lets save it into a table for future reference
write.table(mat,"simulated_data.tsv",sep="\t",row.names = as.character(tt[,1]), col.names = FALSE)

##Ok, first lets try a simple bootstrap approach, for that lets convert the matrix to a logical value
newmat= (mat == 1)
##Then

##Im forgetting (should've sleep more and annotate what I wanted to do) why I wanted logical values. I know is to compare
##Right, to check at N events I just have to create a random sequence with no replacement
#Then I start from one
#Then sum, then next sequence I jsut make and OR, then sum, then again, then again, till sample was completed, cool
##Also, as each comparison is independent I can multithreat this, in c++ or matlab will be cool as well, but vector operations seems easier in R

bootstraps=10
individuals=1575
resmat=matrix(0,nrow=bootstraps, ncol=individuals)
#Just in case need for comparable results
set.seed(42)

for(i in 1:nrow(resmat)){
  seq=sample(1:individuals,size = individuals,replace=FALSE)
  ##Technically this provides first appearance; I could also make a function that retrieves the sum at each point, basically a two loop summing at every pos but that sounds inneficient.. can try it thouhg
  dat=table(apply(newmat[,seq],1,function(x){which.max(x)}))
  resmat[i,as.integer(names(dat))]=dat
}

##resmat have now the increments, to get the cumulative plot I can apply now cumsum
bootmat=t(apply(resmat,1,cumsum))

##Saturation plots seems there, however I dont know if this is what I was expecting (Roberto mentioned that snps should not be saturated though...)
##But maybe is due to a low number of samplings I should increase the bootstraps to 1K
##I get the reason to see few increments after the first ones, the problem is that I dont understand why I should exclude the first individuals
##But makes sense a population equal to 1, the next individual will contribute a lot of snps, then the larger the lower, the fact we see an asymptotic curve is just reflect of the effective population seen already in humans
#The theoretical expansion of the coalescent theory is true for a Ne really large, but as far as I remember, from all the evolutionary analysis of humans, the Ne is low in human due to bottle necks effects, even chimpanzees have a larger diversity and higher Ne, I guess makes sense to see saturation quite easily
##Did Roberto and others misunderstood the rarefaction analysis? or was I... mmm better do graphs and see if I obtain a similar number of Ne
##Then, wheter we can argue there's a reason to keep sequencing more individuals, thats a different question
##That said, the segregation sites in humans might be low-sampled, though original experiments in hapmap does not show that
bootstraps=1000
individuals=1575
resmat=matrix(0,nrow=bootstraps, ncol=individuals)
#Just in case need for comparable results
set.seed(42)

for(i in 1:nrow(resmat)){
  seq=sample(1:individuals,size = individuals,replace=FALSE)
  ##Technically this provides first appearance; I could also make a function that retrieves the sum at each point, basically a two loop summing at every pos but that sounds inneficient.. can try it thouhg
  dat=table(apply(newmat[,seq],1,function(x){which.max(x)}))
  resmat[i,as.integer(names(dat))]=dat
}

##resmat have now the increments, to get the cumulative plot I can apply now cumsum
bootmat=t(apply(resmat,1,cumsum))

##Anyway, the computation of 1K bootstraps was not so long, 10K will be thought but at that point is better to use parallel processing
#The simulated data set reaches saturation quite easily
##If I remember fine, the number of segregating sites assumes an infinite model and goes to an asymptop due to mutation

##Lets do the bootstrap not based on frequency to wrap around my head over the idea, which now is vanishing bu in my mind
#Rather than asking how many individuals to get n snps, we can think of how many individuals to see n snp, then is matter of adding up frequencies.. which now I see whats the issue
#Thats the expected behaviour if no LD and assuming we get lucky with the first individual
##Better do the proper bootstrap and SUM and then lets see how it looks

###So lets see how it works with a bootsrap approach

###Ok, new approach to compare
bootstraps=100
individuals=1575
resmat=matrix(0,nrow=bootstraps, ncol=individuals)
otmat=matrix(0,nrow=bootstraps, ncol=individuals)
#Just in case need for comparable results
set.seed(42)

for(i in 1:nrow(resmat)){
  seq=sample(1:individuals,size = individuals,replace=FALSE)
  ##Technically this provides first appearance; I could also make a function that retrieves the sum at each point, basically a two loop summing at every pos but that sounds inneficient.. can try it thouhg
  dat=table(apply(newmat[,seq],1,function(x){which.max(x)}))
  resmat[i,as.integer(names(dat))]=dat
  nd=c()
  vals=rep(FALSE,nrow(newmat))
  for(j in seq){
    vals=(vals|newmat[,j])
    nd=append(nd,sum(vals))
  }
  otmat[i,]=nd
}



###Note aside, I just got access to the admixture analysis in the VM and seems it worked like a charm
##Lets on one side, do prunning and redo admixture, and in the other see if I can install smartpca
mkdir prunning
cp MasterPanel_plus_samples/HGDP_GRIDS.bim prunning/
cp MasterPanel_plus_samples/HGDP_GRIDS.bed prunning/
MasterPanel_plus_samples/HGDP_GRIDS.fam prunning/
cp MasterPanel_plus_samples/HGDP_GRIDS.log prunning/

##Lets check basic plink commands for prunning

##Some examples
plink --bfile hapmap1 --missing --out miss_stat 
plink --bfile hapmap1 --freq --out freq_stat 
plink --bfile hapmap1 --indep-pairwise 50 10 0.2 --out prune1
 plink --bfile wgas3
 --extract prune1.prune.in
 --genome
 --out ibs1

##e.g.
plink \
    --bfile HGDP_GRIDS \
    --maf 0.01 \
    --hwe 1e-6 \
    --geno 0.01 \
    --mind 0.01 \
    --write-snplist \
    --make-just-fam \
    --out HGDP_GRIDS.QC


    plink \
    --bfile HGDP_GRIDS \
    --keep HGDP_GRIDS.QC.fam \
    --extract HGDP_GRIDS.QC.snplist \
    --indep-pairwise 200 50 0.25 \
    --out HGDP_GRIDS.QC

    plink \
    --bfile HGDP_GRIDS \
    --extract HGDP_GRIDS.QC.prune.in \
    --keep HGDP_GRIDS.QC.fam \
    --het \
    --out HGDP_GRIDS.QC


    plink \
    --bfile HGDP_GRIDS \
    --extract HGDP_GRIDS.QC.prune.in \
    --rel-cutoff 0.125 \
    --out HGDP_GRIDS.QC

    plink \
    --bfile HGDP_GRIDS \
    --make-bed \
    --keep HGDP_GRIDS.QC.rel.id \
    --out HGDP_GRIDS.QC.Final \
    --extract HGDP_GRIDS.QC.snplist

##25/06/22
##Ok admixture analysis of combined samples plus the ones for ld prunning is done
#Lets run smart pca as well
##In VM
cd /home/ec2-user/software
wget https://github.com/DReichLab/EIG/archive/v7.2.1.tar.gz
tar xvfz v7.2.1.tar.gz 
#"../bin/smartpca -p parfile >logfile"
#genotypename: input genotype file (in any format: see ../CONVERTF/README)                                                                                                   snpname:      input snp file      (in any format: see ../CONVERTF/README)                                                                                                   indivname:    input indiv file    (in any format: see ../CONVERTF/README)                                                                                                   evecoutname:  output file of eigenvectors.  See numoutevec parameter below.                                                                                                 evaloutname:  output file of all eigenvalues                                                                                                                                                                                                                                                                                                            OPTIONAL PARAMETERS:                                                                                                                                                                                                                                                                                                                                    numoutevec:     number of eigenvectors to output.  Default is 10.                                                                                                           numoutlieriter: maximum number of outlier removal iterations.                                                                                                                 Default is 5.  To turn off outlier removal, set this parameter to 0. 

##After a long break I think Im ready to continue and finish the analysis then I can plot and document
#Ok, smartpca works as it used to, however I need to make the par file (read documentation above)
#numoutevec:     number of eigenvectors to output.  Default is 10.
#numoutlieriter: maximum number of outlier removal iterations.                                                                                                                 Default is 5.  To turn off outlier removal, set this parameter to 0.
###That said, smartpca is not compiled, maybe in previous version
##Worse case scenario I can use a simple MDS of plink
##Its compiled, but for some reason requires this library to work
#libgfortran.so.3
###Found instalaltion on web
##Nee to add to  /etc/apt/sources.list
echo "deb http://gb.archive.ubuntu.com/ubuntu/ bionic main universe" >> /etc/apt/sources.list
sudo apt-get install g++-6
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 6
sudo apt-get install libgfortran3
###Apparently I can only install packages trhough yum in amazon
##Lets connect to main workstation, see if I can install eigensoft and from there see if I run it here
#Othersie I just use MDS from plink, first components are the same
###Coolm I just compiled smartpca v7 on SG-01
##I can maybe recrompress and send to amazon Vm
##For some reason I cant access to main computer, I should pass as much as I can to vm
#Fortunately I saved old results in the NAS (good job Amhed from the past)
###Not really, ok, lets copy the files from amazon VM to SG lab, run analysis there, copy results of my own and plot tomorrow
##On the meantime, I can leave running another Admixture where I specifically remove the duplicated individuals coming from the GRIDS set
##(that only removes the duplicated individuals but is not perse prunning. I can remove still those snps not passing ld)
cp ../../grids-technical-test-datasets/gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf .
plink --vcf gnomad.genomes.v3.1.hgdp_1kg.VBI2_PGS_vars.EAS_SAS_10AMR_samples.dense.vcf --make-bed --out GRID_originak_test
plink --bfile HGDP_GRIDS --remove GRID_originak_test.fam --make-bed --out HGDP_GRIDS_remove_dup_ind
##Cool, after removal we have 50223 variants and 4239 people pass filters and QC. 
##Some names were lost I imagine, lets perfom now variant prunning for ld
##If not many snps are lost, then I continue analysis, otherwise two analysis have to be done
plink --bfile HGDP_GRIDS_remove_dup_ind --indep-pairwise 200 50 0.25 --out prune1

plink --bfile HGDP_GRIDS_remove_dup_ind --extract prune1.prune.in --make-bed --out HGDP_GRIDS_QCed

#indep-pairwise	200 50 0.25	Informs plink that we wish to perform pruning with a window size of 200 variants, sliding across the genome with step size of 50 variants at a time, and filter out any SNPs with LD r2 higher than 0.25
##Yup Pruning complete.  9682 of 50223 variants removed.

##Now I can run Admixture on each
for K in {1..10}; do
admixture -j34 --cv HGDP_GRIDS_remove_dup_ind.bed $K | tee HGDP_GRIDS_remove_dup_ind.admixture.${K}.out; 
admixture -j34 --cv HGDP_GRIDS_QCed.bed $K | tee HGDP_GRIDS_QCed.admixture.${K}.out; 
done
##Though this will saturate the lab computer, that said, I dont trust so much more the AWS VM
##I can still run plink for the prs scores tough. Ok, before running admixture, lets compress these files

#Ok, ready to pass files to computer and then to aws
tar -zcvf to_aws.tar.gz remove_indv_plus_prunning/
scp velazqam@10.75.10.7:/home/velazqam/velazqam/Large_VCFs/MasterPanel_plus_samples/to_aws.tar.gz .
#Remaining thing is to run smartpca in files
###Lets check the par file pars
#"../bin/smartpca -p parfile >logfile"
#numoutevec:     number of eigenvectors to output.  Default is 10. I need to change it to actual clusters defined
#numoutlieriter: maximum number of outlier removal iterations.  I have to set to 0, dont want to remove any individual

genotypename: example.geno
snpname: example.snp
indivname: example.ind
evecoutname: example.pca.evec
evaloutname: example.eval
altnormstyle: NO
numoutevec: 2
numoutlieriter: 5
numoutlierevec: 2
outliersigmathresh: 6.0
qtmode: 0
#I can run the PRS scores tough
##For now, lets pass the Admixture analysis I created there
scp -i .ssh/grids-technical-test-rsa.pem to_aws.tar.gz ec2-user@54.255.224.185:/home/ec2-user/data/

###Mmmm better do the admixture in the aws instance and start already the structure in the SGB computer
##So, same commands but now in the aws
##And in the SGB lab, let stop the admixture and run the smartpca
##Ok, lets do properly the eigensoft analysis
#I will base my analysis in Roberta's nicely documented repo (australian aDNA guy)
echo "genotypename:    HGDP_GRIDS.bed
snpname:         HGDP_GRIDS.bim
indivname:       HGDP_GRIDS.fam
evecoutname: HGDP_GRIDS.pca.evec
evaloutname: HGDP_GRIDS.eval
altnormstyle: NO
numoutevec: 10
numoutlieriter: 0
" > HGDP_GRIDS.pca.par

echo "genotypename:    HGDP_GRIDS_QCed.bed
snpname:         HGDP_GRIDS_QCed.bim
indivname:       HGDP_GRIDS_QCed.fam
evecoutname: HGDP_GRIDS_QCed.pca.evec
evaloutname: HGDP_GRIDS_QCed.eval
altnormstyle: NO
numoutevec: 10
numoutlieriter: 0
" > HGDP_GRIDS_QCed.pca.par

smartpca -p HGDP_GRIDS.pca.par | tee HGDP_GRIDS.pca.log;
smartpca -p HGDP_GRIDS_QCed.pca.par | tee HGDP_GRIDS_QCed.pca.log;

##Cool it worked, lets do the admixture analysis in any case



##All panel
#sbatch CONVERTF.sh HGDP_GRIDS
##Prunned
#sbatch CONVERTF.sh HGDP_GRIDS_QCed


##So, Lets imagine the figure
#Panel A
##Reference panel + GRIDS admixture
##Reference panel - Duplicated samples + GRIDS admixture
##Reference panel - Duplicated samples + GRIDS - Prunned snps

#Panel B
#PCA analysis of Reference panel + GRIDS
##Suplementall PCA analysis of Reference panel - Duplicated samples + GRIDS admixture - Prunned snps
#There make note of procrustes analysis (make only an example if theres time)

##Note that I have as reference GRIDS alone, Reference Panel + GRIDS (x3), Reference Panel prunned out test, admixture analysis
##I have to make yet

##Then other slide
##PRS score tables on the major components of GRIDS test specific samples
#Some nice examples and overall statics

##Then final slide
#Basic matrix explaining algorithm of expectation probability and other bootstrap of applies
#Graph of saturation plots fitted to the coalescent theory. Make statement about the low Ne in humans and how infact we do expect to see saturation
##Suplemental slide How can we acelerate this process (if time code algorithm in parallel, openmp library for c++ and benchmark)

##As for documentation
#github with this script
#readme markdown explaining directory and crucial things for the team such as errors with the files, change of names, not aws credentials, etc.
##also, the readme markdown have to mention which programs I used (no need to provide code for installation)
##then three simple directories with
#'data' code to download and format files into plink. Also, if the space allows it add plink files for new GRIDS (names changed) and GRIDS + panel
#'analysis' code to run admixture cv, run structure, generate prs, and (only if I have time to code the openmp implementation that produces the table for the bootstrap)
#'results' code to plot data

##Finally, a pdf document with a written report, plus material an methods describing programs used, references and final benchmarks
##Ok ok, thats a plan though not sure if I'll manage on time for tomorrow.

###26/06/22
#Ok, Analysis should be done, let's compress them and send back to my computer.
##Remember the plan
##Slide 1
#Tittle
#2
#Question
#Challenges
#3
#Panel A
##Reference panel + GRIDS admixture
##Reference panel - Duplicated samples + GRIDS admixture
##Reference panel - Duplicated samples + GRIDS - Prunned snps
#Panel B
#Structure
##...

##Ok, I need to check where is the admixtures
##And structures
#SGB-lab K=8
#AWS-VM  K=8

##I can start looking for what would be the visualization program
#On one side pong makes nice figures but I dont think is the best for setting in a pipeline
##What about making the figure in pong AND R, get the best publishable picture
#And report both codes as alternatives
##Cool, I'll download the data from AWS-VM and install pong in my computer (as well as the other libraries required)
##Maybe I should also install plink just in case thought not sure how reliable is "Ubuntu on Windows"
#AWS data is also in k=8
##better try to install plink and pong on my laptop
#plink done
#mmm I didnt save the commands to install pong
#easy
pip install pong
#forgot how easy is python program instalaltions when all dependencies are fine
##That said is taking time to install, on the meanwhile, get the R code done 
#From what I can read of the pages below, admixture plots have not been really improved in R. I can simply re-use my old code
#https://luisdva.github.io/rstats/model-cluster-plots/
#https://github.com/TCLamnidis/AdmixturePlotter
#https://github.com/esteinig/netviewr

##Regarding the PRS scores interpretation, I found this (Note to myself, recommended to read)
#https://www.nature.com/articles/s41596-020-0353-1
#though it should be fine to just use the tutorial of plink:
#https://choishingwan.github.io/PRS-Tutorial/target/
#https://choishingwan.github.io/PRS-Tutorial/plink/

##Take into account that I can use either the admixture analysis or the PC analysis to account for data stratification
##I can compare both, they should in theory provide same results. That said, will be interesting showing that as an extra slide
#or for the calculations. Also, that provides a better argument of why pcas, mds, or any other euclidean metric is much better than using the clusters determined by admixture
#ok, download the c++ code on my git and check later

##Also, I need to download the code for hamming distances with openmp, I think I can easily reporpouse this code for improving the bootstrap analysis
##Then is just matter of testing it and benchmarking. I can use IBEX for that (Rome processor 128 cores)
##DONE

##Also, I need to get from history how I ran the sbatch and also how did I compiled the code, I remember the flag was something like -mp
#can check history of IBEX later (though I think I compiled it on my computer, which, for a strange reason I dont have access to...) 

###Ok, so after a long time out, I can now focus in finishing the test
##First let's sure I have all the admixture and structure info in my computer
##SGB lab
tar -zcvf All_SGB_lab.tar.gz MasterPanel_plus_samples/ 
scp velazqam@10.75.10.7:/home/velazqam/velazqam/Large_VCFs/All_SGB_lab.tar.gz .
##Amazon VM


##Ok, data downloaded, read how to make PRS in pllink
tar -zcvf data_final_from_aws_vm.tar.gz data/
scp -i .ssh/grids-technical-test-rsa.pem ec2-user@54.255.224.185:/home/ec2-user/data_final_from_aws_vm.tar.gz .

##For PRS calculation just stratify based on population
#https://choishingwan.github.io/PRS-Tutorial/
#https://zzz.bwh.harvard.edu/plink/profile.shtml
##no need for fancy models

##As for openmp and how I run stuff on IBEX
g++ -fopenmp read_mRNA_hamming_omp_fm.cpp
srun --time=11:00:00 --mem=120G --nodes=1 -c 120 --pty bash -l

##27/06/22
##One extra day of working, I passed all the data to my computer, I just need to plot.
##Lets go with  pong


##Ok, now in computer lets go to a single directory and store everything there
mkdir Analysis
cd Analysis

mv ../data_final_from_aws_vm.tar.gz . 
mv ../All_SGB_lab.tar.gz .
tar xfvz data_final_from_aws_vm.tar.gz
tar xfvz All_SGB_lab.tar.gz

mkdir Admixture
cd Admixture
mkdir A
mkdir B
mkdir C

##And structure too
mkdir Structure 
cd Structure/

cp ../MasterPanel_plus_samples/remove_indv_plus_prunning/*.pca.* .

##Now lets plots
##Lets try with pong
##I need to create a map file with
#col1:runID #col2:K #col3:location of Q file

##But first I have the order the files by population using the fam file. I need, to check but I think I have already the name conversions from the original set

##Lets copy the fam files nonetheless and modyfing them using awk


##Ok, so apparently the  popul;ations were badly formatted. I can get them from HGDP in json format.
awk -F"\t" '{print $1"\t"$11}' gnomad.genomes.v3.1.2.hgdp_1kg_subset_sample_meta.tsv| awk -F"\t" '{split($2,info,","); split(info[1],proj,":"); split(info[2],reg,":"); split(info[3],pop,":"); split(info[4],gen,":"); print $1"\t"proj[2]"\t"reg[2]"\t"pop[2]"\t"gen[2]}' | perl -pe 's/"//g' > HGDP_1K_pops.tsv 
grep "GRIDS" HGDP_GRIDS.fam | awk '{split($1,info,"-"); print $1"\t"info[1]"\tGRIDS\tGRIDS\tGRIDS"}' >> HGDP_1K_pops.tsv 
##Now let's jsut reformat the fam files
awk -F"\t" '{if(NF==5){hash[$1]=$3}else{split($0,info," "); name="unknown"; if(hash[info[1]] != ""){name=hash[info[1]]}; print info[1]"\t"name}}' HGDP_1K_pops.tsv  HGDP_GRIDS.fam > HGDP_GRIDS.indpos.txt
awk -F"\t" '{if(NF==5){hash[$1]=$3}else{split($0,info," "); name="unknown"; if(hash[info[1]] != ""){name=hash[info[1]]}; print info[1]"\t"name}}' HGDP_1K_pops.tsv  HGDP_GRIDS_remove_dup_ind.fam > HGDP_GRIDS_remove_dup_ind.indpos.txt
awk -F"\t" '{if(NF==5){hash[$1]=$3}else{split($0,info," "); name="unknown"; if(hash[info[1]] != ""){name=hash[info[1]]}; print info[1]"\t"name}}' HGDP_1K_pops.tsv HGDP_GRIDS_QCed.fam > HGDP_GRIDS_QCed.indpos.txt

awk '{print $2}' ../HGDP_GRIDS.indpos.txt > ind2pop
pong -m test.map --ind2pop ind2pop

##HTML color codes to choose
#f8c471
#82e0aa
#73c6b6
#85c1e9
#bb8fce
#f1948a
#229954
#2471a3
#bfc9ca
#e59866

##Does not look bad, I just need a bit of clustering
##That said, lets only plot the Admixture with the lowest CV for each
###Soo, GRIDS + All reference panel
##10 K, but technically convergence starts from K =5, CV only indicates what is a reasonable (sensible) idea for the K to use
#Admixture_1.out:CV error (K=1): 0.59339                                                                                                                                     
#Admixture_2.out:CV error (K=2): 0.55364                                                                                                                                     
#Admixture_3.out:CV error (K=3): 0.52783                                                                                                                                     
#Admixture_4.out:CV error (K=4): 0.52210                                                                                                                                     
#Admixture_5.out:CV error (K=5): 0.51748                                                                                                                                     
#Admixture_6.out:CV error (K=6): 0.51654                                                                                                                                     
#Admixture_7.out:CV error (K=7): 0.51552                                                                                                                                     
#Admixture_8.out:CV error (K=8): 0.51498                                                                                                                                     
#Admixture_9.out:CV error (K=9): 0.51455
#Admixture_10.out:CV error (K=10): 0.51407                                                                                                                                   

###GRIDS + Ref Panel - DupInd
##Same Idea, even more complicated to interpret due to not sites
#HGDP_GRIDS_remove_dup_ind.admixture.1.out:CV error (K=1): 0.60039                                                                                                           
#HGDP_GRIDS_remove_dup_ind.admixture.2.out:CV error (K=2): 0.55423                                                                                                           
#HGDP_GRIDS_remove_dup_ind.admixture.3.out:CV error (K=3): 0.53012                                                                                                           
#HGDP_GRIDS_remove_dup_ind.admixture.4.out:CV error (K=4): 0.52518                                                                                                           
#HGDP_GRIDS_remove_dup_ind.admixture.5.out:CV error (K=5): 0.51926                                                                                                           
#HGDP_GRIDS_remove_dup_ind.admixture.6.out:CV error (K=6): 0.51869                                                                                                           
#HGDP_GRIDS_remove_dup_ind.admixture.7.out:CV error (K=7): 0.51746                                                                                                           
#HGDP_GRIDS_remove_dup_ind.admixture.8.out:CV error (K=8): 0.51680                                                                                                           
#HGDP_GRIDS_remove_dup_ind.admixture.9.out:CV error (K=9): 0.51616
#HGDP_GRIDS_remove_dup_ind.admixture.10.out:CV error (K=10): 0.51582 
##Techinically I could go even to higher K just to try to recover chunks, but I dont think it will happen, due to diversity on samples, most likely everything will be admixed.
#The PCA, MDS, or any other metric should be better at showing which population is closest to the GRIDS data

##GRIDS_Qced
#HGDP_GRIDS_QCed.admixture.1.out:CV error (K=1): 0.59672                                                                                                                     
#HGDP_GRIDS_QCed.admixture.2.out:CV error (K=2): 0.55435                                                                                                                     
#HGDP_GRIDS_QCed.admixture.3.out:CV error (K=3): 0.53090                                                                                                                     
#HGDP_GRIDS_QCed.admixture.4.out:CV error (K=4): 0.52604                                                                                                                     
#HGDP_GRIDS_QCed.admixture.5.out:CV error (K=5): 0.52014                                                                                                                     
#HGDP_GRIDS_QCed.admixture.6.out:CV error (K=6): 0.51957                                                                                                                     
#HGDP_GRIDS_QCed.admixture.7.out:CV error (K=7): 0.51836                                                                                                                     
#HGDP_GRIDS_QCed.admixture.8.out:CV error (K=8): 0.51771                                                                                                                     
#HGDP_GRIDS_QCed.admixture.9.out:CV error (K=9): 0.51708                                                                                                         
#HGDP_GRIDS_QCed.admixture.10.out:CV error (K=10): 0.51674                                                                                                                   

##Not bad, but still does not show the actual data. What about I just print the data of the samples more relevant to the analysis?
##Lets save the plots, keep them as supplemental, reorder, and recommend pong as an alternative

##Alos names are repeated, lets fuse (names comes from different panels and that caused mis visualization)
##Lets fuze
#Europe with EUR
#Central_South_Asia with SAS
##No, it does not make sense due to the origin of sample
##But I think I have an idea of how to plot the individuals
##Lets multiply each cluster by 1000 and at them up and then order, that will order data based on precedence of clusters
##And lets plot 10, just to show all the samples
#Ok ok, save pong figures, plot admixtures in R, and that it for it
##From there with R lets also get properly the imputation for the individuals to use for the PRS analysis
## Nope, cumulative of each cluster is to one
##Also it looks horrible, ok, lets go to original plan of use pong, change names and order a ccording to puplation that I'll use
##Let's order the Q files with R, then use pong to plot
##Which populations and in which order?
#A
#1 null
#893 AFR 
#110 Africa
#633 EUR
#155 Europe
#162 Middle_East
#30 Oceania
#490 AMR
#62 America
#1575 GRIDS
#601 SAS
#189 Central_South_Asia 
#240 East_Asia 
#585 EAS

#B
##Done the same

#C
##Done the same

#Lets plot structure analysis, ok, I have to add population name to evec and then plot

#28/06/22
##Ok, I will not have much time today nor tomorrow to work so better wrap up everything.
#Start by getting figures of Admixture and structure ready
#Follow by stratify the original vcf with the admixture clusters and do the PRS calculation
#And then answer the questions on exercise 3
#By first recoding with plink and then running both approaches (should be done within one hour so better start with that)
##Note that on its first slie I have only to describe the algorithm and the second is fine to show graph and interpolate to calculate Ne
#Again, by literature estimates should be low
#From /home/velazqam/Analysis/Rarification
##copy vcf data with other names, it does not matter really
cp ../data/MasterPanel_plus_samples/grids-technical-test.vcf.bgz .
bgzip -d grids-technical-test.vcf.bgz
##Note that plink changes the allelic order in cases a large MAF is present.
plink --vcf grids-technical-test.vcf --keep-allele-order --transpose --allow-no-sex --recode12 --out GRID_test
#So tped have information of alleles, 0 missing, 1 Major, 2 minor
##also first columns are just information of the SNP
#Ok, lets convert this into a table ready to use in R
awk '{for(i=5; i <= NF; i=i+2){if(($i == 2)||($(i+1)==2)){printf "1\t"}else{printf "0\t"}}; printf "\n"}' GRID_test.tped > ApearingSnps.tsv
##It worked though not sure what I should do with the estimations, bassically shows there's a low effective population size as kwon in humans
##https://www.cambridge.org/core/journals/genetics-research/article/effective-population-size-of-current-human-population/E767DDCB8E895844FA35C9C44FA8B62F

##Ok, Admixture figures, K to use 10 of pong, do panels as intended. Clustering would have been bettter within GRIDS but not enough time on my side

###Lets graph properly the SNP saturation plots

##Lets try now with real data
mat=as.matrix( read.table("ApearingSnps.tsv",sep="\t",header=F))
torem=apply()
newmat= (mat == 1)

##Apparently there's some snps not with frequency 0 in the dataset. How is that even possible?
#I can use plink to get the frequencies though
freqs=apply(newmat,1,function(x){sum(x,na.rm = T)/length(x)})
exp=1/freqs
Seens=table(round(exp))

plot(as.integer(names(Seens)),Seens)

bootstraps=100
individuals=ncol(mat)
resmat=matrix(0,nrow=bootstraps, ncol=individuals)
#Just in case need for comparable results
set.seed(42)

for(i in 1:nrow(resmat)){
  seq=sample(1:individuals,size = individuals,replace=FALSE)
  dat=table(apply(newmat[,seq],1,function(x){which.max(x)}))
  resmat[i,as.integer(names(dat))]=dat
}

##resmat have now the increments, to get the cumulative plot I can apply now cumsum
bootmat=t(apply(resmat,1,cumsum))
MedBoot=apply(bootmat,2,median)
SdBoot=apply(bootmat,2,sd)

plot(1:individuals,MedBoot,type="l",col="black")
points(1:individuals,c(MedBoot + SdBoot),col="red")
points(1:individuals,c(MedBoot - SdBoot),col="red")

##Number of segregation sites as function of genomes sequenced
MedRes=apply(resmat,2,median)
SdRes=apply(resmat,2,sd)

plot(1:individuals,MedRes,type="l",col="black")
points(1:individuals,c(MedRes + SdRes),col="red")
points(1:individuals,c(MedRes - SdRes),col="red")

##What about if I asume a pop larger than 10
plot(11:individuals,MedRes[-c(1:10)],type="l",col="black")
points(11:individuals,c(MedRes[-c(1:10)] + SdRes[-c(1:10)]),col="red")
points(11:individuals,c(MedRes[-c(1:10)] - SdRes[-c(1:10)]),col="red")

##What about if I asume a pop larger than 100
plot(101:individuals,MedRes[-c(1:100)],type="l",col="black")
points(101:individuals,c(MedRes[-c(1:100)] + SdRes[-c(1:100)]),col="red")
points(101:individuals,c(MedRes[-c(1:100)] - SdRes[-c(1:100)]),col="red")

##What about if I asume a pop larger than 50
plot(51:individuals,MedRes[-c(1:50)],type="l",col="black")
points(51:individuals,c(MedRes[-c(1:50)] + SdRes[-c(1:50)]),col="red")
points(51:individuals,c(MedRes[-c(1:50)] - SdRes[-c(1:50)]),col="blue")

##What about if I asume a pop larger than 50
plot(88:individuals,MedRes[-c(1:87)],type="l",col="black")
points(88:individuals,c(MedRes[-c(1:87)] + SdRes[-c(1:87)]),col="red")
points(88:individuals,c(MedRes[-c(1:87)] - SdRes[-c(1:87)]),col="blue")

#
##What about if I asume a pop larger than 50
plot(1:90,MedRes[c(1:90)],type="l",col="black")
points(1:90,c(MedRes[1:90] + SdRes[1:90]),col="red")
points(1:90,c(MedRes[1:90] - SdRes[1:90]),col="blue")

##So, there are snps that infact have a frequency equal to zero

##Ok, final remaining things,
##One, plot structure data, does not matter if plot is not thaaat fancy
##2 PRS with stratificated data
##3 Plot data of saturation 







