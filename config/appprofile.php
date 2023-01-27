<?php

declare(strict_types=1);

$_ENV['Clash_Config'] = [
    'proxy-groups' => [
        [
            'name' => '🔰 Select',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '♻️ 自动选择',
                '🎯 全球直连',
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
        [
            'name' => '🎥 NETFLIX',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🔰 Select',
                '♻️ 自动选择',
                '🎯 全球直连',
            ],
        ],
        [
            'name' => '⛔️ 广告拦截',
            'type' => 'select',
            'proxies' => [
                '🛑 全球拦截',
                '🎯 全球直连',
                '🔰 Select',
            ],
        ],
        [
            'name' => '🚫 运营劫持',
            'type' => 'select',
            'proxies' => [
                '🛑 全球拦截',
                '🎯 全球直连',
                '🔰 Select',
            ],
        ],
        [
            'name' => '🌍 国外媒体',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🔰 Select',
                '♻️ 自动选择',
                '🎯 全球直连',
            ],
        ],
        [
            'name' => '🌏 国内媒体',
            'type' => 'select',
            'proxies' => [
                '🎯 全球直连',
                '🔰 Select',
            ],
        ],
        [
            'name' => 'Ⓜ️ 微软服务',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🎯 全球直连',
                '🔰 Select',
            ],
        ],
        [
            'name' => '📲 电报信息',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🔰 Select',
                '🎯 全球直连',
            ],
        ],
        [
            'name' => '🍎 苹果服务',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🔰 Select',
                '🎯 全球直连',
                '♻️ 自动选择',
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
            'name' => '🛑 全球拦截',
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
                '🔰 Select',
                '🎯 全球直连',
                '♻️ 自动选择',
            ],
        ],
    ],
    'rules' => [
        'MATCH,🔰 Select'
    ],
];
