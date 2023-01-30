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
    'General' => [],
    'Proxy' => [
        '🎃 Nothing = direct',
    ],
    'ProxyGroups' => [
        [
            'name' => '🔰 Select',
            'type' => 'select',
            'proxies' => ['🎃 Nothing'],
        ],
        [
            'name' => '⚡️ Best',
            'type' => 'url-test',
            'url' => 'http://www.gstatic.com/generate_204',
            'interval' => 300,
            'proxies' => [],
        ],
    ],
    'Rules' => [
        'MATCH,🔰 Select'
    ],
    // 'default' => [
    //     'Checks' => [],
    //     'General' => [
    //         'loglevel' => 'notify',
    //         'dns-server' => 'system, 8.8.8.8, 8.8.4.4',
    //         'skip-proxy' => '127.0.0.1, 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12, 100.64.0.0/10, 17.0.0.0/8, localhost, *.local, *. crashlytics.com',
    //         'internet-test-url' => 'http://www.google.com/',
    //         'proxy-test-url' => 'http://www.google.com/',
    //     ],
    //     'Proxy' => [
    //         '🎃 Nothing = direct',
    //     ],
    //     'ProxyGroup' => [
    //         [
    //             'name' => 'Type',
    //             'type' => 'select',
    //             'content' => [
    //                 'left-proxies' => ['Best', 'Daily', 'Daily+',],
    //             ]
    //         ],
    //         [
    //             'name' => 'Daily',
    //             'type' => 'select',
    //             'content' => [
    //                 'regex' => '\b(\w*-DY-\w*)\b',
    //                 'right-proxies' => ['🎃 Nothing'],
    //             ]
    //         ],
    //         [
    //             'name' => 'Daily+',
    //             'type' => 'select',
    //             'content' => [
    //                 'regex' => '\b(\w*-DP-\w*)\b',
    //                 'right-proxies' => ['🎃 Nothing'],
    //             ]
    //         ],
    //         [
    //             'name' => 'Best',
    //             'type' => 'url-test',
    //             'content' => [
    //                 'regex' => '(.*)',
    //                 'right-proxies' => ['🎃 Nothing'],
    //             ],
    //             'url' => 'http://www.google.com/',
    //             'interval' => 43200,

    //         ],
    //     ],
    //     'Rule' => [
    //         'source' => 'surfboard/default.tpl'
    //     ]
    // ]
];
