<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\Link;
use App\Models\Node;
use App\Models\UserSubscribeLog;
use App\Utils\Tools;
use Psr\Http\Message\ResponseInterface;
use Symfony\Component\Yaml\Yaml;
use App\Services\Config;

/**
 *  SubController
 */
final class SubController extends BaseController
{
    public static function getContent($request, $response, $args): ResponseInterface
    {
        if (!$_ENV['Subscribe']) {
            return $response->withJson([
                'ret' => 0,
            ]);
        }

        $token = $args['token'];
        $subtype = $args['subtype'];

        $sub_token = Link::where('token', $token)->first();
        if ($sub_token === null) {
            return $response->withJson([
                'ret' => 0,
            ]);
        }

        $user = $sub_token->getUser();
        if ($user === null) {
            return $response->withJson([
                'ret' => 0,
            ]);
        }

        $subtype_list = ['json', 'clash', 'sip008', 'surfboard'];
        if (!\in_array($subtype, $subtype_list)) {
            return $response->withJson([
                'ret' => 0,
            ]);
        }

        $sub_info = [];

        if ($subtype === 'json') {
            $sub_info = self::getJson($user);
        }

        if ($subtype === 'clash') {
            $sub_info = self::getClash($user);
        }

        if ($subtype === 'surfboard') {
            $sub_info = self::getSurfboard($user);
        }

        if ($subtype === 'sip008') {
            $sub_info = self::getSIP008($user);
        }

        if ($_ENV['subscribeLog'] === true) {
            UserSubscribeLog::addSubscribeLog($user, $subtype, $request->getHeaderLine('User-Agent'));
        }

        if ($subtype === 'json' || $subtype === 'sip008') {
            return $response->withJson([
                $sub_info,
            ]);
        }

        if ($subtype === 'clash') {
            $sub_details = ' upload=' . $user->u
                . '; download=' . $user->d
                . '; total=' . $user->transfer_enable
                . '; expire=' . strtotime($user->class_expire);
            return $response->withHeader('Subscription-Userinfo', $sub_details)->write(
                $sub_info
            );
        }

        if ($subtype === 'surfboard') {
            return $response->write(
                $sub_info
            );
        }
    }

    public static function getJson($user)
    {
        $nodes = [];
        //篩選出用戶能連接的節點
        $nodes_raw = Node::where('type', 1)
            ->where('node_class', '<=', $user->class)
            ->whereIn('node_group', [0, $user->node_group])
            ->where(static function ($query): void {
                $query->where('node_bandwidth_limit', '=', 0)->orWhereRaw('node_bandwidth < node_bandwidth_limit');
            })
            ->get();

        foreach ($nodes_raw as $node_raw) {
            $node_custom_config = \json_decode($node_raw->custom_config, true);
            //檢查是否配置“前端/订阅中下发的服务器地址”
            if (!\array_key_exists('server_user', $node_custom_config)) {
                $server = $node_raw->server;
            } else {
                $server = $node_custom_config['server_user'];
            }
            switch ($node_raw->sort) {
                case '0':
                    $plugin = $node_custom_config['plugin'] ?? '';
                    $plugin_option = $node_custom_config['plugin_option'] ?? '';
                    $node = [
                        'name' => $node_raw->name,
                        'id' => $node_raw->id,
                        'type' => 'ss',
                        'address' => $server,
                        'port' => (int) $user->port,
                        'password' => $user->passwd,
                        'encryption' => $user->method,
                        'plugin' => $plugin,
                        'plugin_option' => $plugin_option,
                        'remark' => $node_raw->info,
                    ];
                    break;
                case '11':
                    $v2_port = $node_custom_config['v2_port'] ?? ($node_custom_config['offset_port_user'] ?? ($node_custom_config['offset_port_node'] ?? 443));
                    //默認值有問題的請懂 V2 怎麽用的人來改一改。
                    $alter_id = $node_custom_config['alter_id'] ?? '0';
                    $security = $node_custom_config['security'] ?? 'none';
                    $flow = $node_custom_config['flow'] ?? '';
                    $encryption = $node_custom_config['encryption'] ?? '';
                    $network = $node_custom_config['network'] ?? '';
                    $header = $node_custom_config['header'] ?? ['type' => 'none'];
                    $header_type = $header['type'] ?? '';
                    $host = $node_custom_config['host'] ?? '';
                    $servicename = $node_custom_config['servicename'] ?? '';
                    $path = $node_custom_config['path'] ?? '/';
                    $tls = \in_array($security, ['tls', 'xtls']) ? '1' : '0';
                    $enable_vless = $node_custom_config['enable_vless'] ?? '0';
                    $node = [
                        'name' => $node_raw->name,
                        'id' => $node_raw->id,
                        'type' => 'vmess',
                        'address' => $server,
                        'port' => (int) $v2_port,
                        'uuid' => $user->uuid,
                        'alterid' => (int) $alter_id,
                        'security' => $security,
                        'flow' => $flow,
                        'encryption' => $encryption,
                        'network' => $network,
                        'header' => $header,
                        'header_type' => $header_type,
                        'host' => $host,
                        'path' => $path,
                        'servicename' => $servicename,
                        'tls' => (int) $tls,
                        'enable_vless' => (int) $enable_vless,
                        'remark' => $node_raw->info,
                    ];
                    break;
                case '14':
                    $trojan_port = $node_custom_config['trojan_port'] ?? ($node_custom_config['offset_port_user'] ?? ($node_custom_config['offset_port_node'] ?? 443));
                    $host = $node_custom_config['host'] ?? '';
                    $allow_insecure = $node_custom_config['allow_insecure'] ?? '0';
                    $security = $node_custom_config['security'] ?? \array_key_exists('enable_xtls', $node_custom_config) && $node_custom_config['enable_xtls'] === '1' ? 'xtls' : 'tls';
                    $mux = $node_custom_config['mux'] ?? '';
                    $transport = $node_custom_config['transport'] ?? \array_key_exists('grpc', $node_custom_config) && $node_custom_config['grpc'] === '1' ? 'grpc' : 'tcp';

                    $transport_plugin = $node_custom_config['transport_plugin'] ?? '';
                    $transport_method = $node_custom_config['transport_method'] ?? '';
                    $servicename = $node_custom_config['servicename'] ?? '';
                    $path = $node_custom_config['path'] ?? '';
                    $node = [
                        'name' => $node_raw->name,
                        'id' => $node_raw->id,
                        'type' => 'trojan',
                        'address' => $server,
                        'host' => $host,
                        'port' => (int) $trojan_port,
                        'uuid' => $user->uuid,
                        'security' => $security,
                        'mux' => $mux,
                        'transport' => $transport,
                        'transport_plugin' => $transport_plugin,
                        'transport_method' => $transport_method,
                        'allow_insecure' => (int) $allow_insecure,
                        'servicename' => $servicename,
                        'path' => $path,
                        'remark' => $node_raw->info,
                    ];
                    break;
            }
            if ($node === null) {
                continue;
            }
            $nodes[] = $node;
        }

        return [
            'version' => 2,
            'sub_name' => $_ENV['appName'],
            'user_email' => $user->email,
            'user_name' => $user->user_name,
            'user_class' => $user->class,
            'user_class_expire_date' => $user->class_expire,
            'user_total_traffic' => $user->transfer_enable,
            'user_used_traffic' => $user->u + $user->d,
            'nodes' => $nodes,
        ];
    }

    public static function getClash($user): string
    {
        $nodes = [];
        $clash_config = $_ENV['Clash_Config'];

        //篩選出用戶能連接的節點
        $nodes_raw = Node::where('type', 1)
            ->where('node_class', '<=', $user->class)
            ->whereIn('node_group', [0, $user->node_group])
            ->where(static function ($query): void {
                $query->where('node_bandwidth_limit', '=', 0)->orWhereRaw('node_bandwidth < node_bandwidth_limit');
            })
            ->get();

        foreach ($nodes_raw as $node_raw) {
            $node_custom_config = \json_decode($node_raw->custom_config, true);
            //檢查是否配置“前端/订阅中下发的服务器地址”
            if (!\array_key_exists('server_user', $node_custom_config)) {
                $server = $node_raw->server;
            } else {
                $server = $node_custom_config['server_user'];
            }
            switch ($node_raw->sort) {
                case '0':
                    $plugin = $node_custom_config['plugin'] ?? '';
                    $plugin_option = $node_custom_config['plugin_option'] ?? null;
                    // Clash 特定配置
                    $udp = $node_custom_config['udp'] ?? true;

                    $node = [
                        'name' => $node_raw->name,
                        'type' => 'ss',
                        'server' => $server,
                        // 'port' => (int) $user->port,
                        'port' => (int) $node_custom_config['mu_port'],
                        'password' => $user->passwd,
                        // 'cipher' => $user->method,
                        'cipher' => $node_custom_config['mu_encryption'],
                        'udp' => $udp,
                        'plugin' => $plugin,
                        'plugin-opts' => $plugin_option,
                    ];

                    break;
                case '11':
                    $v2_port = $node_custom_config['v2_port'] ?? ($node_custom_config['offset_port_user'] ?? ($node_custom_config['offset_port_node'] ?? 443));
                    $alter_id = $node_custom_config['alter_id'] ?? '0';
                    $security = $node_custom_config['security'] ?? 'none';
                    $encryption = $node_custom_config['encryption'] ?? 'auto';
                    $network = $node_custom_config['network'] ?? '';
                    $host = $node_custom_config['host'] ?? '';
                    $allow_insecure = $node_custom_config['allow_insecure'] ?? false;
                    $tls = \in_array($security, ['tls', 'xtls']) ? true : false;
                    // Clash 特定配置
                    $udp = $node_custom_config['udp'] ?? true;
                    $ws_opts = $node_custom_config['ws-opts'] ?? $node_custom_config['ws_opts'] ?? null;
                    $h2_opts = $node_custom_config['h2-opts'] ?? $node_custom_config['h2_opts'] ?? null;
                    $http_opts = $node_custom_config['http-opts'] ?? $node_custom_config['http_opts'] ?? null;
                    $grpc_opts = $node_custom_config['grpc-opts'] ?? $node_custom_config['grpc_opts'] ?? null;

                    $vless = $node_custom_config['enable_vless'];
                    $header = $node_custom_config['header'];

                    if ($vless || $header) {
                        break;
                    }


                    $node = [
                        'name' => $node_raw->name,
                        'type' => $vless ? 'vless' : 'vmess',
                        'server' => $server,
                        'port' => (int) $v2_port,
                        'uuid' => $user->uuid,
                        'alterId' => (int) $alter_id,
                        'cipher' => $encryption,
                        'udp' => $udp,
                        'tls' => $tls,
                        'header' => $header,

                        'skip-cert-verify' => $allow_insecure,
                        'servername' => $host,
                        'network' => $network,
                        'ws-opts' => $ws_opts,
                        'h2-opts' => $h2_opts,
                        'http-opts' => $http_opts,
                        'grpc-opts' => $grpc_opts,
                    ];

                    break;
                case '14':
                    $trojan_port = $node_custom_config['trojan_port'] ?? ($node_custom_config['offset_port_user'] ?? ($node_custom_config['offset_port_node'] ?? 443));
                    $network = $node_custom_config['network'] ?? \array_key_exists('grpc', $node_custom_config) && $node_custom_config['grpc'] === '1' ? 'grpc' : 'tcp';
                    $host = $node_custom_config['host'] ?? '';
                    $allow_insecure = $node_custom_config['allow_insecure'] ?? false;
                    // Clash 特定配置
                    $udp = $node_custom_config['udp'] ?? true;
                    $ws_opts = $node_custom_config['ws-opts'] ?? $node_custom_config['ws_opts'] ?? null;
                    $grpc_opts = $node_custom_config['grpc-opts'] ?? $node_custom_config['grpc_opts'] ?? null;

                    $node = [
                        'name' => $node_raw->name,
                        'type' => 'trojan',
                        'server' => $server,
                        'sni' => $host,
                        'port' => (int) $trojan_port,
                        'password' => $user->uuid,
                        'network' => $network,
                        'udp' => $udp,
                        'skip-cert-verify' => $allow_insecure,
                        'ws-opts' => $ws_opts,
                        'grpc-opts' => $grpc_opts,
                    ];

                    break;
            }
            if ($node === null) {
                continue;
            }
            $nodes[] = $node;

            $indexes = [0, 1];
            foreach ($indexes as $index) {
                $clash_config['proxy-groups'][$index]['proxies'][] = $node_raw->name;
            }
        }

        $clash = [
            'port' => 7890,
            'socks-port' => 7891,
            'allow-lan' => false,
            'mode' => 'Global',
            'log-level' => 'error',
            'external-controller' => '0.0.0.0:9090',
            'proxies' => $nodes,
        ];

        return Yaml::dump(\array_merge($clash, $clash_config), 3, 1);
    }


    // getSurfboard
    public static function getSurfboard($user): string
    {

        $Configs = $_ENV['Surfboard_Config'];

        //篩選出用戶能連接的節點
        $nodes_raw = Node::where('type', 1)
            ->where('node_class', '<=', $user->class)
            ->whereIn('node_group', [0, $user->node_group])
            ->where(static function ($query): void {
                $query->where('node_bandwidth_limit', '=', 0)->orWhereRaw('node_bandwidth < node_bandwidth_limit');
            })
            ->get();

        $nodes = [];
        foreach ($nodes_raw as $node_raw) {
            $node_custom_config = \json_decode($node_raw->custom_config, true);
            //檢查是否配置“前端/订阅中下发的服务器地址”
            if (!\array_key_exists('server_user', $node_custom_config)) {
                $server = $node_raw->server;
            } else {
                $server = $node_custom_config['server_user'];
            }
            switch ($node_raw->sort) {
                case '0':
                    $plugin = $node_custom_config['plugin'] ?? '';
                    $plugin_option = $node_custom_config['plugin_option'] ?? null;
                    // Clash 特定配置
                    $udp = $node_custom_config['udp'] ?? true;

                    $node = [
                        'name' => $node_raw->name,
                        'type' => 'ss',
                        'server' => $server,
                        // 'port' => (int) $user->port,
                        'port' => (int) $node_custom_config['mu_port'],
                        'password' => $user->passwd,
                        // 'cipher' => $user->method,
                        'cipher' => $node_custom_config['mu_encryption'],
                        'udp' => $udp,
                        'plugin' => $plugin,
                        'plugin-opts' => $plugin_option,
                    ];

                    break;
                case '11':
                    $v2_port = $node_custom_config['v2_port'] ?? ($node_custom_config['offset_port_user'] ?? ($node_custom_config['offset_port_node'] ?? 443));
                    $alter_id = $node_custom_config['alter_id'] ?? '0';
                    $security = $node_custom_config['security'] ?? 'none';
                    $encryption = $node_custom_config['encryption'] ?? 'auto';
                    $network = $node_custom_config['network'] ?? '';
                    $host = $node_custom_config['host'] ?? '';
                    $allow_insecure = $node_custom_config['allow_insecure'] ?? false;
                    $tls = \in_array($security, ['tls', 'xtls']) ? true : false;
                    // Clash 特定配置
                    $udp = $node_custom_config['udp'] ?? true;
                    $ws_opts = $node_custom_config['ws-opts'] ?? $node_custom_config['ws_opts'] ?? null;
                    $h2_opts = $node_custom_config['h2-opts'] ?? $node_custom_config['h2_opts'] ?? null;
                    $http_opts = $node_custom_config['http-opts'] ?? $node_custom_config['http_opts'] ?? null;
                    $grpc_opts = $node_custom_config['grpc-opts'] ?? $node_custom_config['grpc_opts'] ?? null;

                    $vless = $node_custom_config['enable_vless'];
                    $header = $node_custom_config['header'];

                    if ($vless || $header) {
                        break;
                    }



                    $node = [
                        'name' => $node_raw->name,
                        'type' => $vless ? 'vless' : 'vmess',
                        'server' => $server,
                        'port' => (int) $v2_port,
                        'uuid' => $user->uuid,
                        'alterId' => (int) $alter_id,
                        'cipher' => $encryption,
                        'udp' => $udp,
                        'tls' => $tls,
                        'header' => $header,

                        'skip-cert-verify' => $allow_insecure,
                        'servername' => $host,
                        'network' => $network,
                        'ws-opts' => $ws_opts,
                        'h2-opts' => $h2_opts,
                        'http-opts' => $http_opts,
                        'grpc-opts' => $grpc_opts,
                    ];

                    break;
                case '14':
                    $trojan_port = $node_custom_config['trojan_port'] ?? ($node_custom_config['offset_port_user'] ?? ($node_custom_config['offset_port_node'] ?? 443));
                    $network = $node_custom_config['network'] ?? \array_key_exists('grpc', $node_custom_config) && $node_custom_config['grpc'] === '1' ? 'grpc' : 'tcp';
                    $host = $node_custom_config['host'] ?? '';
                    $allow_insecure = $node_custom_config['allow_insecure'] ?? false;

                    // Clash 特定配置
                    $udp = $node_custom_config['udp'] ?? true;
                    $ws_opts = $node_custom_config['ws-opts'] ?? $node_custom_config['ws_opts'] ?? null;
                    $grpc_opts = $node_custom_config['grpc-opts'] ?? $node_custom_config['grpc_opts'] ?? null;

                    // surge
                    if ($network == 'grpc') {
                        break;
                    }

                    $node = [
                        'name' => $node_raw->name,
                        'type' => 'trojan',
                        'server' => $server,
                        'sni' => $host,
                        'port' => (int) $trojan_port,
                        'password' => $user->uuid,
                        'network' => $network,
                        'udp' => $udp,
                        'skip-cert-verify' => $allow_insecure,
                        'ws-opts' => $ws_opts,
                        'grpc-opts' => $grpc_opts,
                    ];

                    break;
            }
            if ($node === null) {
                continue;
            }
            $nodes[] = $node;

            // $indexes = [0, 1];
            // foreach ($indexes as $index) {
            //     $clash_config['proxy-groups'][$index]['proxies'][] = $node_raw->name;
            // }
        }

        $Nodes = [];
        $General = (isset($Configs['General']) ? self::getSurgeConfGeneral($Configs['General']) : '');
        $Proxies = (isset($Configs['Proxy']) ? self::getSurgeConfProxy($Configs['Proxy']) : '');
        $NodesProxies = "";
        foreach ($nodes as $item) {
            $out = self::getSurfboardURI($item);
            if ($out !== null) {
                $Nodes[] = $item;
                $NodesProxies .= $out . PHP_EOL;
            }
        }

        $ProxyGroup = "";
        $Rule = "";

        // $ProxyGroups = self::getSurgeConfProxyGroup(
        //     $nodes,
        //     $Configs['ProxyGroups']
        // );
        // $ProxyGroup = self::fixSurgeProxyGroup($ProxyGroups, $Configs['Checks']);
        // $ProxyGroup = self::getSurgeProxyGroup2String($ProxyGroups);

        $Conf = [
            '#!MANAGED-CONFIG ' . $_ENV['subUrl'] . $_SERVER['REQUEST_URI'] . ' interval=60 strict=true',
            '',
            '#---------------------------------------------------#',
            '# Last update:' . date("Y-m-d h:i:s"),
            '#---------------------------------------------------#',
            '',
            '[General]',
            $General,
            '',
            '[Proxy]',
            '# Build in policy',
            $Proxies,
            '',
            '# Supported proxies',
            $NodesProxies,
            '',
            '[Proxy Group]',
            $ProxyGroup,
            '',
            '[Rule]',
            $Rule
        ];

        return implode(PHP_EOL, $Conf);
    }

    public static function getSurgeObfs(array $item): string
    {
        $ss_obfs_list = Config::getSupportParam('ss_obfs');
        $plugin = '';
        if (in_array($item['obfs'], $ss_obfs_list)) {
            if (strpos($item['obfs'], 'http') !== false) {
                $plugin .= ', obfs=http';
            } else {
                $plugin .= ', obfs=tls';
            }
            if ($item['obfs_param'] != '') {
                $plugin .= ', obfs-host=' . $item['obfs_param'];
            } else {
                $plugin .= ', obfs-host=wns.windows.com';
            }
        }
        return $plugin;
    }

    // getSurfboardURI
    public static function getSurfboardURI(array $item)
    {
        $return = null;
        switch ($item['type']) {
            case 'ss':
                if ($item['obfs'] == 'v2ray') {
                    break;
                }
                $return = ($item['name'] . ' = custom, ' . $item['server'] . ', ' . $item['port'] . ', ' . $item['cipher'] . ', ' . $item['password'] . ', https://raw.githubusercontent.com/lhie1/Rules/master/SSEncrypt.module' . self::getSurgeObfs($item));
                break;
            case 'vmess':
                if (!in_array($item['network'], ['ws', 'tcp'])) {
                    break;
                }
                $return = $item['name'] . ' = vmess, '
                    . $item['server'] . ', '
                    . $item['port']
                    . ', username = ' . $item['uuid']
                    . ', vmess-aead = true, tfo = true, udp-relay = true';

                if ($item['tls'] == 'tls') {
                    $return .= ', tls=true';
                    if ($item['verify_cert'] == false) {
                        $return .= ', skip-cert-verify=true';
                    }
                    if (isset($item['sni']) && $item['sni']) {
                        $return .= ', sni=' . $item['sni'];
                    }
                }
                if ($item['network'] == 'ws') {
                    $return .= ', ws=true';
                    if (isset($item['path']) && $item['path']) {
                        $return .= ', ws-path=' . $item['path'];
                    }
                    if (isset($item['host']) && $item['host']) {
                        $return .= ', ws-headers=host:' . $item['host'];
                    }
                }
                break;
            case 'trojan':
                $return = $item['name'] . ' = trojan,' . $item['server'] . ', ' . $item['port'] . ', password=' . $item['password'] . ',sni=' . $item['host'];
                break;
        }
        return $return;
    }

    public static function getSurgeConfGeneral($General)
    {
        $return = '';
        if (count($General) != 0) {
            foreach ($General as $key => $value) {
                $return .= $key . ' = ' . $value . PHP_EOL;
            }
        }
        return $return;
    }

    /**
     * Surge 配置中的 Proxy
     *
     * @param array $Proxys 自定义配置中的额外 Proxy
     *
     * @return string
     */
    public static function getSurgeConfProxy($Proxys)
    {
        $return = '';
        if (count($Proxys) != 0) {
            foreach ($Proxys as $value) {
                if (!preg_match('/(\[General|Replica|Proxy|Proxy\sGroup|Rule|Host|URL\sRewrite|Header\sRewrite|MITM|Script\])/', $value)) {
                    $return .= $value . PHP_EOL;
                }
            }
        }
        return $return;
    }



    public static function getMatchProxy($Proxy, $Rule)
    {
        $return = null;
        switch (true) {
            case (isset($Rule['content']['class'])):
                if (in_array($Proxy['class'], $Rule['content']['class'])) {
                    if (isset($Rule['content']['regex'])) {
                        if (preg_match('/' . $Rule['content']['regex'] . '/i', $Proxy['remark'])) {
                            $return = $Proxy;
                        }
                    } else {
                        $return = $Proxy;
                    }
                }
                break;
            case (isset($Rule['content']['noclass'])):
                if (!in_array($Proxy['class'], $Rule['content']['noclass'])) {
                    if (isset($Rule['content']['regex'])) {
                        if (preg_match('/' . $Rule['content']['regex'] . '/i', $Proxy['remark'])) {
                            $return = $Proxy;
                        }
                    } else {
                        $return = $Proxy;
                    }
                }
                break;
            case (!isset($Rule['content']['class'])
                && !isset($Rule['content']['noclass'])
                && isset($Rule['content']['regex'])
                && preg_match('/' . $Rule['content']['regex'] . '/i', $Proxy['remark'])
            ):
                $return = $Proxy;
                break;
        }

        return $return;
    }

    /**
     * Surge 配置中的 ProxyGroup
     *
     * @param array $Nodes       全部节点数组
     * @param array $ProxyGroups Surge 策略组定义
     *
     * @return array
     */
    public static function getSurgeConfProxyGroup($Nodes, $ProxyGroups)
    {
        $return = [];
        foreach ($ProxyGroups as $ProxyGroup) {
            if (in_array($ProxyGroup['type'], ['select', 'url-test', 'fallback', 'load-balance'])) {
                $proxies = [];
                if (
                    isset($ProxyGroup['content']['left-proxies'])
                    && count($ProxyGroup['content']['left-proxies']) != 0
                ) {
                    $proxies = $ProxyGroup['content']['left-proxies'];
                }
                foreach ($Nodes as $item) {
                    $item = self::getMatchProxy($item, $ProxyGroup);
                    if ($item !== null && !in_array($item['remark'], $proxies)) {
                        $proxies[] = $item['remark'];
                    }
                }
                if (isset($ProxyGroup['content']['right-proxies'])) {
                    $proxies = array_merge($proxies, $ProxyGroup['content']['right-proxies']);
                }
                $ProxyGroup['proxies'] = $proxies;
            }
            $return[] = $ProxyGroup;
        }

        return $return;
    }

    /**
     * Surge ProxyGroup 去除无用策略组
     *
     * @param array $ProxyGroups 策略组
     * @param array $checks      要检查的策略组名
     *
     * @return array
     */
    public static function fixSurgeProxyGroup($ProxyGroups, $checks)
    {
        if (count($checks) == 0) {
            return $ProxyGroups;
        }
        $clean_names = [];
        $newProxyGroups = [];
        foreach ($ProxyGroups as $ProxyGroup) {
            if (in_array($ProxyGroup['name'], $checks) && count($ProxyGroup['proxies']) == 0) {
                $clean_names[] = $ProxyGroup['name'];
                continue;
            }
            $newProxyGroups[] = $ProxyGroup;
        }
        if (count($clean_names) >= 1) {
            $ProxyGroups = $newProxyGroups;
            $newProxyGroups = [];
            foreach ($ProxyGroups as $ProxyGroup) {
                if (!in_array($ProxyGroup['name'], $checks) && $ProxyGroup['type'] != 'ssid') {
                    $newProxies = [];
                    foreach ($ProxyGroup['proxies'] as $proxie) {
                        if (!in_array($proxie, $clean_names)) {
                            $newProxies[] = $proxie;
                        }
                    }
                    $ProxyGroup['proxies'] = $newProxies;
                }
                $newProxyGroups[] = $ProxyGroup;
            }
        }

        return $newProxyGroups;
    }

    /**
     * Surge ProxyGroup 转字符串
     *
     * @param array $ProxyGroups Surge 策略组定义
     *
     * @return string
     */
    public static function getSurgeProxyGroup2String($ProxyGroups)
    {
        $return = '';
        foreach ($ProxyGroups as $ProxyGroup) {
            $str = '';
            if (in_array($ProxyGroup['type'], ['select', 'url-test', 'fallback', 'load-balance'])) {
                $proxies = implode(', ', $ProxyGroup['proxies']);
                if (in_array($ProxyGroup['type'], ['url-test', 'fallback', 'load-balance'])) {
                    $str .= ($ProxyGroup['name']
                        . ' = '
                        . $ProxyGroup['type']
                        . ', '
                        . $proxies
                        . ', url = ' . $ProxyGroup['url']
                        . ', interval = ' . $ProxyGroup['interval']);
                } else {
                    $str .= ($ProxyGroup['name']
                        . ' = '
                        . $ProxyGroup['type']
                        . ', '
                        . $proxies);
                }
            } elseif ($ProxyGroup['type'] == 'ssid') {
                $wifi = '';
                foreach ($ProxyGroup['content'] as $key => $value) {
                    $wifi .= ', "' . $key . '" = ' . $value;
                }
                $cellular = (isset($ProxyGroup['cellular'])
                    ? ', cellular = ' . $ProxyGroup['cellular']
                    : '');
                $str .= ($ProxyGroup['name']
                    . ' = '
                    . $ProxyGroup['type']
                    . ', default = '
                    . $ProxyGroup['default']
                    . $cellular
                    . $wifi);
            } else {
                $str .= '';
            }
            $return .= $str . PHP_EOL;
        }
        return $return;
    }

    // SIP008 SS
    public static function getSIP008($user): void
    {
    }

    public static function getUniversalSub($user)
    {
        $userid = $user->id;
        $token = Link::where('userid', $userid)->first();
        if ($token === null) {
            $token = new Link();
            $token->userid = $userid;
            $token->token = Tools::genSubToken();
            $token->save();
        }
        return $_ENV['subUrl'] . '/sub/' . $token->token;
    }
}
