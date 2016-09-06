name "webapp"
description "Role permettant d'installer une applications web"

default_attributes(
"webapp" => {
    "webapp_packages" => [
        "php7.0",
        "php7.0-cli",
        "php7.0-curl",
        "php7.0-mysql",
        "apache2",
        "apache2-mpm-prefork",
        "libapache2-mod-php7.0",
        "libapache2-mod-proxy-html",
        "php7.0-mbstring",
        "php7.0-dom"
    ],
    "webapp_mods" => [
        "ssl",
        "rewrite",
        "php7.0"
    ]
}
)

run_list(
"recipe[dotdeb]",
"recipe[webapp]"
)
