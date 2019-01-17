From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 2/5] ipc: introduce ksys_ipc()/compat_ksys_ipc() for s390
Date: Thu, 17 Jan 2019 14:29:06 +0100
Message-ID: <20190117132906.GB18351@osiris>
References: <20190116131527.2071570-1-arnd@arndb.de>
 <20190116131527.2071570-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190116131527.2071570-3-arnd@arndb.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org, y2038@lists.linaro.org, Dominik Brodowski <linux@dominikbrodowski.net>, Mark Rutland <mark.rutland@arm.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 16, 2019 at 02:15:20PM +0100, Arnd Bergmann wrote:
> The sys_ipc() and compat_ksys_ipc() functions are meant to only
> be used from the system call table, not called by another function.
> 
> Introduce ksys_*() interfaces for this purpose, as we have done
> for many other system calls.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/s390/kernel/compat_linux.c |  2 +-
>  arch/s390/kernel/sys_s390.c     |  2 +-
>  include/linux/syscalls.h        |  4 ++++
>  ipc/syscall.c                   | 20 ++++++++++++++++----
>  4 files changed, 22 insertions(+), 6 deletions(-)

The patch below is needed as compile fix (allnoconfig).
I will add this to your patch, no resend needed.

diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index 6aa8fe00b39e..fd0cbbed4d9f 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -58,6 +58,7 @@ SYSCALL_DEFINE1(mmap2, struct s390_mmap_arg_struct __user *, arg)
 	return error;
 }
 
+#ifdef CONFIG_SYSVIPC
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls.
  */
@@ -76,6 +77,7 @@ SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, unsigned long, second,
 	 */
 	return ksys_ipc(call, first, second, third, ptr, third);
 }
+#endif /* CONFIG_SYSVIPC */
 
 SYSCALL_DEFINE1(s390_personality, unsigned int, personality)
 {
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index ab9d0e3c6d50..ad016a7db0ea 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -366,7 +366,7 @@ COND_SYSCALL(kexec_file_load);
 /* s390 */
 COND_SYSCALL(s390_pci_mmio_read);
 COND_SYSCALL(s390_pci_mmio_write);
-COND_SYSCALL_COMPAT(s390_ipc);
+COND_SYSCALL(s390_ipc);
 
 /* powerpc */
 COND_SYSCALL(rtas);
