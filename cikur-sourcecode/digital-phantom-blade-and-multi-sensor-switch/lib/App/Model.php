<?php
/**
 * Created by PhpStorm.
 * User: ark
 * Date: 8/27/2016
 * Time: 6:55 PM
 */

namespace App;


use Slim\Exception\SlimException;
use Slim\PDO\Database;

class Model
{
    public $db;
    public $response;

    function __construct($response)
    {
        $dsn = 'mysql:host=' . getenv("DB_HOST") . ';dbname=' . getenv("DB_NAME") . ';charset=utf8';
        $usr = getenv("DB_USER");
        $pwd = getenv("DB_PASSWORD");
        $this->db = new Database($dsn, $usr, $pwd);
        $this->response = $response;
    }

    public function getDevices()
    {
        return $this->db->select()->from('devices')->where('status', '=', '1')->execute()->fetchall();
    }

    public function getStatusDevice($deviceId, $type)
    {
        $response = $this->db->select(['id_url', 'url', 'icon', 'notes'])->from('url')->where('type', '=', $type)->where('device_id', '=', $deviceId)
            ->execute()->fetch();
        if (isset($response['url'])) {
            return $response;
        }
        return '';
    }

    public function setStatusDevice($deviceId, $type, $time = 0, $execute = 0)
    {
        /*
         * format
         * deviceId_type_time_execute
         */
        $response = $this->db->select(['url'])->from('url')->where('type', '=', $type)->where('device_id', '=', $deviceId)
            ->execute()->fetch();
        if (isset($response['url'])) {
            return $response['url'] . $deviceId . '_' . $type . '_' . $time . '_' . $execute;
        }
        return '';

    }

}