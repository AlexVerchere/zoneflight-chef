name "secure_server"
description "Role permettant de sécuriser un serveur."

run_list(
    "recipe[chef-client]",
    "recipe[chef-client::delete_validation]",
    "recipe[chef-client::config]",
    "recipe[users-zoneflight]",
    "recipe[users-zoneflight::developers]",
    "recipe[packages]",
    "recipe[fail2ban]",
    "recipe[openssh]",
    "recipe[ntp]",
    "recipe[sudo]"
)


default_attributes(
    "chef_client" => {
        "config" => {
            "ssl_verify_mode" => "verify_none",
            "verify_api_cert" => false
        }
    },
    "packages-cookbook" => [
        "curl",
        "emacs",
        "ethtool",
        "git",
        "htop",
        "iproute",
        "iptables",
        "locate",
        "nmap",
        "rsync",
        "sudo",
        "tcpdump",
        "traceroute",
        "tree",
        "wget",
        "whois",
        "unzip"
    ],
    "packages_action" => "install",
    "openssh" => {
        "server" => {
            "use_dns"                 => "no",
            "permit_root_login"       => "without-password",
            "password_authentication" => "no"
        }
    },

    "authorization" => {
        "sudo" => {
            "include_sudoers_d" => true,
            "passwordless"      => true,
            "groups"            => ["sysadmin", "dev", "pedago"],
            "sudoers_defaults"  => [
                '!lecture,tty_tickets,!fqdn',
                'secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'
            ]
        }
    },
)
