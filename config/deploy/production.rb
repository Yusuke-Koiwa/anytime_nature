server '54.178.118.236', user: 'koiwa', roles: %w{app db web}

# どの公開鍵を利用してデプロイするか
set :ssh_options, auth_methods: ['publickey'],
                  keys: ['~/.ssh/anytime-nature_key_rsa']