<?php

declare(strict_types=1);

$_ENV['Clash_Config'] = [
    'proxy-groups' => [
        [
            'name' => '🔰 Selection',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '♻️ Auto',
                '🎯 Nothig',
            ],
        ],
        [
            'name' => '♻️ Auto',
            'type' => 'url-test',
            'url' => 'http://www.gstatic.com/generate_204',
            'interval' => 300,
            // 插入节点名称
            'proxies' => [],
        ],
        [
            'name' => '🎥 NETFLIX',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🔰 Selection',
                '♻️ Auto',
                '🎯 Nothig',
            ],
        ],
        [
            'name' => '⛔️ AD blocking',
            'type' => 'select',
            'proxies' => [
                '🛑 operational hijacking',
                '🎯 Nothig',
                '🔰 Selection',
            ],
        ],
        [
            'name' => '🚫 operational hijacking',
            'type' => 'select',
            'proxies' => [
                '🛑 operational hijacking',
                '🎯 Nothig',
                '🔰 Selection',
            ],
        ],
        [
            'name' => '🌍 foreign media',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🔰 Selection',
                '♻️ Auto',
                '🎯 Nothig',
            ],
        ],
        [
            'name' => '🌏 domestic media',
            'type' => 'select',
            'proxies' => [
                '🎯 Nothig',
                '🔰 Selection',
            ],
        ],
        [
            'name' => 'Ⓜ️ microsoft services',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🎯 Nothig',
                '🔰 Selection',
            ],
        ],
        [
            'name' => '📲 telegram message',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🔰 Selection',
                '🎯 Nothig',
            ],
        ],
        [
            'name' => '🍎 apple services',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🔰 Selection',
                '🎯 Nothig',
                '♻️ Auto',
            ],
        ],
        [
            'name' => '🎯 Nothig',
            'type' => 'select',
            'proxies' => [
                'DIRECT',
            ],
        ],
        [
            'name' => '🛑 operational hijacking',
            'type' => 'select',
            'proxies' => [
                'REJECT',
                'DIRECT',
            ],
        ],
        [
            'name' => '🐟 漏网之鱼',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🔰 Selection',
                '🎯 Nothig',
                '♻️ Auto',
            ],
        ],
    ],
    'rules' => [
        'MATCH,🔰 Selection'
    ],
];
