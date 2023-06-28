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
${SELECT-ACCOUNT-ATMOSPHERE-BUTTON}                         xpath=(//android.view.View[@resource-id='choose_employer_form']//android.widget.TextView)[1]
${PASSWORD-FIELD}               xpath=//android.widget.EditText[@resource-id='password']
${LOG-IN-BUTTON}                xpath=//android.widget.Button[@resource-id='but_login']
${QUANTITY-SCROLL}              xpath=(//android.view.View[@resource-id='transfer_control_box']//android.view.View/android.widget.TextView)[14]
${AMOUNT-TEXT}                  xpath=//android.view.View[@resource-id='transfer_disc']//android.widget.TextView[@resource-id='transfer_amount']
${INSTANT-TRANSFER-BUTTON}      xpath=//android.view.View[@resource-id='but_make_transfer_instant']
${TRANSFER-WAGES-BUTTON}        xpath=//android.widget.TextView[@text='TRANSFER WAGES']
${TRANSFER-SENT-MESSAGE}        xpath=//android.widget.TextView[@text='Transfer Sent']
${BACK-TO-DAHSBOARD-BUTTON}     xpath=//android.widget.TextView[@text='BACK TO DASHBOARD']

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
    ${x}=                       Evaluate                    (${position}[0]+${position}[2])/2
    ${y}=                       Evaluate                    (${position}[1]+${position}[3])/2
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

Increase the amount
    [Arguments]                 @{swipe_coordinates}
    ${x}=                       Set Variable                ${swipe_coordinates}[0]
    FOR                         ${index}                    IN RANGE                    100
        ${quantity}=            Get Text                    ${AMOUNT-TEXT}
        IF                      "${quantity}" == "10.00"
            BREAK
        END
        ${last_x}=              Set Variable                ${x}
        ${x}=                   Evaluate                    (${x}+5)
        Swipe                   start_x=${last_x}           start_y=${swipe_coordinates}[1]              offset_x=${x}               offset_y=${swipe_coordinates}[1]
        Sleep                   3
    END

*** Test Cases ***
First Test cases
    #### STEP 1 ####
    Open myflexpay
    Click Element By xpath      ${HOME-GETSTARTED-BUTTON}

    #### STEP 2 ####
    Wait Until Page Contains Element                        ${GETSTARTED-EMAIL-FIELD}                    timeout=30
    Sleep                       3
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
    Sleep                       3
    Click Element               ${SELECT-ACCOUNT-ATMOSPHERE-BUTTON}

    #### STEP 6 ####
    Wait Until Page Contains Element                        ${PASSWORD-FIELD}
    Sleep                       3
    Input Password              ${PASSWORD-FIELD}           Welcome@123
    Click Element               ${LOG-IN-BUTTON}

    ### STEP 7 ###
    Wait Until Page Contains Element                        ${QUANTITY-SCROLL}
    @{swipe_coordinates}        Get x and y                 ${QUANTITY-SCROLL}
    # Log                       ${swipe_coordinates}[1]
    # ${offset_x}=              Evaluate                    (${swipe_coordinates}[0]+10)
    # Swipe                     start_x=${swipe_coordinates}[0]                         start_y=${swipe_coordinates}[1]              offset_x=${offset_x}    offset_y=${swipe_coordinates}[1]
    Increase the amount         @{swipe_coordinates}
    Wait Until Page Contains Element                        ${INSTANT-TRANSFER-BUTTON}
    Click Element               ${INSTANT-TRANSFER-BUTTON}
    Wait Until Page Contains Element                        ${TRANSFER-WAGES-BUTTON}
    Click Element               ${TRANSFER-WAGES-BUTTON}

    ### STEP 8 ###
    Wait Until Page Contains Element                        ${BACK-TO-DAHSBOARD-BUTTON}
    Sleep                       3
    Element Text Should Be      ${TRANSFER-SENT-MESSAGE}    Transfer Sent
    Click Element               ${BACK-TO-DAHSBOARD-BUTTON}