## MD5 Hash Values for MATLAB Tars (macOS)
---
|MATLAB Version |MD5 Hash Value                  |
|---------------|--------------------------------|
|MATLAB9.0      |c0376acc3511253dae4d49604b05bcbe|
|MATLAB9.1      |a1b5e47db19dd3de6a20d0e51fd17517|
|MATLAB9.2      |cab1488ee5e78ae5ec0a675845a3aee2|
|MATLAB9.3      |9fc0f0eeaa11863fd328b6db6ee34e21|
|MATLAB9.4      |c8667358ff9ff9f2e1aa6c19a8d1f619|
|MATLAB9.5      |d6fc9adc85d47a4f3fc2b4f823894558|
|MATLAB9.6      |b3179264b6259069a38851b6bc5853b7|
|MATLAB9.7      |176554d289145915bac4cd781a79b854|
|MATLAB9.9      |10ef32fc34e16ffb788dfb7fc0bd7dc6|
|MATLAB9.11     |                                |

To generate hashes: 
`for file in MATLAB9.{0..9}.app.tgz; do openssl md5 $file; done`
