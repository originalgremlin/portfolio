# beautify
export PS1="\[\033[38;5;75m\]devops\[\033[38;5;15m\] \[\033[38;5;14m\]\w\[\033[38;5;15m\] # "

# aliases
alias cx='chmod +x'
alias d='ls -alh'
alias hgrep='history | grep'
alias ls='ls --color=always -p'
alias top='htop'
alias x='exit'

# functions
function mfa {
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    read -p "Enter your MFA token, followed by [ENTER]: " -s MFA_TOKEN
    if [[ -z "${MFA_TOKEN}" ]]; then
        printf "\nNo input received.\n"
    else
        printf "\nValidating token...\n"
        eval $( /usr/local/data/bin/mfa ${MFA_TOKEN} )
    fi
}

## sync terraform remote state
#mfa
#cd $TERRAFORM_ROOT
#terraform remote config -backend=s3 \
#    -backend-config="bucket=terraform.${TF_VAR_hostname}" \
#    -backend-config="key=terraform.${TF_VAR_region}.tfstate" \
#    -backend-config="profile=${TF_VAR_profile}" \
#    -backend-config="region=us-east-1"
#cd $OLDPWD

# set up password-protected ssh
eval `ssh-agent`
ssh-add $HOME/.ssh/id_rsa
