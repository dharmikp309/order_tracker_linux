#!/bin/bash
# ============================================================
#  STARTER KIT – L30 Order Tracker
#  Student: DHARMIK PATEL  Roll: F30  Div: G
#  Run:  bash setup_ordertrack.sh
#  It creates ~/linux_project/ordertrack with folders, sample data and scripts.
# ============================================================
P="$HOME/linux_project/ordertrack"
if [ -d "$P" ]; then echo "Folder $P already exists. Rename or delete it first."; exit 1; fi
mkdir -p "$P"/lib "$P"/data "$P"/reports "$P"/backups "$P"/logs
cd "$P" || exit 1

# sample data: data/orders.csv
cat > 'data/orders.csv' <<'KIT_DATA_0'
order_id,item,store,price,status,date
OD101,Earbuds,Amazon,1299,shipped,2026-10-22
OD102,Hoodie,Myntra,899,delivered,2026-10-18
KIT_DATA_0

cat > lib/functions.sh <<'KIT_FUNCS'
#!/bin/bash
# lib/functions.sh – all functions for Order Tracker
DATA="data/orders.csv"

LOG="logs/activity.log"

# write one line to the activity log
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $*" >> "$LOG"
}

# check the data file / folder exists before using it
check_data() {
    if [ ! -e "$DATA" ]; then
        echo "Data not found: $DATA"
        return 1
    fi
}

show_help() {
    echo "Usage: ./main.sh            -> open the menu"
    echo "       ./main.sh --help     -> show this help"
    echo "       ./main.sh --backup   -> backup data/ now"
    echo "       ./main.sh --cron     -> run the scheduled (crontab) task"
}

view_data() {
    check_data || return
    if [ -d "$DATA" ]; then ls -l "$DATA"; else cat -n "$DATA" | more; fi
}

do_backup() {
    f="backups/data_$(date +%Y%m%d_%H%M%S).tar.gz"
    tar -czf "$f" data/
    echo "Backup saved: $f ($(du -h "$f" | cut -f1))"
    log "backup created $f"
}

view_log() {
    if [ -f "$LOG" ]; then tail -n 15 "$LOG"; else echo "No activity yet."; fi
}

# ------------------------------------------------------------
# FEATURE 1: Add an order
# Commands you can use: sed -i, awk, grep, sort, uniq -c
# ------------------------------------------------------------
feature_1() {
    echo "== Add an order =="
    echo "TODO: write the code for this feature (see your project guide, Step 3)."
    # ---- example to start from (remove the # and change it) ----
    # read -p "Enter order_id: " v1
    # read -p "Enter item: " v2
    # # ...ask for every column: order_id, item, store, price, status, date
    # if [ -z "$v1" ]; then echo "Value cannot be empty"; return; fi
    # echo "$v1,$v2" >> "$DATA"        # add all 6 values in the same order as the header
    # echo "Saved!"
    log "feature_1 used"
}

# ------------------------------------------------------------
# FEATURE 2: Update status with sed
# Commands you can use: sed -i, awk, grep, sort, uniq -c
# ------------------------------------------------------------
feature_2() {
    echo "== Update status with sed =="
    echo "TODO: write the code for this feature (see your project guide, Step 4)."
    # ---- example to start from (remove the # and change it) ----
    # read -p "Enter order_id to change: " key
    # if ! grep -q "^$key," "$DATA"; then echo "Not found"; return; fi
    # # change the last column of that row (example)
    # sed -i "/^$key,/s/[^,]*$/NEW_VALUE/" "$DATA"
    # echo "Updated:"; grep "^$key," "$DATA"
    log "feature_2 used"
}

# ------------------------------------------------------------
# FEATURE 3: Pending vs delivered counts
# Commands you can use: sed -i, awk, grep, sort, uniq -c
# ------------------------------------------------------------
feature_3() {
    echo "== Pending vs delivered counts =="
    echo "TODO: write the code for this feature (see your project guide, Step 5)."
    # ---- example to start from (remove the # and change it) ----
    # # example: count rows per value of column 2
    # tail -n +2 "$DATA" | cut -d',' -f2 | sort | uniq -c | sort -nr | head -5
    # # example: top 5 rows by column 4 (price)
    # tail -n +2 "$DATA" | sort -t',' -k4 -nr | head -5
    log "feature_3 used"
}

# ------------------------------------------------------------
# FEATURE 4: Spend per store
# Commands you can use: sed -i, awk, grep, sort, uniq -c
# ------------------------------------------------------------
feature_4() {
    echo "== Spend per store =="
    echo "TODO: write the code for this feature (see your project guide, Step 6)."
    # ---- example to start from (remove the # and change it) ----
    # # example: count rows per value of column 2
    # tail -n +2 "$DATA" | cut -d',' -f2 | sort | uniq -c | sort -nr | head -5
    # # example: top 5 rows by column 4 (price)
    # tail -n +2 "$DATA" | sort -t',' -k4 -nr | head -5
    log "feature_4 used"
}

# ------------------------------------------------------------
# FEATURE 5: Search an order by keyword
# Commands you can use: sed -i, awk, grep, sort, uniq -c
# ------------------------------------------------------------
feature_5() {
    echo "== Search an order by keyword =="
    echo "TODO: write the code for this feature (see your project guide, Step 7)."
    # ---- example to start from (remove the # and change it) ----
    # read -p "Search for: " word
    # grep -i "$word" "$DATA" || echo "Nothing found"
    # # or show selected columns: awk -F',' '{ print $1, $2 }' "$DATA"
    log "feature_5 used"
}

# ------------------------------------------------------------
# CRON TASK: Every day at 8 PM, write pending orders older than 5 days to delayed_orders.txt
# Runs when crontab calls:  ./main.sh --cron
# ------------------------------------------------------------
cron_task() {
    # TODO: write the code for the scheduled task here (Step 10 of your guide)
    echo "$(date '+%Y-%m-%d %H:%M') cron task ran" >> reports/cron_output.txt
    log "cron task ran"
}
KIT_FUNCS

cat > main.sh <<'KIT_MAIN'
#!/bin/bash
# main.sh – L30 Order Tracker
# Menu-driven shell script (while loop + case)
cd "$(dirname "$0")" || exit 1
source lib/functions.sh

case "$1" in
    --help)   show_help; exit 0 ;;
    --backup) do_backup; exit 0 ;;
    --cron)   cron_task; exit 0 ;;
esac

while true; do
    echo
    echo '========== ORDER TRACKER =========='
    echo '1) Add an order'
    echo '2) Update status with sed'
    echo '3) Pending vs delivered counts'
    echo '4) Spend per store'
    echo '5) Search an order by keyword'
    echo "6) View data"
    echo "7) Backup data (tar.gz)"
    echo "8) View activity log"
    echo "0) Exit"
    read -p "Choose an option: " ch
    case "$ch" in
        1) feature_1 ;;
        2) feature_2 ;;
        3) feature_3 ;;
        4) feature_4 ;;
        5) feature_5 ;;
        6) view_data ;;
        7) do_backup ;;
        8) view_log ;;
        0) echo "Bye!"; break ;;
        *) echo "Invalid choice, try again." ;;
    esac
done
KIT_MAIN

cat > README.md <<'KIT_README'
# L30 – Order Tracker

**Student:** DHARMIK PATEL | **Roll:** F30 | **Division:** G | **Enrollment:** 24004501210271

## Problem
Build an online order tracker with statuses and spend reports.

## Who will use it
Online shoppers tracking many parcels.

## Folder structure
- main.sh – menu (run with ./main.sh)
- lib/functions.sh – all functions
- data/ – data files
- reports/ – reports created by the script
- backups/ – tar.gz backups
- logs/ – activity.log and cron.log

## Features
1. Add an order
2. Update status with sed
3. Pending vs delivered counts
4. Spend per store
5. Search an order by keyword

## How to run
    cd ~/linux_project/ordertrack
    ./main.sh
    ./main.sh --help

## Crontab task
Every day at 8 PM, write pending orders older than 5 days to delayed_orders.txt

    0 20 * * * /bin/bash $HOME/linux_project/ordertrack/main.sh --cron >> $HOME/linux_project/ordertrack/logs/cron.log 2>&1

## Commands used
sed -i, awk, grep, sort, uniq -c

## What I learned
(write 3-5 lines here)
KIT_README

chmod +x main.sh lib/functions.sh
touch logs/activity.log
echo
echo "Starter kit ready!  Folder: $P"
ls -R "$P"
echo
echo "Next:  cd ~/linux_project/ordertrack  &&  ./main.sh"
