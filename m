From: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [Qemu-devel] [PATCH 19/23] userfaultfd: activate syscall
Date: Tue, 11 Aug 2015 15:37:29 +0530
Message-ID: <20150811100728.GB4587@in.ibm.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
 <1431624680-20153-20-git-send-email-aarcange@redhat.com>
Reply-To: bharata@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431624680-20153-20-git-send-email-aarcange@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-api@vger.kernel.org, zhang.zhanghailiang@huawei.com, Pavel Emelyanov <xemul@parallels.com>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, Dave Hansen <dave.hansen@intel.com>, Andres Lagar-Cavilla <andreslc@google.com>, Mel Gorman <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Feiner <pfeiner@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, May 14, 2015 at 07:31:16PM +0200, Andrea Arcangeli wrote:
> This activates the userfaultfd syscall.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/powerpc/include/asm/systbl.h      | 1 +
>  arch/powerpc/include/uapi/asm/unistd.h | 1 +
>  arch/x86/syscalls/syscall_32.tbl       | 1 +
>  arch/x86/syscalls/syscall_64.tbl       | 1 +
>  include/linux/syscalls.h               | 1 +
>  kernel/sys_ni.c                        | 1 +
>  6 files changed, 6 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
> index f1863a1..4741b15 100644
> --- a/arch/powerpc/include/asm/systbl.h
> +++ b/arch/powerpc/include/asm/systbl.h
> @@ -368,3 +368,4 @@ SYSCALL_SPU(memfd_create)
>  SYSCALL_SPU(bpf)
>  COMPAT_SYS(execveat)
>  PPC64ONLY(switch_endian)
> +SYSCALL_SPU(userfaultfd)
> diff --git a/arch/powerpc/include/uapi/asm/unistd.h b/arch/powerpc/include/uapi/asm/unistd.h
> index e4aa173..6ad58d4 100644
> --- a/arch/powerpc/include/uapi/asm/unistd.h
> +++ b/arch/powerpc/include/uapi/asm/unistd.h
> @@ -386,5 +386,6 @@
>  #define __NR_bpf		361
>  #define __NR_execveat		362
>  #define __NR_switch_endian	363
> +#define __NR_userfaultfd	364

May be it is a bit late to bring this up, but I needed the following fix
to userfault21 branch of your git tree to compile on powerpc.
----

powerpc: Bump up __NR_syscalls to account for __NR_userfaultfd

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

With userfaultfd syscall, the number of syscalls will be 365 on PowerPC.
Reflect the same in __NR_syscalls.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/unistd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index f4f8b66..4a055b6 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -12,7 +12,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define __NR_syscalls		364
+#define __NR_syscalls		365
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls

