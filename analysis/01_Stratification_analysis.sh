#Copy files
cp grids-technical-test.vcf.bgz ..
bgzip -d grids-technical-test.vcf.bgz

##Note that plink changes the allelic order in cases a large MAF is present.
plink --vcf grids-technical-test.vcf --keep-allele-order --allow-no-sex --make-bed --out GRID_test

##Data analysis
for K in {1..10}; do
admixture -j34 --cv HGDP_GRIDS_remove_dup_ind.bed $K | tee HGDP_GRIDS_remove_dup_ind.admixture.${K}.out; 
admixture -j34 --cv HGDP_GRIDS_QCed.bed $K | tee HGDP_GRIDS_QCed.admixture.${K}.out; 
done

smartpca -p HGDP_GRIDS.pca.par | tee HGDP_GRIDS.pca.log;
smartpca -p HGDP_GRIDS_QCed.pca.par | tee HGDP_GRIDS_QCed.pca.log;
