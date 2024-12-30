patch() {

path=$1

if [[ -z "$path" ]]; then
    echo "[-] No path provided, exiting..."
    exit 1
fi

# Remove trailing slashes from path
path=$(echo "$path" | sed 's:/*$::')

if ls $path 2> /dev/null; then
    echo "[+] Directory check passed"
else
    echo "[-] Provided directory does not exist, exiting..."
    exit 1
fi

echo "[*] Copying files..."

echo "[*] Replacing cof.exe..."
cp patches/cof.exe $path
echo "[+] cof.exe replaced!"

echo "[~] Deleting original opengl32.dll"

if rm $path/opengl32.dll 2> /dev/null; then
    echo "[+] opengl32.dll removed!"
else
    echo "[-] Failed to delete opengl32.dll"
fi

echo "[*] Copying opengp32.dll..."
cp patches/opengp32.dll $path
echo "[+] opengp32.dll copied!"

echo "[*] Replacing hw.dll..."
cp patches/hw.dll $path
echo "[+] hw.dll replaced!"

echo "[*] Replacing client.dll..."
cp patches/client.dll $path/cryoffear/cl_dlls/
echo "[+] client.dll replaced!"

# At this point only base patches would have been applied.
# If you want to install any additional mods or whatever,
# place the files you need in the "patches" directory
# and use it like shown below:
#
#  echo "[*] Patching unlockables..."
#  cp patches/scriptsettings.dat $path/cryoffear/scriptsettings.dat
#  echo "[+] Unlockables patched!"

echo "[*] Everything is done. Happy new year! :)"
}

print_help() {
echo -en\
    "Cry of Fear Linux patcher core v0.0.3 - bash fork\n\n"\
    "Description: Replaces game and engine libraries to patched ones."\
    "Fixes most of the Cry of Fear bugs for Linux.\n\n"\
    "Usage: $1 [-h|--help] [-v|--version] <path>\n\n"\
    "Optional arguments:\n"\
    "\t-h, --help\t\tShow this help message and exit.\n"\
    "\t-v, --version\tDisplay the version of the build and exit.\n\n"\
    "Github: https://github.com/Kel-05/cof-linux-patcher-bash\n"\
    "Original version: https://github.com/hinqiwame/cof-linux-patcher\n"
}

while getopts ":hv-:" opt; do
    case $opt in
        h)
            print_help $0
            exit 0
            ;;
        v)
            echo "v0.0.3"
            exit 0
            ;;
        -)
            case "${OPTARG}" in
                help)
                    print_help $0
                    exit 0
                    ;;
                version)
                    echo "v0.0.3"
                    exit 0
                    ;;
                *)
                    print_help $0
                    exit 1
                    ;;
            esac
            ;;
        \?)
            print_help $0
            exit 1
            ;;
    esac
done

shift $((OPTIND -1))
patch "$1"