clean:
  for filepath in `find input/DLLs -type f -name '*.keys' -o -name '*.aes' -o -name '*.iv' -o -name '*.map' -o -name '*.zip'`; do \
    rm -rf $$filepath ; \
  done

keys:
  @for filepath in `find input/DLLs -type f -name '*.dll'` ; do \
    echo Extracting AES keys from $$filepath ; \
    ./extract-keys --file $$filepath > $$filepath.keys ; \
    if [ -f "$$filepath" ] ; then \
      dd bs=1 if=$$filepath.keys count=64 of=$$filepath.aes ; \
      dd bs=1 if=$$filepath.keys count=32 skip=64 of=$$filepath.iv ; \
      dd bs=1 if=$$filepath.keys skip=96 of=$$filepath.map ; \
    else \
      echo Could not find extract-keys output ; \
    fi \
  done ; \
  echo Finished
