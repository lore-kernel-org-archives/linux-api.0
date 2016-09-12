From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Build failures in -next: sys_pkey_mprotect etc. undefined
Date: Mon, 12 Sep 2016 13:09:17 -0700
Message-ID: <57D70B6D.6010208@linux.intel.com>
References: <9d74497b-1522-b350-42fa-49df2df48c4a@roeck-us.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030405050006070402010506"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <9d74497b-1522-b350-42fa-49df2df48c4a@roeck-us.net>
Sender: linux-arch-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>, "open list:ABI/API" <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------030405050006070402010506
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 09/12/2016 07:55 AM, Guenter Roeck wrote:
> Building h8300:allnoconfig ... failed
> Building h8300:h8300h-sim_defconfig ... failed
> Building c6x:dsk6455_defconfig ... failed
> 
> [ and more builds for the same architectures ]
> 
> --------------
> Error log:
> arch/h8300/kernel/built-in.o:(.data+0x480): undefined reference to
> `sys_pkey_mprotect'
> arch/h8300/kernel/built-in.o:(.data+0x484): undefined reference to
> `sys_pkey_alloc'
> arch/h8300/kernel/built-in.o:(.data+0x488): undefined reference to
> `sys_pkey_free'

So, I've done what Arnd suggested, but I don't have a working
cross-compiler than can do h8300 or c6x.  Could you test the attached
patch and see if it gets things working for you?

Also, do you have a handy place to grab a cross-compiler for h8300
without having to build one?  The kernel.org ones don't seem to work for
h8300.


--------------030405050006070402010506
Content-Type: text/x-patch;
 name="fix-pkeys-arch-breakage.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix-pkeys-arch-breakage.patch"


Guenter Roeck reported breakage on the h8300 and c6x architectures
(among others) caused by the new memory protection keys syscalls.
This patch does what Arnd suggested and adds them to
kernel/sys_ni.c.

I don't have a cross-compiler for either of these architectures
handy, and kernel.org doesn't provide one either, so I have not
built this patch.  Testing would be appreciated.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "open list:ABI/API" <linux-api@vger.kernel.org>
Cc: linux-arch@vger.kernel.org

---

 b/kernel/sys_ni.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/sys_ni.c~fix-pkeys-arch-breakage kernel/sys_ni.c
--- a/kernel/sys_ni.c~fix-pkeys-arch-breakage	2016-09-12 12:50:47.801607239 -0700
+++ b/kernel/sys_ni.c	2016-09-12 12:50:47.804607374 -0700
@@ -250,3 +250,8 @@ cond_syscall(sys_execveat);
 
 /* membarrier */
 cond_syscall(sys_membarrier);
+
+/* memory protection keys */
+cond_syscall(sys_pkey_mprotect);
+cond_syscall(sys_pkey_alloc);
+cond_syscall(sys_pkey_free);
_

--------------030405050006070402010506--
