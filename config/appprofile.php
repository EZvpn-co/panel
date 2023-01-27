<?php

declare(strict_types=1);

$_ENV['Clash_Config'] = [
    'Proxy' => [
        '🎃 Nothing = direct',
    ],
    'proxy-groups' => [
        [
            'name' => '🔰 Type',
            'type' => 'select',
            'proxies' => [
                '⚡️ Best',
                '🖥 Pick',
                '🎃 Nothing',
            ],
        ],
        [
            'name' => '🖥 Pick',
            'type' => 'select',
            'proxies' => [],
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
