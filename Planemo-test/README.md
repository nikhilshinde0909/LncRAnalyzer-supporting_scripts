# Testing and uploading LncRAnalyzer to Galaxy-toolshed using planemo [https://pypi.org/project/planemo/]

1. We have created lncrnalyzer.xml file for planemo test
2. Next, we created python v3.13 environment using conda
```
mamba create -n python3.13  anaconda::python=3.13.2
```
3. We activated python3.13 and install planemo in this environment
```
conda activate python3.13
pip install planemo
```
4. Next, with lncranalyzer.xml we performed planemo test with dummy files in test-data folder as follows
```
planemo test lncranalyzer.xml
```
5. This was succeed and output the  tool_test_output.html and tool_test_output.json
6. LncRAnalyzer is ready for integration to galaxy workflow engine
7. Create .shed.yml and add details to it as follows
```
echo 'name: lncranalyzer' >.shed.yml
echo 'owner: nikhilshinde0909' >>.shed.yml
echo 'description: A pipeline for lncRNAs and Novel Protein Coding Transcripts (NPCTs) identification using RNA-Seq' >>.shed.yml
echo 'homepage_url: https://gitlab.com/nikhilshinde0909/LncRAnalyzer' >>.shed.yml'category: Transcriptomics' >>.shed.yml
echo 'type: unrestricted' >>.shed.yml
```
8. Create ~/.planemo.yml file and paste content for login
```
nano ~/.planemo.yml
content to paste
sheds:
  toolshed:
    key: <API KEY>
```
10. Login to galaxy toolshed
```
planemo shed_login --shed_target toolshed
```
9. Init toolshed
```
planemo shed_init
```
10. Perform shed_lint
```
planemo shed_lint --biocontainers
```
11. Create repoistory
```
planemo shed_create --shed_target toolshed
```
12. Update repository with current version
```
planemo shed_update --shed_target toolshed --repository lncranalyzer --install
```
13. Upload repository as follows
```
planemo shed_upload --shed_target toolshed
```
