<?php
/**
 * Created by PhpStorm.
 * User: ark
 * Date: 8/27/2016
 * Time: 7:10 PM
 */

namespace App;


class Home extends Model
{
    public $renderer;

    function __construct($reponse, $render)
    {
        parent::__construct($reponse);
        $this->response = $reponse;
        $this->renderer = $render;
    }

    public function getHome()
    {
        $devices = $this->getDevices();
        $status_devices = [];
        if ($devices) {
            foreach ($devices as $item) {
                $result = $this->getStatusDevice($item['id'], 'STATUS');
                $statusOn = $this->getStatusDevice($item['id'], 'ON');
                $statusOff = $this->getStatusDevice($item['id'], 'OFF');
                $status_devices[] = [
                    'id' => $item['id'],
                    'name' => $item['name'],
                    'type' => $result['notes'],
                    'url' => $result['url'],
                    'icon' => $result['icon'],
                    'on' => [
                        'type' => $statusOn['notes'],
                        'url' => $statusOn['url'],
                        'icon' => $statusOn['icon'],
                    ],
                    'off' => [
                        'type' => $statusOff['notes'],
                        'url' => $statusOff['url'],
                        'icon' => $statusOff['icon'],
                    ]
                ];
            }
        }

        $data = [
            'devices' => $status_devices
        ];
        $content = $this->renderer->fetch('/smart/home.phtml', $data);
        $script = $this->renderer->fetch('/smart/home_script.phtml', $data);
        return $this->renderer->render($this->response, "/smart/layout.phtml", ['content' => $content, 'script' => $script]);
    }

    public function getHomeDPB()
    {
        $url = $this->db->select()->from('conf_url')->orderBy('id', 'desc')->execute()->fetchAll();
        $content = $this->renderer->fetch('/dpb/smart/home.phtml', ['url' => $url]);
        $script = $this->renderer->fetch('/dpb/smart/home_script.phtml', ['url' => $url]);
        return $this->renderer->render($this->response, "/dpb/smart/layout.phtml", ['content' => $content, 'script' => $script]);
    }

    public function getConfiguration($msg)
    {
        $devices = $this->getDevices();
        $status_devices = [];
        if ($devices) {
            foreach ($devices as $item) {
                $result = $this->getStatusDevice($item['id'], 'STATUS');
                $statusOn = $this->getStatusDevice($item['id'], 'ON');
                $statusOff = $this->getStatusDevice($item['id'], 'OFF');
                $status_devices[] = [
                    'id' => $result['id_url'],
                    'name' => $item['name'],
                    'type' => $result['notes'],
                    'url' => $result['url'],
                    'icon' => $result['icon'],
                    'on' => [
                        'id' => $statusOn['id_url'],
                        'type' => $statusOn['notes'],
                        'url' => $statusOn['url'],
                        'icon' => $statusOn['icon'],
                    ],
                    'off' => [
                        'id' => $statusOff['id_url'],
                        'type' => $statusOff['notes'],
                        'url' => $statusOff['url'],
                        'icon' => $statusOff['icon'],
                    ]
                ];
            }
        }
        $data = [
            'devices' => $status_devices,
            'msg' => $msg
        ];
        $content = $this->renderer->fetch('/smart/configuration.phtml', $data);
        return $this->renderer->render($this->response, "/smart/layout.phtml", ['content' => $content]);
    }

    public function saveConfiguration($data)
    {
        foreach ($data['status'] as $key => $val) {
            $status = $this->db
                ->update(['url' => $val])
                ->table('url')
                ->where('id_url', '=', $key)->execute();
        }
        foreach ($data['on'] as $key => $val) {
            $status = $this->db
                ->update(['url' => $val])
                ->table('url')
                ->where('id_url', '=', $key)->execute();
        }
        foreach ($data['off'] as $key => $val) {
            $status = $this->db
                ->update(['url' => $val])
                ->table('url')
                ->where('id_url', '=', $key)->execute();
        }

        return $this->response->withStatus(302)->withHeader('Location', '/smart/configuration/data has been saved');
    }

    public function getConfigurationDPB($msg)
    {
        $url = $this->db->select()->from('scanning')->execute()->fetchall();
        $data = [
            'url' => $url
        ];
        $content = $this->renderer->fetch('/dpb/smart/configuration.phtml', $data);
        $script = $this->renderer->fetch('/dpb/smart/config_script.phtml', $data);

        return $this->renderer->render($this->response, "/dpb/smart/layout.phtml", ['content' => $content, 'script' => $script]);
    }

    public function saveConfigurationDPB($data)
    {
        $exist = $this->db->select()->from('conf_url')
            ->where('type', '=', $data['type'])
            ->orderBy('id', 'desc')
            ->execute()->fetch();
        $sc = $this->db->select()->from('scanning')
            ->where('id', '=', $data['id'])
            ->execute()
            ->fetch();
        if ($exist && $sc) {
            return $this->db
                ->update(['url' => $sc['url']])
                ->table('conf_url')
                ->where('id', '=', $exist['id'])->execute();
        } else {
            if ($sc) {
                return $this->db->insert(['url', 'type'])
                    ->into('conf_url')
                    ->values([$sc['url'], $data['type']])
                    ->execute();
            }
        }
    }

    public function dpbUrlremove($id)
    {
        $this->db->delete()
            ->from('scanning')
            ->where('id', '=', $id)
            ->execute();
    }
}