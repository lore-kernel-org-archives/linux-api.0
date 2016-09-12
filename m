From: Guenter Roeck <linux@roeck-us.net>
Subject: Build failures in -next: sys_pkey_mprotect etc. undefined
Date: Mon, 12 Sep 2016 07:55:33 -0700
Message-ID: <9d74497b-1522-b350-42fa-49df2df48c4a@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>, "open list:ABI/API" <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Building h8300:allnoconfig ... failed
Building h8300:h8300h-sim_defconfig ... failed
Building c6x:dsk6455_defconfig ... failed

[ and more builds for the same architectures ]

--------------
Error log:
arch/h8300/kernel/built-in.o:(.data+0x480): undefined reference to `sys_pkey_mprotect'
arch/h8300/kernel/built-in.o:(.data+0x484): undefined reference to `sys_pkey_alloc'
arch/h8300/kernel/built-in.o:(.data+0x488): undefined reference to `sys_pkey_free'

Other architectures (frv, xtensa, score) currently fail to build for other reasons,
so I don't really know if the above are the only ones affected.

Guenter
