# DO NOT DELETE
## Test project

```mermaid
pie title Pets adopted by volunteers
    "Dogs" : 386
    "Cats" : 85
    "Rats" : 15
```


# BCPT
|BCPT Suite|Codeunit ID|Codeunit Name|Operation|Status|Duration|Duration (Base)|Duration (Diff)|SQL Stmts|SQL Stmts (Base)|SQL Stmts (Diff)|
|:---|:---|:---|:---|---:|:--:|---:|---:|---:|---:|---:|
|10USERTEST|60003|BCPT Create PO with N Lines|Scenario|✔️|276.00|368.00|-92.00|211|211|0|
||||Enter Account No.|✔️|8.00|9.00|-1.00|8|8|0|
||||Enter Line Item No.|✔️|5.00|8.00|-3.00|3|3|0|
||||Add Order|✔️|7.00|7.00|0.00|9|9|0|
||||Enter Line Quantity|✔️|7.00|9.00|-2.00|6|6|0|
||60007|BCPT Detail Trial Bal. Report|Scenario|✔️|4,570.00|7,007.00|-2,437.00|5|5|0|
||60005|BCPT Create SQ with N Lines|Scenario|✔️|307.00|338.00|-31.00|230|230|0|
||||Enter Account No.|✔️|11.00|12.00|-1.00|10|10|0|
||||Enter Line Item No.|✔️|6.00|7.00|-1.00|4|4|0|
||||Add Order|✔️|6.00|7.00|-1.00|8|8|0|
||||Enter Line Quantity|✔️|14.00|17.00|-3.00|12|12|0|
||60004|BCPT Create SO with N Lines|Scenario|✔️|296.00|409.00|-113.00|281|281|0|
||||Enter Account No.|✔️|11.00|13.00|-2.00|11|11|0|
||||Enter Line Item No.|✔️|7.00|10.00|-3.00|7|7|0|
||||Add Order|✔️|10.00|10.00|0.00|9|9|0|
||||Enter Line Quantity|✔️|11.00|14.00|-3.00|12|12|0|
> No baseline provided. Copy a set of BCPT results to $baseLinePath in order to establish a baseline.

| Name | Required | Description | Default value |
| :-- | :-: | :-- | :-- |
| shell | | The shell (powershell or pwsh) in which the PowerShell script in this action should run | powershell |
| actor | | The GitHub actor running the action | github.actor |
| token | - [x] | The GitHub token running the action | github.token |
| parentTelemetryScopeJson | | Specifies the parent telemetry scope for the telemetry signal | {} |
| project | :white_check_mark: | Name of project to analyze or . if the repository is setup for single project | |

Test5
