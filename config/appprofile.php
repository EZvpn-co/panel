<?php

declare(strict_types=1);

$_ENV['Clash_Config'] = [
    'proxy-groups' => [
        [
            'name' => '🔰 Select',
            'type' => 'select',
            'proxies' => [
                '⚡️ Best',
                // '🎃 Nothing',
            ],
        ],
        // [
        //     'name' => '🖥 Pick',
        //     'type' => 'select',
        //     'proxies' => ['⚡️ Best',],
        // ],
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
