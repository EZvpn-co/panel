<?php

declare(strict_types=1);

namespace App\Models;

/**
 * Code Model
 */
final class Code extends Model
{
    protected $connection = 'default';

    protected $table = 'code';

    /**
     * 用户
     */
    public function user(): ?User
    {
        return User::find($this->userid);
    }

    /**
     * 用户 ID
     */
    public function userid(): int
    {
        return $this->userid;
    }

    /**
     * 用户名
     */
    public function userName(): string
    {
        if ($this->userid === 0) {
            return 'Unused';
        }
        if ($this->user() === null) {
            return 'User no longer exists';
        }
        return $this->user()->user_name;
    }

    /**
     * 类型
     */
    public function type(): string
    {
        switch ($this->type) {
            case -1:
                return 'Recharge amount';
            case -2:
                return 'Financial expenditure';
            default:
                return 'Obsolete';
        }
    }

    /**
     * operate
     */
    public function number(): string
    {
        switch ($this->type) {
            case -1:
                return 'Recharge ' . $this->number . ' $';
            case -2:
                return 'Expenditure ' . $this->number . ' $';
            default:
                return 'Obsolete';
        }
    }

    /**
     * 是否已经使用
     */
    public function isused(): string
    {
        return $this->isused === 1 ? 'Used' : 'Unused';
    }

    /**
     * 使用时间
     */
    public function usedatetime(): string
    {
        return $this->usedatetime > '2000-1-1 0:0:0' ? $this->usedatetime : 'Unused';
    }
}
