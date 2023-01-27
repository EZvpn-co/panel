<?php

declare(strict_types=1);

$_ENV['Clash_Config'] = [
    'proxy-groups' => [
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
                '🔰 节点选择',
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
                '🔰 节点选择',
            ],
        ],
        [
            'name' => '🚫 运营劫持',
            'type' => 'select',
            'proxies' => [
                '🛑 全球拦截',
                '🎯 全球直连',
                '🔰 节点选择',
            ],
        ],
        [
            'name' => '🌍 国外媒体',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🔰 节点选择',
                '♻️ 自动选择',
                '🎯 全球直连',
            ],
        ],
        [
            'name' => '🌏 国内媒体',
            'type' => 'select',
            'proxies' => [
                '🎯 全球直连',
                '🔰 节点选择',
            ],
        ],
        [
            'name' => 'Ⓜ️ 微软服务',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🎯 全球直连',
                '🔰 节点选择',
            ],
        ],
        [
            'name' => '📲 电报信息',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🔰 节点选择',
                '🎯 全球直连',
            ],
        ],
        [
            'name' => '🍎 苹果服务',
            'type' => 'select',
            // 插入节点名称
            'proxies' => [
                '🔰 节点选择',
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
    ],
    'rules' => [
        'MATCH,🔰 节点选择'
    ],
];
