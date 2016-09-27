#!/bin/bash

##
# Copyright IBM Corporation 2016
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##

# If any commands fail, we want the shell script to exit immediately.
set -e

# Set scripts folder variable
scriptsFolder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "scriptsFolder: $scriptsFolder"

# Parse input parameters
source "$scriptsFolder/parse_inputs.sh"

# Delete to do database just in case it already exists (we need a clean slate)
curl -X DELETE https://$username.cloudant.com/$database -u $username:$password

# Create todo database
curl -X PUT https://$username.cloudant.com/$database -u $username:$password

# Upload design document
curl -X PUT "https://$username.cloudant.com/todolist/_design/todosdesign" -u $username:$password -d @"$scriptsFolder/main_design.json"

echo
echo "Finished populating cloudant database '$database'."
