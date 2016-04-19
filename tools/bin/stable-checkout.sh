#!/bin/bash

# Pretty colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# Ensure they are configured first
if [[ -f .hpe_product ]]; then
    PRODUCT=$(cat .hpe_product)
else
    echo You are either not configured or you are invoking this script from a non-top-level directory. Please configure your system before running this script or move to /ws/$LOGNAME/\<repo-name\>.
    exit 0
fi

# Parse Inputs
TAG=$2
REPOS="${@:3}"

# Check for help option
for var in $@;
do
    if [ "$var" == "help" ] || [ "$var" == "-h" ]; then
        echo "Usage: make stable STABLE_tag [src repo(s) to add..] [help]"
        echo "                   [--REBASE -R Rebase changes to most recent version of code]"
        echo ""
        echo "Description:"
        echo "  This script will hard reset your work environment to a stable tag. This"
        echo "  will allow you to build a stable image and develop on top of it until the"
        echo "  build environment is marked as stable again."
        echo ""
        echo -e "  ${RED}WARNING: This means any changes currently in your build environment that"
        echo "  are specified to be reset to stable (via parameters for the script) will be"
        echo "  lost. They can be recovered and cherry-picked after the reset ONLY if the"
        echo "  changes are committed before activating the script. If your changes are not"
        echo -e "  committed before running the script, they will be lost forever.${NC}"
        echo ""
        echo "  Once the build environment has returned to stable, re-run this script with"
        echo "  the a \"rebase\" flag and any changes made on top of the STABLE tag will"
        echo "  be applied to the newest codebase."
        exit 1;
    fi
done

# Check that user does not have any changes they may lose
echo "This script will be used to check out stable tags and set up a developers environment to develop on top of the stable tag."
echo "If you have any uncommitted changes in your ./openswitch, ./openswitch/yocto, or ./openswitch/yocto/$PRODUCT repos, they will be lost upon executing this script. Additionally, any changes in src repos (./src/) specified as parameters to this script will be lost as well. Please commit or stash these changes before continuing."
echo ""
echo "Please note, if you ran the \"rebase\" option, it will not wipe away your changes, but it will fail if you have any uncommitted changes."
echo ""
echo "Would you like to check the status of your repos? (yes/no)"
read STATUSCHECK

if [ "$STATUSCHECK" == "yes" ]; then
    STATUSOUTPUT=$(make git status | tee /dev/tty)
    if [[ "$STATUSOUTPUT" == *"Changes not staged for commit:"* ]] || [[ "$STATUSOUTPUT" == *"Untracked files:"* ]]; then
        echo ""
        echo -e "${RED}Looks like you have unsaved changes.${NC} Do you want to continue anyways? (yes/no)"
    else
        echo "No unsaved changes found. Do you want to continue? (yes/no)"
    fi
else
    echo "Would you like to continue with the checkout? (yes/no)"
fi
read CONTINUE

if [ "$CONTINUE" != "yes" ]; then
    exit 1
fi

# Check for rebase or option
for var in $@;
do
    if [ "$var" == "rebase" ]; then
        make git "pull --rebase"
        exit 1;
    fi
done

# Make sure there are parameters
echo -e "${YELLOW}Checking Parameters...${NC}"
if [ ! $TAG ]; then
    echo -e "${RED}This script requires at least one parameter. The proper format is as follows:"
    echo -e "${RED}      make stable <STABLE tag> [<Any ./src repos to be check out as well>]"
    echo -e "${RED}                 or"
    echo -e "${RED}      make stable rebase"
    echo ""
    echo -e "${RED}An example would be: make stable STABLE_YYYYMMDD ops ops-openvswitch ops-cli${NC}"
    exit 0
elif [[ "$TAG" != "STABLE_"* ]]; then
    if [ "$TAG" != "RECENT" ]; then
       echo -e "${RED}Please enter a valid stable tag"
       echo -e "${RED}Accepted formats are:"
       echo -e "${RED}      STABLE_*   - used to check out a specific STABLE tag"
       echo -e "${RED}      RECENT     - used to check out the most recent STABLE tag${NC}"
       exit 0
   fi
fi

# Check out stable tags for hpe-build repo (main makefile repo)
echo -e "${YELLOW}Moving to stable tag for hpe-build (root build) repo...${NC}"
# Check for RECENT option
if [ "$2" == "RECENT" ]; then
    TAG=$(git describe --tags)
    if [[ "$TAG" != "STABLE_"* ]]; then
        echo -e "${RED}Could not find any tags or the most recent tag is not a stable tag. Please manually enter a stable tag to reset to.${NC}"
        exit 0;
    fi
fi
RESULT=$(git reset --hard $TAG)
if [[ $RESULT != *fatal* ]]; then
    echo -e "${RED}ERROR: Failed to reset ./openswitch/yocto... Exiting.${NC}"
    exit 0
fi

# Check out stable tags for ops-build repo
echo -e "${YELLOW}Moving to stable tag for ops-build (./openswitch) repo...${NC}"
if [ ! -d "./openswitch" ] && [ ! -d "./openswitch/yocto" ]; then
    echo -e "${RED}Unable to find the ./openswitch or ./openswitch/yocto repository. Exiting...${NC}"
    exit 0
fi
cd ./openswitch/yocto;
# Check for RECENT option
if [ "$2" == "RECENT" ]; then
    TAG=$(git describe --tags)
    if [[ "$TAG" != "STABLE_"* ]]; then
        echo -e "${RED}Could not find any tags or the most recent tag is not a stable tag. Please manually enter a stable tag to reset to.${NC}"
        exit 0;
    fi
fi
RESULT=$(git reset --hard $TAG)
if [[ $RESULT != *fatal* ]]; then
    echo -e "${RED}ERROR: Failed to reset ./openswitch/yocto... Exiting.${NC}"
    exit 0
fi

# Check out stable tags for hpe-build repo
echo -e "${YELLOW}Moving to stable tag for hpe-build (./openswitch/yocto/$PRODUCT) repo...${NC}"
if [ ! -d "./$PRODUCT" ]; then
    echo -e "${RED}No repository could be found for product $PRODUCT - please make sure you are configured properly.${NC}"
    exit 0
fi
cd ./$PRODUCT;
# Check for RECENT option
if [ "$2" == "RECENT" ]; then
    TAG=$(git describe --tags)
    if [[ "$TAG" != "STABLE_"* ]]; then
        echo -e "${RED}Could not find any tags or the most recent tag is not a stable tag. Please manually enter a stable tag to reset to.${NC}"
        exit 0;
    fi
fi
RESULT=$(git reset --hard $TAG)
if [[ "$RESULT" != *"fatal"* ]]; then
    echo -e "${RED}ERROR: Failed to reset ./openswitch/yocto/${PRODUCT}... Exiting.${NC}"
    exit 0;
fi
cd ../../..;

# Give warning about src repo updating
if [ $REPOS ]; then
    echo ""
    echo -e "${YELLOW}Warning: If there are any src repos added outside of the list passed to this script, they may"
    echo "no longer align with your code base after this script runs. This may cause your build"
    echo -e "to fail unexpectedly.${NC}"
    echo "Continue? [yes/no]"
    read CONTINUE
    if [ "$CONTINUE" != "yes" ]; then
        exit 1;
    fi
fi

# Next, get all the src repos passed in as parameters and check them out to the SHA their .bb or .bbappend file points to
for var in $REPOS;
do
    echo -e "${YELLOW}Adding $var to local ./src directory and resetting to stable SHA...${NC}"
    SRCREV=$(make bake "RECIPE=-e $var" | grep SRCREV\=)
    SRCSHA=$(echo $SRCREV | awk -F\" '{print $(NF-1)}' )
    if [ ! -d "./src/$var" ]; then
        make devenv_add $var
        if [ ! -d "./src/$var" ]; then
            echo -e "${RED}Failed to devenv_add the $var repo${NC}"
            exit 0
        fi
        echo ""
    else
        echo -e "${YELLOW}/src/$var already exists, skipping adding it...${NC}"
        echo ""
    fi
    if [ ! $SRCREV ] && [ ! $SRCSHA ]; then
        echo -e "${RED}Failed to get SRCREV for $var repo${NC}"
        exit 0
    fi
    cd ./src/$var
    git reset --hard $SRCSHA
    cd ../..
done

echo -e "${GREEN}Script completed successfully!${NC}"
