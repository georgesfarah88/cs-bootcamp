namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.34
    - username: root
    - password: admin@123
    - artifact_url:
        required: false
    - script_url: "${get_sp('script_install_tomcat')}"
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
            - second_string: ''
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${artifact_url}'
        publish:
          - artfact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${script_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - delete_script:
        do:
          Integrations.demo.aos.sub_flows.delete_file:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - filename: '${script_name}'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_true
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        publish: []
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 399
        y: 86
      copy_artifact:
        x: 150
        y: 263
      copy_script:
        x: 573
        y: 275
      delete_script:
        x: 401
        y: 474
      execute_script:
        x: 168
        y: 392
      is_true:
        x: 602
        y: 455
        navigate:
          82dcd236-691c-a80b-e1cd-233502f9464e:
            targetId: f4b5fee7-7ce5-49b8-9c77-ac4feba41936
            port: 'FALSE'
          e14b384c-3b8c-2c67-d82e-50fe8996facc:
            targetId: e19ef0ee-fd55-241c-4690-ac5eb06672ad
            port: 'TRUE'
    results:
      FAILURE:
        f4b5fee7-7ce5-49b8-9c77-ac4feba41936:
          x: 716
          y: 590
      SUCCESS:
        e19ef0ee-fd55-241c-4690-ac5eb06672ad:
          x: 732
          y: 355
