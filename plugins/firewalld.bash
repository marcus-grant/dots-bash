alias fw="sudo firewall-cmd"
alias fwp="fw --permanent"
alias fwr="fw --reload"
alias fwrp="fw --runtime-to-permanent"

fwl () {
    if ! command -v firewall-cmd &> /dev/null; then
        echo "Firewalld not installed, can't run this function, exiting..."
        return 1
    fi
    # Get all the zones as their own list
    zones=$(sudo firewall-cmd --get-active-zones | grep -v 'interfaces\|sources')

    echo "Firewall Rules Split By Zones:"
    echo
    # Iterate through every active firewall zone
    while IFS= read -r zone; do
        # ... then list all rules for that zone
        echo "===| $zone rules |==="
        sudo firewall-cmd --zone $zone --list-all
        echo
    done <<< "$zones"

    echo
    echo "===| all rules |==="
    sudo firewall-cmd --direct --get-all-rules
    echo
}
