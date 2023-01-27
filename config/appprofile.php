<?php

declare(strict_types=1);

$_ENV['Clash_Config'] = [
    'proxy-groups' => [
        [
            'name' => '🔰 node selection',
            'type' => 'select',
            // insert node name
            'proxies' => [
                '♻️ Automatic selection',
                '🎯 Global direct connection',
            ],
        ],
        [
            'name' => '♻️ Auto Select',
            'type' => 'url-test',
            'url' => 'http://www.gstatic.com/generate_204',
            'interval' => 300,
            // insert node name
            'proxies' => [],
        ],
        [
            'name' => '🎥 NETFLIX',
            'type' => 'select',
            // insert node name
            'proxies' => [
                '🔰 node selection',
                '♻️ Automatic selection',
                '🎯 Global direct connection',
            ],
        ],
        [
            'name' => '⛔️ Ad Blocker',
            'type' => 'select',
            'proxies' => [
                '🛑 Global Intercept',
                '🎯 Global direct connection',
                '🔰 node selection',
            ],
        ],
        [
            'name' => '🚫Operation Hijack',
            'type' => 'select',
            'proxies' => [
                '🛑 Global Intercept',
                '🎯 Global direct connection',
                '🔰 node selection',
            ],
        ],
        [
            'name' => '🌍 foreign media',
            'type' => 'select',
            // insert node name
            'proxies' => [
                '🔰 node selection',
                '♻️ Automatic selection',
                '🎯 Global direct connection',
            ],
        ],
        [
            'name' => '🌏 Domestic Media',
            'type' => 'select',
            'proxies' => [
                '🎯 Global direct connection',
                '🔰 node selection',
            ],
        ],
        [
            'name' => 'Ⓜ️ Microsoft Services',
            'type' => 'select',
            // insert node name
            'proxies' => [
                '🎯 Global direct connection',
                '🔰 node selection',
            ],
        ],
        [
            'name' => '📲 Telegram Information',
            'type' => 'select',
            // insert node name
            'proxies' => [
                '🔰 node selection',
                '🎯 Global direct connection',
            ],
        ],
        [
            'name' => '🍎 Apple Services',
            'type' => 'select',
            // insert node name
            'proxies' => [
                '🔰 node selection',
                '🎯 Global direct connection',
                '♻️ Automatic selection',
            ],
        ],
        [
            'name' => '🎯 Global direct connection',
            'type' => 'select',
            'proxies' => [
                'DIRECT',
            ],
        ],
        [
            'name' => '🛑 Global Intercept',
            'type' => 'select',
            'proxies' => [
                'REJECT',
                'DIRECT',
            ],
        ],
        [
            'name' => '🐟 The fish that slipped through the net',
            'type' => 'select',
            // insert node name
            'proxies' => [
                '🔰 node selection',
                '🎯 Global direct connection',
                '♻️ Automatic selection',
            ],
        ],
    ],
    'rules' => [],
];
