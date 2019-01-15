namespace: Integrations.demo.aos.sub_flows
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.33
    - username: root
    - password: admin@123
    - filename: deploy_war.sh
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      delete_file:
        x: 454
        y: 237
        navigate:
          9f400ce9-f02b-11a4-b36e-86ce5fa64c26:
            targetId: 4271711b-c4ef-c03f-fbbb-0ca2807ff3d7
            port: SUCCESS
    results:
      SUCCESS:
        4271711b-c4ef-c03f-fbbb-0ca2807ff3d7:
          x: 455
          y: 398
