#!/bin/bash
if [[ -f "/data/server.lock" ]]; then
    /sirius/bin/catapult.recovery /chainconfig
fi

if [[ -f "/data/recovery.lock" ]]; then
    echo "unable to recover corrupted chain data.  Run the restore.sh script"
fi

/sirius/bin/sirius.bc /chainconfig