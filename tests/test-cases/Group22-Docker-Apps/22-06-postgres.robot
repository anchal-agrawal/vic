# Copyright 2017 VMware, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

*** Settings ***
Documentation  Test 22-06 - postgres
Resource  ../../resources/Util.robot
Suite Setup  Install VIC Appliance To Test Server
Suite Teardown  Cleanup VIC Appliance On Test Server

*** Keywords ***
Check postgres container
    [Arguments]  ${ip}
    ${rc}  ${output}=  Run And Return Rc And Output  docker %{VCH-PARAMS} run --rm postgres sh -c 'PGPASSWORD=password1 psql -h${ip} -Upostgres -c "\\l"'
    Log  ${output}
    Should Be Equal As Integers  ${rc}  0
    Should Contain  ${output}  postgres
    Should Contain  ${output}  template0
    Should Contain  ${output}  template1

*** Test Cases ***
Simple background postgres
    ${rc}  ${output}=  Run And Return Rc And Output  docker %{VCH-PARAMS} run --name postgres1 -e POSTGRES_PASSWORD=password1 -d postgres
    Log  ${output}
    Should Be Equal As Integers  ${rc}  0
    ${ip}=  Get IP Address of Container  postgres1
    Wait Until Keyword Succeeds  5x  6s  Check postgres container  ${ip}
