*** Settings ***
Library                         AppiumLibrary               20
Library                         String
*** Variables ***
${REMOTE_URL}                   http://127.0.0.1:4723/wd/hub
${PLATFORM_NAME}                Android
${PLATFORM_VERSION}             13
${DEVICE_NAME}                  sdk_gphone_x86_64
${Activity_NAME}                com.wagestream.myflexpay.MainActivity
${PACKAGE_NAME}                 com.wagestream.myflexpay

${HOME-GETSTARTED-BUTTON}       xpath=//android.widget.Button[@resource-id='but_start_login']
${GETSTARTED-BUTTON}            xpath=(//android.view.View[@resource-id='username_page']//android.widget.TextView)[1]
${GETSTARTED-PICKLIST}          xpath=//android.view.View[@resource-id='api_url']
${GETSTARTED-PICKLIST-OPTIONS}                              xpath=//android.widget.CheckedTextView[@text='usStaging']
${GETSTARTED-EMAIL-FIELD}       xpath=//android.view.View[@resource-id='username_form']//android.view.View//android.widget.EditText
${GETSTARTED-NEXT-BUTTON}       xpath=//android.view.View//android.widget.Button
${YOUREMPLOYER-INPUT-FIELD}     xpath=//android.widget.EditText[@resource-id='company_name']
${SELECT-ACCOUNT-HEADER}        xpath=(//android.view.View[@resource-id='login_multiple_employers_page']//android.widget.TextView)[1]
${SELECT-ACCOUNT-ATMOSPHERE-BUTTON}                         xpath=(//android.view.View[@resource-id='choose_employer_form']//android.widget.TextView)[2]
${PASSWORD-FIELD}               xpath=//android.widget.EditText[@resource-id='password']
${LOG-IN-BUTTON}                xpath=//android.widget.Button[@resource-id='but_login']
${QUANTITY-SCROLL}              xpath=(//android.view.View[@resource-id='transfer_control_box']//android.view.View/android.widget.TextView)[14]

*** Keywords ***
Open myflexpay
    Open Application            ${REMOTE_URL}
    ...                         platformName=${PLATFORM_NAME}
    ...                         platformVersion=${PLATFORM_VERSION}
    ...                         deviceName=${DEVICE_NAME}
    ...                         automationName=UiAutomator2
    ...                         newCommandTimeout=2500
    ...                         appActivity=${Activity_NAME}
    ...                         appPackage=${PACKAGE_NAME}

Get x and y
    [Arguments]                 ${element}
    ${bounds}=                  Get Element Attribute       ${element}                  bounds
    @{position}=                Get Regexp Matches          ${bounds}                   (\\d+)
    ${x}=                       Evaluate                    (${position}[0]+${position}[1])/2
    ${y}=                       Evaluate                    (${position}[2]+${position}[3])/2
    [Return]                    ${x}                        ${y}

Click Element By xpath
    [Arguments]                 ${element}
    Wait Until Page Contains Element                        ${element}                  timeout=30
    Sleep                       10
    ${bounds}=                  Get Element Attribute       ${element}                  bounds
    @{position}=                Get Regexp Matches          ${bounds}                   (\\d+)
    ${x}=                       Evaluate                    (${position}[0]+${position}[1])/2
    ${y}=                       Evaluate                    (${position}[2]+${position}[3])/2
    @{firstFinger}              Create List                 ${x}                        ${y}
    @{finger_position}          Create List                 ${firstFinger}
    Tap With Positions          ${500}                      @{finger_position}

*** Test Cases ***
First Test cases
    #### STEP 1 ####
    Open myflexpay
    Click Element By xpath      ${HOME-GETSTARTED-BUTTON}

    #### STEP 2 ####
    #Type the e-mail and click Next
    Wait Until Page Contains Element                        ${GETSTARTED-EMAIL-FIELD}             timeout=30
    Sleep                       10
    Click Element               ${GETSTARTED-BUTTON}
    Click Element               ${GETSTARTED-BUTTON}
    Click Element               ${GETSTARTED-PICKLIST}
    Click Element               ${GETSTARTED-PICKLIST-OPTIONS}

    #### STEP 3 ####
    Wait Until Page Contains Element                        ${HOME-GETSTARTED-BUTTON}
    Click Element By xpath      ${HOME-GETSTARTED-BUTTON}

    #### STEP 4 ####
    Input Text                  ${GETSTARTED-EMAIL-FIELD}                               crt.onesource.2305@gmail.com
    Click Element               ${GETSTARTED-NEXT-BUTTON}

    #### STEP 5 ####
    Wait Until Page Contains Element                        ${SELECT-ACCOUNT-ATMOSPHERE-BUTTON}
    Sleep                        10
    Click Element               ${SELECT-ACCOUNT-ATMOSPHERE-BUTTON}

    #### STEP 6 ####
    Wait Until Page Contains Element                        ${PASSWORD-FIELD}
    Sleep                        10
    Input Password              ${PASSWORD-FIELD}           Welcome@123
    Click Element               ${LOG-IN-BUTTON}

    ### STEP 7 ###
    Wait Until Page Contains Element                        ${QUANTITY-SCROLL}