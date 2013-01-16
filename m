From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] signalfd: add ability to return siginfo in a raw
 format (v2)
Date: Wed, 16 Jan 2013 12:35:02 -0800
Message-ID: <20130116123502.70af6b85.akpm@linux-foundation.org>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
	<1358182435-19245-3-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1358182435-19245-3-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, 14 Jan 2013 20:53:54 +0400
Andrey Vagin <avagin@openvz.org> wrote:

> signalfd should be called with the flag SFD_RAW for that.
> 
> signalfd_siginfo is not full for siginfo with a negative si_code.
> copy_siginfo_to_user() is copied a full siginfo to user-space, if
> si_code is negative.  signalfd_copyinfo() doesn't do that and can't be
> expanded, because it has not compatible format with siginfo_t.
> 
> Another problem is that a constant __SI_* is removed from si_code.
> It's not a problem for usual applications, because they expect
> a defined type of siginfo (internal logic).
> When we want to dump pending signals, we can't predict a type of
> siginfo, so we should get it from kernel.
> 
> The main idea of the raw format is that it should be enough for
> restoring exactly the same siginfo for the current process.
> 
> This functionality is required for checkpointing pending signals.
> 
> ...
>
> --- a/fs/signalfd.c
> +++ b/fs/signalfd.c
> @@ -30,6 +30,7 @@
>  #include <linux/signalfd.h>
>  #include <linux/syscalls.h>
>  #include <linux/proc_fs.h>
> +#include <linux/compat.h>
>  
>  void signalfd_cleanup(struct sighand_struct *sighand)
>  {
> @@ -74,6 +75,38 @@ static unsigned int signalfd_poll(struct file *file, poll_table *wait)
>  }
>  
>  /*
> + * Copy a whole siginfo into users spaces.

"userspace"

> + * The main idea of this format is that it should be enough
> + * for restoring siginfo back into the kernel.
> + */
> +static int signalfd_copy_raw_info(struct signalfd_siginfo __user *siginfo,
> +					siginfo_t *kinfo)
> +{
> +	siginfo_t *uinfo = (siginfo_t *) siginfo;

Should be

	siginfo_t __user *uinfo = (siginfo_t __user *)siginfo;

> +	int err;
> +
> +	BUILD_BUG_ON(sizeof(siginfo_t) != sizeof(struct signalfd_siginfo));
> +
> +	err = __clear_user(uinfo, sizeof(*uinfo));
>
> +#ifdef CONFIG_COMPAT
> +	if (unlikely(is_compat_task())) {
> +		compat_siginfo_t *compat_uinfo = (compat_siginfo_t *) siginfo;
> +
> +		err |= copy_siginfo_to_user32(compat_uinfo, kinfo);
> +		err |= put_user(kinfo->si_code, &compat_uinfo->si_code);
> +
> +		return err ? -EFAULT: sizeof(*compat_uinfo);
> +	}
> +#endif
> +
> +	err |= copy_siginfo_to_user(uinfo, kinfo);
> +	err |= put_user(kinfo->si_code, &uinfo->si_code);
> +
> +	return err ? -EFAULT: sizeof(*uinfo);
> +}
> +
> +/*
>   * Copied from copy_siginfo_to_user() in kernel/signal.c
>   */
>  static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
>
> ...
>
> --- a/include/uapi/linux/signalfd.h
> +++ b/include/uapi/linux/signalfd.h
> @@ -15,6 +15,7 @@
>  /* Flags for signalfd4.  */
>  #define SFD_CLOEXEC O_CLOEXEC
>  #define SFD_NONBLOCK O_NONBLOCK
> +#define SFD_RAW O_DIRECT
>  
>  struct signalfd_siginfo {
>  	__u32 ssi_signo;

As SFD_RAW is being added to the kernel API we should document it. 
Please keep Michael cc'ed and work with him on getting the manpages
updated.

I usually ask that checkpoint-restart specific code be wrapped in
#ifdef CONFIG_CHECKPOINT_RESTORE, mainly so we can identify it all
if/when your project fails and we decide to remove the feature ;) But
as this patch extends the user API I think it simplifies life if we
make the extension permanent.  Perhaps this is a bad idea, as
permanently adding this extension to the API makes it harder to ever
remove the c/r feature.  


Proposed fixups.  Please review and test this and check that sparse is
happy with it.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix

fix __user annotations, tidy comments and code layout

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/signalfd.c~signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix fs/signalfd.c
--- a/fs/signalfd.c~signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix
+++ a/fs/signalfd.c
@@ -75,14 +75,14 @@ static unsigned int signalfd_poll(struct
 }
 
 /*
- * Copy a whole siginfo into users spaces.
+ * Copy a whole siginfo into userspace.
  * The main idea of this format is that it should be enough
  * for restoring siginfo back into the kernel.
  */
 static int signalfd_copy_raw_info(struct signalfd_siginfo __user *siginfo,
 					siginfo_t *kinfo)
 {
-	siginfo_t *uinfo = (siginfo_t *) siginfo;
+	siginfo_t __user *uinfo = (siginfo_t __user *)siginfo;
 	int err;
 
 	BUILD_BUG_ON(sizeof(siginfo_t) != sizeof(struct signalfd_siginfo));
@@ -91,19 +91,20 @@ static int signalfd_copy_raw_info(struct
 
 #ifdef CONFIG_COMPAT
 	if (unlikely(is_compat_task())) {
-		compat_siginfo_t *compat_uinfo = (compat_siginfo_t *) siginfo;
+		compat_siginfo_t __user *compat_uinfo;
 
+		compat_uinfo = (compat_siginfo_t __user *)siginfo;
 		err |= copy_siginfo_to_user32(compat_uinfo, kinfo);
 		err |= put_user(kinfo->si_code, &compat_uinfo->si_code);
 
-		return err ? -EFAULT: sizeof(*compat_uinfo);
+		return err ? -EFAULT : sizeof(*compat_uinfo);
 	}
 #endif
 
 	err |= copy_siginfo_to_user(uinfo, kinfo);
 	err |= put_user(kinfo->si_code, &uinfo->si_code);
 
-	return err ? -EFAULT: sizeof(*uinfo);
+	return err ? -EFAULT : sizeof(*uinfo);
 }
 
 /*
_
