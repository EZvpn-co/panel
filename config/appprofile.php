<?php

declare(strict_types=1);

$_ENV['Clash_Config'] = [
    'proxy-groups' => [
        // [
        //     'name' => '🔰 Type',
        //     'type' => 'select',
        //     'proxies' => [],
        // ],
        [
            'name' => '🔰 节点选择',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '♻️ 自动选择',
                '🎯 全球直连',
            ],
        ],
        [
            'name' => '🎯 全球直连',
            'type' => 'select',
            'proxies' => [
                'DIRECT',
            ],
        ],
        [
            'name' => '♻️ 自动选择',
            'type' => 'url-test',
            'url' => 'http://www.gstatic.com/generate_204',
            'interval' => 300,
            // 插入节点名称
            'proxies' => [],
        ],
        // [
        //     'name' => '🖥 Pick',
        //     'type' => 'select',
        //     'proxies' => ['⚡️ Best',],
        // ],
        // [
        //     'name' => '⚡️ Best',
        //     'type' => 'url-test',
        //     'url' => 'http://www.gstatic.com/generate_204',
        //     'interval' => 300,
        //     'proxies' => [],
        // ],
    ],
    'rules' => [
        'MATCH,🔰 Select'
    ],
];
