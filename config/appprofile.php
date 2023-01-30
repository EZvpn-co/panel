<?php

declare(strict_types=1);

$_ENV['Clash_Config'] = [
    'proxy-groups' => [
        [
            'name' => '🔰 Select',
            'type' => 'select',
            'proxies' => [
                '⚡️ Best',
            ],
        ],
        [
            'name' => '⚡️ Best',
            'type' => 'url-test',
            'url' => 'http://www.gstatic.com/generate_204',
            'interval' => 300,
            'proxies' => [],
        ],
    ],
    'rules' => [
        'MATCH,🔰 Select'
    ],
];









$_ENV['Surfboard_Config'] = [
    'Checks' => [],
    'General' => [
        'loglevel' => 'notify',
        'dns-server' => 'system, 8.8.8.8, 8.8.4.4',
        'skip-proxy' => '127.0.0.1, 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12, 100.64.0.0/10, 17.0.0.0/8, localhost, *.local, *. crashlytics.com',
        'proxy-test-url' => 'http://www.gstatic.com/generate_204',
    ],
    'Proxy' => [],
    'ProxyGroups' => [],
    'Rules' => [],
];
