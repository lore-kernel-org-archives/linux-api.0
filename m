From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Build failures in -next: sys_pkey_mprotect etc. undefined
Date: Mon, 12 Sep 2016 08:03:51 -0700
Message-ID: <57D6C3D7.2040606@linux.intel.com>
References: <9d74497b-1522-b350-42fa-49df2df48c4a@roeck-us.net>
 <9369809.1DWhqOZ7mo@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9369809.1DWhqOZ7mo@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Guenter Roeck <linux@roeck-us.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, "open list:ABI/API" <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 09/12/2016 07:59 AM, Arnd Bergmann wrote:
> On Monday, September 12, 2016 7:55:33 AM CEST Guenter Roeck wrote:
>> Building h8300:allnoconfig ... failed
>> Building h8300:h8300h-sim_defconfig ... failed
>> Building c6x:dsk6455_defconfig ... failed
>>
>> [ and more builds for the same architectures ]
>>
>> --------------
>> Error log:
>> arch/h8300/kernel/built-in.o:(.data+0x480): undefined reference to `sys_pkey_mprotect'
>> arch/h8300/kernel/built-in.o:(.data+0x484): undefined reference to `sys_pkey_alloc'
>> arch/h8300/kernel/built-in.o:(.data+0x488): undefined reference to `sys_pkey_free'
>>
>> Other architectures (frv, xtensa, score) currently fail to build for other reasons,
>> so I don't really know if the above are the only ones affected.
> 
> I think the best solution would be to add them to kernel/sys_ni.c so we can
> assign syscall numbers for all architectures regardless of whether they use it
> or not (most of them will never use these AFAICT).

Urg, sorry about the breakage.  I'll see if I can reproduce it and get a
patch out later today that does this.
