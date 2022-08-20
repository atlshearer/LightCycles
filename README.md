# Light Cycles

A Tron inpsired light cylces game that runs on an FPGA.

## Build

```bash
cd src
quartus_sh --flow compile LightCycles
quartus_pgm --mode=jtag -c "USB-Blaster" --operation="p;output_files/LightCycles.sof"
```
