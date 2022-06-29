#Copy files
cp grids-technical-test.vcf.bgz ..
bgzip -d grids-technical-test.vcf.bgz

##Note that plink changes the allelic order in cases a large MAF is present.
plink --vcf grids-technical-test.vcf --keep-allele-order --allow-no-sex --make-bed --out GRID_test

##Data analysis
grep -v "#" PGS000658.txt > PRS_1
plink --bfile GRID_test --score PRS_1 1 4 6 header
mv plink.profile PRS_1.profile

grep -v "#" PGS002268.txt > PRS_2
plink --bfile GRID_test --score PRS_2 1 4 6 header
mv plink.profile PRS_2.profile
