# UVM Framework

A local copy of [UVM Framework][UVMF].

## LFS

This repo uses [`git lfs`][LFS] to store binary files. Only `*.pdf` files for now, but could add more extensions in the future if needed by running `git lfs track "*.pdf"`.

Users should run `git lfs install` to activate lfs features on the repository.

## Updates

When new versions of UVMF appear, they're downloaded and extracted to fully replace the `UVMF` directory. `git add UVMF` takes care of generating diffs accordingly.


[UVMF]: https://verificationacademy.com/topics/verification-methodology/uvm-framework
[LFS]: https://git-lfs.com/
