From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Fri, 9 Mar 2018 01:58:30 +0000
Message-ID: <20180309015830.GO4449@wotan.suse.de>
References: <20180306013457.1955486-1-ast@kernel.org>
 <20180308012353.GO14069@wotan.suse.de>
 <d83869b4-260e-179d-d469-83b8d8068399@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d83869b4-260e-179d-d469-83b8d8068399@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, gregkh@linuxfoundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, Jessica Yu <jeyu@kernel.org>, Kees Cook <keescook@chromium.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Jiri Kosina <jikos@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 08, 2018 at 03:07:01PM -0800, Alexei Starovoitov wrote:
> On 3/7/18 5:23 PM, Luis R. Rodriguez wrote:
> > 
> > request_module() has its own world though too. How often in your proof of
> > concept is request_module() called? How many times do you envision it being
> > called?
> 
> once.

What about other users later in the kernel?

> > > +static int run_umh(struct file *file)
> > > +{
> > > +	struct subprocess_info *sub_info = call_usermodehelper_setup_file(file);
> > > +
> > > +	if (!sub_info)
> > > +		return -ENOMEM;
> > > +	return call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
> > > +}
> > 
> > run_umh() calls the program and waits. Note that while we are running a UMH we
> > can't suspend. What if they take forever, who is hosing them down with an
> > equivalent:
> > 
> > 	schedule();
> > 	try_to_freeze();
> > 
> > Say they are buggy and never return, will they stall suspend, have you tried?
> > 
> > call_usermodehelper_exec() uses helper_lock() which in turn is used for
> > umh's accounting for number of running umh's. One of the sad obscure uses
> > for this is to deal with suspend/resume. Refer to __usermodehelper* calls
> > on kernel/power/process.c
> > 
> > Note how you use UMH_WAIT_EXEC too, so this is all synchronous.
> 
> looks like you misread this code
>
> #define UMH_NO_WAIT     0       /* don't wait at all */
> #define UMH_WAIT_EXEC   1       /* wait for the exec, but not the process */
> #define UMH_WAIT_PROC   2       /* wait for the process to complete */
> #define UMH_KILLABLE    4       /* wait for EXEC/PROC killable */

I certainly did get the incorrect impression this was a sync op, sorry
about that. In that case its odd to see a request_module() call, when
what is really meant is more of a request_module_nowait(), its also
UMH_NO_WAIT on the modprobe call itself as well.

In fact I think I'd much prefer at the very least to see a different wrapper
for this, even if its using the same bolts and nuts underneath for userspace
processes compiled on the kernel. The sanity checks in place for
request_module() may change later and this use case seems rather simple and
limited. Keeping tabs on this type of users seems desirable. At the *very
least*

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 40c89ad4bea6..7530e00da03b 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -37,11 +37,13 @@ extern __printf(2, 3)
 int __request_module(bool wait, const char *name, ...);
 #define request_module(mod...) __request_module(true, mod)
 #define request_module_nowait(mod...) __request_module(false, mod)
+#define request_umh_proc(mod...) __request_module(false, mod)
 #define try_then_request_module(x, mod...) \
 	((x) ?: (__request_module(true, mod), (x)))
 #else
 static inline int request_module(const char *name, ...) { return -ENOSYS; }
 static inline int request_module_nowait(const char *name, ...) { return -ENOSYS; }
+static inline int request_umh_proc(const char *name, ...) { return -ENOSYS; }
 #define try_then_request_module(x, mod...) (x)
 #endif

Modulo, kernel/umh.c is already its own thing, so pick a name that helps
identify these things clearly.

> and the rest of your concerns with suspend/resume are not applicable any
> more.

Agreed, except it does still mean these userspace processes are limited to
execution only the kernel is up, and not going to suspend, but I think that's
a proper sanity check by the umh API.

> bpftiler.ko is started once and runs non-stop from there on.
> Unless it crashes, but it's a different discussion.

Sure.

  Luis
