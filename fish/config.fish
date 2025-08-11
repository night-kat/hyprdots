if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x SSH_AUTH_SOCK /run/user/(id -u)/ssh-agent.socket
