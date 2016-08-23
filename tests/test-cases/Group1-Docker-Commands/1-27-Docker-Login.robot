*** Settings ***
Documentation  Test 1-27 - Docker Login
Resource  ../../resources/Util.robot
Suite Setup  Install VIC Appliance To Test Server  ${false}
Suite Teardown  Cleanup VIC Appliance On Test Server

*** Variables ***
${yml}  version: "2"\nservices:\n${SPACE}web:\n${SPACE}${SPACE}image: python:2.7\n${SPACE}${SPACE}ports:\n${SPACE}${SPACE}- "5000:5000"\n${SPACE}${SPACE}volumes:\n${SPACE}${SPACE}- ".:/code"\n${SPACE}${SPACE}depends_on:\n${SPACE}${SPACE}- redis\n${SPACE}redis:\n${SPACE}${SPACE}image: redis\n${SPACE}${SPACE}ports:\n${SPACE}${SPACE}- "5001:5001"

*** Test Cases ***
Docker login and pull from docker.io
    ${status}=  Get State Of Github Issue  368
    Run Keyword If  '${status}' == 'closed'  Fail  Test 1-8-Docker-Logs.robot needs to be updated now that Issue #368 has been resolved
    Log  Issue \#368 is blocking implementation  WARN
    ${rc}  ${output}=  Run And Return Rc And Output  docker ${params} pull victest/busybox
    Should Be Equal As Integers  ${rc}  1
    ${rc}  ${output}=  Run And Return Rc And Output  docker ${params} pull victest/public-hello-world
    Should Be Equal As Integers  ${rc}  0
    ${rc}  ${output}=  Run And Return Rc And Output  docker ${params} login --username=victest --password=vmware!123
    Should Be Equal As Integers  ${rc}  0
    ${rc}  ${output}=  Run And Return Rc And Output  docker ${params} pull victest/busybox
    Should Be Equal As Integers  ${rc}  0
    ${rc}  ${output}=  Run And Return Rc And Output  docker ${params} logout
    Should Be Equal As Integers  ${rc}  0
	
	
