# Testing of LncRAnalyzer with planemo [https://pypi.org/project/planemo/] for Galexy server integration

1. We have created lncrnalyzer.xml file for planemo test
2. Next, we created python v3.13 environment using conda
```
conda create -n python3.13 conda-forge::python=3.13
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
