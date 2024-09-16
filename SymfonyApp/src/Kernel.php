<?php

/*
 * This file is part of the Symfony package.
 *
 * (c) Fabien Potencier <fabien@symfony.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace App;

use Bref\SymfonyBridge\BrefKernel;
use Symfony\Bundle\FrameworkBundle\Kernel\MicroKernelTrait;

final class Kernel extends BrefKernel
{
    use MicroKernelTrait;

    protected function getWritableCacheDirectories(): array
    {
        return [];
    }
}
