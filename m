From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 19/23] userfaultfd: activate syscall
Date: Tue, 11 Aug 2015 15:48:26 +0200
Message-ID: <20150811134826.GI4520@redhat.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
 <1431624680-20153-20-git-send-email-aarcange@redhat.com>
 <20150811100728.GB4587@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150811100728.GB4587@in.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-api@vger.kernel.org, zhang.zhanghailiang@huawei.com, Pavel Emelyanov <xemul@parallels.com>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, Dave Hansen <dave.hansen@intel.com>, Andres Lagar-Cavilla <andreslc@google.com>, Mel Gorman <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Feiner <pfeiner@google.com>
List-Id: linux-api@vger.kernel.org

Hello Bharata,

On Tue, Aug 11, 2015 at 03:37:29PM +0530, Bharata B Rao wrote:
> May be it is a bit late to bring this up, but I needed the following fix
> to userfault21 branch of your git tree to compile on powerpc.

Not late, just in time. I increased the number of syscalls in earlier
versions, it must have gotten lost during a rejecting rebase, sorry.

I applied it to my tree and it can be applied to -mm and linux-next,
thanks!

The syscall for arm32 are also ready and on their way to the arm tree,
the testsuite worked fine there. ppc also should work fine if you
could confirm it'd be interesting, just beware that I got a typo in
the testcase:

diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index 76071b1..925c3c9 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -70,7 +70,7 @@
 #define __NR_userfaultfd 323
 #elif defined(__i386__)
 #define __NR_userfaultfd 374
-#elif defined(__powewrpc__)
+#elif defined(__powerpc__)
 #define __NR_userfaultfd 364
 #else
 #error "missing __NR_userfaultfd definition"



> ----
> 
> powerpc: Bump up __NR_syscalls to account for __NR_userfaultfd
> 
> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> With userfaultfd syscall, the number of syscalls will be 365 on PowerPC.
> Reflect the same in __NR_syscalls.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  arch/powerpc/include/asm/unistd.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
> index f4f8b66..4a055b6 100644
> --- a/arch/powerpc/include/asm/unistd.h
> +++ b/arch/powerpc/include/asm/unistd.h
> @@ -12,7 +12,7 @@
>  #include <uapi/asm/unistd.h>
>  
>  
> -#define __NR_syscalls		364
> +#define __NR_syscalls		365
>  
>  #define __NR__exit __NR_exit
>  #define NR_syscalls	__NR_syscalls

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
