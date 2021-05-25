# DSD final project T1(RISCV)

## Author
```
b07901068 黃敬騰
b07901001 羅元鈞
b07901018 柯建廷   
```

## Workstation Usage
```
- Ncverilog 
    - source /usr/cad/cadence/cshrc
- Nwave
    - source /usr/cad/synopsys/CIC/verdi.cshrc
- Design Compiler
    - source /usr/cad/synopsys/CIC/synthesis.cshrc
```

## Git usage
```
- Clone repo
    - git clone https://github.com/JeterHwang/DSD.git
- See newest version
    - git pull
- Upload your change
    - git add .
    - git commit -m "update"
    - git pull
    (solve any conflicts if it exist)
    - git push
```
## 2021/5/22
```
1. add RISCV_pipeline.v
2. finish input/output port declaration(the bandwidth of EX, M, WB signal still need to be fixed)
3. unfinish : I/D cache stall control unit
```

## 2021/5/25
```
1. unresolved : JALR hazard
```