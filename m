From: Yury Norov <ynorov-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] ptrace: Add compat PTRACE_{G,S}ETSIGMASK handlers
Date: Sat, 14 Oct 2017 00:07:49 +0300
Message-ID: <20171013210749.5u7drexvgggtgh4c@yury-thinkpad>
References: <20170629162637.10676-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170629162637.10676-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Zhou Chengming <zhouchengming1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi James, all,

(add linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org as it is user-visible,
Catalin Marinas and Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>)

On Thu, Jun 29, 2017 at 05:26:37PM +0100, James Morse wrote:
> compat_ptrace_request() lacks handlers for PTRACE_{G,S}ETSIGMASK,
> instead using those in ptrace_request(). The compat variant should
> read a compat_sigset_t from userspace instead of ptrace_request()s
> sigset_t.
> 
> While compat_sigset_t is the same size as sigset_t, it is defined as
> 2xu32, instead of a single u64. On a big-endian CPU this means that
> compat_sigset_t is passed to user-space using middle-endianness,
> where the least-significant u32 is written most significant byte
> first.
> 
> If ptrace_request()s code is used userspace will read the most
> significant u32 where it expected the least significant.
> 
> Instead of duplicating ptrace_request()s code as a special case in
> the arch code, handle it here.
> 
> CC: Yury Norov <ynorov-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
> CC: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Reported-by: Zhou Chengming <zhouchengming1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> Fixes: 29000caecbe87 ("ptrace: add ability to get/set signal-blocked mask")
> ---
> LTP test case here:
> https://lists.linux.it/pipermail/ltp/2017-June/004932.html

This patch relies on sigset_{to,from}_compat() which was proposed to
remove from the kernel recently. The change is in linux-next, and it
breaks the build of the kenel with this patch. Below the updated
version.

I'd like to ask here again, do we need this change? The patch is
correct, but it changes the ptrace API for compat big-endian
architectures. It normally should stop us from pulling it, but there's
seemingly no users of the API in the wild, and so it will
break nothing.

The problem was originally reported by Zhou Chengming for BE arm64/ilp32.
I would like to see arm64/ilp32 working correct in this case, and
developers of other new architectures probably would so.

Regarding arm64/ilp32, we have agreed ABI, and 4.12 and 4.13 kernels
have this change:
https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=staging/ilp32-4.12
https://github.com/norov/linux/tree/ilp32-4.13

So I see 3 ways to proceed with this:
1. Drop the patch and remove it from arm64/ilp32;
2. Apply the patch as is;
3. Introduce new config option like ARCH_PTRACE_COMPAT_BE_SWAP_SIGMASK,
   make it enabled by default and disable explicitly for existing
   compat BE architectures.

I would choose 2 or 3 depending on what maintainers of existing
architectures think.

Yury

Signed-off-by: Yury Norov <ynorov-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
---
 kernel/ptrace.c | 52 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 84b1367935e4..1af47a33768e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -880,6 +880,22 @@ static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
 EXPORT_SYMBOL_GPL(task_user_regset_view);
 #endif
 
+static int ptrace_setsigmask(struct task_struct *child, sigset_t *new_set)
+{
+	sigdelsetmask(new_set, sigmask(SIGKILL)|sigmask(SIGSTOP));
+
+	/*
+	 * Every thread does recalc_sigpending() after resume, so
+	 * retarget_shared_pending() and recalc_sigpending() are not
+	 * called here.
+	 */
+	spin_lock_irq(&child->sighand->siglock);
+	child->blocked = *new_set;
+	spin_unlock_irq(&child->sighand->siglock);
+
+	return 0;
+}
+
 int ptrace_request(struct task_struct *child, long request,
 		   unsigned long addr, unsigned long data)
 {
@@ -951,18 +967,7 @@ int ptrace_request(struct task_struct *child, long request,
 			break;
 		}
 
-		sigdelsetmask(&new_set, sigmask(SIGKILL)|sigmask(SIGSTOP));
-
-		/*
-		 * Every thread does recalc_sigpending() after resume, so
-		 * retarget_shared_pending() and recalc_sigpending() are not
-		 * called here.
-		 */
-		spin_lock_irq(&child->sighand->siglock);
-		child->blocked = new_set;
-		spin_unlock_irq(&child->sighand->siglock);
-
-		ret = 0;
+		ret = ptrace_setsigmask(child, &new_set);
 		break;
 	}
 
@@ -1192,6 +1197,7 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 {
 	compat_ulong_t __user *datap = compat_ptr(data);
 	compat_ulong_t word;
+	sigset_t new_set;
 	siginfo_t siginfo;
 	int ret;
 
@@ -1233,6 +1239,28 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 		else
 			ret = ptrace_setsiginfo(child, &siginfo);
 		break;
+	case PTRACE_GETSIGMASK:
+		if (addr != sizeof(compat_sigset_t))
+			return -EINVAL;
+
+		ret = put_compat_sigset((compat_sigset_t __user *) datap,
+				&child->blocked, sizeof(compat_sigset_t));
+		if (ret)
+			return ret;
+
+		ret = 0;
+		break;
+	case PTRACE_SETSIGMASK:
+		if (addr != sizeof(compat_sigset_t))
+			return -EINVAL;
+
+		ret = get_compat_sigset(&new_set,
+				(compat_sigset_t __user *) datap);
+		if (ret)
+			break;
+
+		ret = ptrace_setsigmask(child, &new_set);
+		break;
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	case PTRACE_GETREGSET:
 	case PTRACE_SETREGSET:
-- 
2.11.0
