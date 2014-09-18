#!/bin/sh

# read_num ()
# $1: Prompt string
# $2: Default value
# $3: Minimum value allowed
# $4: Maximum value allowed
# REPLY is a global variable that stores the user input.
read_num () {
    printf "$1 [$2]: "
    while :; do
        read REPLY
        if [ "X$REPLY" = X ]; then
            REPLY="$2"
            return
        fi
        if [ "$REPLY" -ge "$3" ] 2>/dev/null && [ "$REPLY" -le "$4" ]; then
            return
        fi
        printf "Please enter a value between $3 and $4 [default=$2]: "
    done
}

CPUS=`awk '/^processor/ {CPU=$3}; END {print CPU+1}' /proc/cpuinfo`
SSE2=`awk '/sse2/ {print "Y"; exit}' /proc/cpuinfo`
AVX=`awk '/avx/ {print "Y"; exit}' /proc/cpuinfo`
MEMTOTAL=`awk '/^MemTotal/ {print $2}' /proc/meminfo`

VER=$1
[ "X$1" = X ] && VER=2805

# Version 23.8 or above is required for 'TortureMem' INI parameter to work.
# Before 'TortureMem', mprime uses 'DayMemory' and 'NightMemory' from
# local.ini which is too complicated to support.
[ "$VER" -ge 2308 ] || exit 1

echo "Configuring touture test for mprime $(($VER/100)).$(($VER%100))"
echo

# MINFFT_MIN: Program-supported minimum of FFT size (in K)
# MAXFFT_MIN: *Minimum* allowed number for user to enter *maximum* FFT size.
if [ "$VER" -ge 2803 ]; then
    if [ "X$AVX" = XY ]; then
        MINFFT_MIN=0 MAXFFT_MIN=1
    else
        MINFFT_MIN=7 MAXFFT_MIN=7
    fi
else
    MINFFT_MIN=8 MAXFFT_MIN=8
fi

# Program-supported maximum of FFT size (in K)
if [ "$VER" -ge 2413 ] && [ "X$SSE2" = XY ]; then
    MAXFFT_MAX=32768
else
    MAXFFT_MAX=4096
fi

# /proc/meminfo returns memory in KiB, but mprime uses MiB for memory unit.
# Convert KiB to MiB
MEMTOTAL=$(($MEMTOTAL/1024))

# Default used memory when in Blend test. Formula varies among mprime versions.
BLENDMEMORY=8
if [ "$VER" -ge 2413 ]; then
    if [ "$VER" -ge 2505 ] && [ "$MEMTOTAL" -ge 2000 ]; then
        if [ "$VER" -ge 2507 ]; then
            BLENDMEMORY=1600
        else
            BLENDMEMORY=1750
        fi
    elif [ "$MEMTOTAL" -ge 500 ]; then
        BLENDMEMORY=$(($MEMTOTAL-256))
    elif [ "$MEMTOTAL" -ge 200 ]; then
        BLENDMEMORY=$(($MEMTOTAL/2))
    fi
else
    if [ "$MEMTOTAL" -gt 256 ]; then
        BLENDMEMORY=$(($MEMTOTAL-128))
    elif [ "$MEMTOTAL" -gt 32 ]; then
        BLENDMEMORY=$(($MEMTOTAL/2))
    fi
fi

# In mprime 25.5, user is allowed to specify up to $BLENDMEMORY MiB to be used.
# This limit is later removed.
if [ "$VER" -ge 2509 ]; then
    MEMORY_MAX=$MEMTOTAL
else
    MEMORY_MAX=$BLENDMEMORY
fi

if [ "$VER" -ge 2803 ]; then
    TIMEFFT=3
else
    TIMEFFT=15
fi

# Note: there is an absolute limit of how many threads mprime can support.
# It's defined in MAX_NUM_WORKER_THREADS in commonc.h.
# The user may exceed this limit by editing INI manually; after that mprime can
# segfault.
if [ "$VER" -ge 2505 ]; then
    read_num "Number of torture test threads to run" "$CPUS" 1 "$CPUS"
    THREADS="$REPLY"
fi

cat << TORTURE_TYPE
Choose a type of torture test to run.
  1) Small FFTs (maximum heat and FPU stress, data fits in L2 cache, RAM not
     tested much).
  2) In-place large FFTs (maximum heat and power consumption, some RAM tested).
  3) Blend (tests some of everything, lots of RAM tested).
Blend is the default.  NOTE: if you fail the blend test, but can pass the small
FFT test then your problem is likely bad memory or a bad memory controller.
TORTURE_TYPE

read_num "Type of torture test to run" 3 1 3
case "$REPLY" in
    1) MINFFT=8   MAXFFT=64   TORTURE_MEM=0 ;;
    2) MINFFT=128 MAXFFT=1024 TORTURE_MEM=0 ;;
    3) MINFFT=8   MAXFFT=4096 TORTURE_MEM="$BLENDMEMORY" ;;
esac

printf "Min FFT Size: %5dK" "$MINFFT"
if [ "$TORTURE_MEM" -le 8 ]; then
    printf "  Memory to use:           (in-place FFTs)\n"
else
    printf "  Memory to use: %5dMiB, %5dMiB/thread\n" \
        "$TORTURE_MEM" $(($TORTURE_MEM/$THREADS))
fi
printf "Max FFT size: %5dK  Time to run each FFT size: %5d minutes\n" \
    "$MAXFFT" "$TIMEFFT"
while true; do
    printf "Fine tune the selection [y/N]? "
    read REPLY
    case "$REPLY" in
        [Yy]) REPLY=Y; break ;;
        "" | [Nn]) break ;;
    esac
done

if [ "X$REPLY" = XY ]; then
    read_num "Min FFT size (in K)" "$MINFFT" "$MINFFT_MIN" "$MAXFFT_MAX"
    MINFFT="$REPLY"
    read_num "Max FFT size (in K)" "$MAXFFT" "$MAXFFT_MIN" "$MAXFFT_MAX"
    MAXFFT="$REPLY"
    if [ "$BLENDMEMORY" -gt 8 ]; then
        read_num "Memory to use (in MiB, 0 = in-place FFTs)" \
            "$TORTURE_MEM" 0 "$MEMORY_MAX"
        TORTURE_MEM="$REPLY"
    fi
    read_num "Time to run each FFT size (in minutes)" "$TIMEFFT" 1 60
    TIMEFFT="$REPLY"
fi

# The TortureThreads in INI specifies per-thread memory, not total memory.
TORTURE_MEM=$(($TORTURE_MEM/$THREADS))

# Output
if [ "$VER" -ge 2505 ]; then
    echo "Please add these lines to prime.txt and then run 'mprime -t':"
    echo "TortureThreads=$THREADS"
else
    echo "Please add these lines to prime.ini and then run 'mprime -t':"
fi
echo "MinTortureFFT=$MINFFT"
echo "MaxTortureFFT=$MAXFFT"
echo "TortureMem=$TORTURE_MEM"
echo "TortureTime=$TIMEFFT"

