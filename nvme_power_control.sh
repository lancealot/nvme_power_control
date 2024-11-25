#!/bin/bash

# Function to get NVMe devices and their power states
get_nvme_devices() {
    echo "Current power states:"
    printf "%-20s %-25s %-30s %-15s\n" "Device" "BUS:DEV.FNC" "Serial" "Power state"
    printf "%-20s %-25s %-30s %-15s\n" "-----------------------------------------------------------------------------------------"

    # Get the list of NVMe devices
    nvme list | while read -r line; do
        if [[ $line == /dev/nvme* ]]; then
            device=$(echo "$line" | awk '{print $1}')
            base_device=${device%n1}  # Remove 'n1' from the device name

            # Extract BUS:DEV.FNC information using udevadm
            bus_info=""
            if [[ -e "$base_device" ]]; then
                path=$(udevadm info --query=path --name="$base_device")
                if [[ -n "$path" ]]; then
                    bus_info=$(echo "$path" | awk -F '/' '{sub("0000:", "", $(NF-2)); if ($(NF-2) ~ /^[a-f0-9]{2}:[a-f0-9]{2}\.[a-f0-9]$/) print $(NF-2)}')
                fi
            fi

            # Extract serial number from nvme id-ctrl output
            serial=$(nvme id-ctrl "$base_device" 2>/dev/null | grep "sn        :" | awk '{print $3}')

            # Get the current power state using nvme get-feature
            power_state="N/A"
            if [[ -e "$device" ]]; then
                power_output=$(nvme get-feature "$base_device" -f 2 -H 2>/dev/null)
                if [[ $? -eq 0 ]]; then
                    power_state=$(echo "$power_output" | grep "Power State" | awk '{print $4}')
                fi
            fi

            printf "%-20s %-25s %-30s %-15s\n" "$base_device" "$bus_info" "$serial" "$power_state"
        fi
    done
}

# Function to set and verify power state
set_power_state() {
    local device="$1"
    local new_state="$2"

    # Set the power state using nvme set-feature and make persistent
    nvme set-feature "$device" -f 2 -v "$new_state" -s >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Failed to set power state for $device."
        return 1
    fi

    # Verify the power state using nvme get-feature
    power_output=$(nvme get-feature "$device" -f 2 -H 2>/dev/null)
    if [[ $? -ne 0 ]]; then
        echo "Failed to verify power state for $device."
        return 1
    fi

    current_state=$(echo "$power_output" | grep "Power State" | awk '{print $4}')
    if [[ "$current_state" == "$new_state" ]]; then
        echo "Power state for $device set successfully to $new_state."
    else
        echo "Error: Power state for $device is $current_state, but requested state was $new_state."
        return 1
    fi
}

# Main script execution loop
while true; do
    get_nvme_devices

    read -p "Enter the device number (e.g., 0 for nvme0) or 'q' to quit: " input
    if [[ "$input" == "q" ]]; then
        break
    fi

    base_device="/dev/nvme${input}"
    if [[ ! -e "${base_device}n1" ]]; then
        echo "Device $base_device does not exist."
        continue
    fi

    read -p "Enter the new power state: " new_state

    set_power_state "$base_device" "$new_state"
done
