From: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 8/8] signal: Remove kernel interal si_code magic
Date: Wed, 12 Jul 2017 15:36:04 -0700
Message-ID: <20170712223557.GA21885@outlook.office365.com>
References: <87efu22set.fsf@xmission.com>
	<20170630123906.8865-8-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170630123906.8865-8-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Willy Tarreau <w@1wt.eu>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 30, 2017 at 07:39:06AM -0500, Eric W. Biederman wrote:
> struct siginfo is a union and the kernel since 2.4 has been hiding a union
> tag in the high 16bits of si_code using the values:
> __SI_KILL
> __SI_TIMER
> __SI_POLL
> __SI_FAULT
> __SI_CHLD
> __SI_RT
> __SI_MESGQ
> __SI_SYS
> 
> While this looks plausible on the surface, in practice this situation has
> not worked well.
> 
> - Injected positive signals are not copied to user space properly
>   unless they have these magic high bits set.
> 
> - Injected positive signals are not reported properly by signalfd
>   unless they have these magic high bits set.
> 
> - These kernel internal values leaked to userspace via ptrace_peek_siginfo
> 
> - It was possible to inject these kernel internal values and cause the
>   the kernel to misbehave.
> 
> - Kernel developers got confused and expected these kernel internal values
>   in userspace in kernel self tests.
> 
> - Kernel developers got confused and set si_code to __SI_FAULT which
>   is SI_USER in userspace which causes userspace to think an ordinary user
>   sent the signal and that it was not kernel generated.
> 
> - The values make it impossible to reorganize the code to transform
>   siginfo_copy_to_user into a plain copy_to_user.  As si_code must
>   be massaged before being passed to userspace.
> 
> So remove these kernel internal si codes and make the kernel code simpler
> and more maintainable.
> 
> To replace these kernel internal magic si_codes introduce the helper
> function siginfo_layout, that takes a signal number and an si_code and
> computes which union member of siginfo is being used.  Have
> siginfo_layout return an enumeration so that gcc will have enough
> information to warn if a switch statement does not handle all of union
> members.
> 
> A couple of architectures have a messed up ABI that defines signal
> specific duplications of SI_USER which causes more special cases in
> siginfo_layout than I would like.  The good news is only problem
> architectures pay the cost.
> 
> Update all of the code that used the previous magic __SI_ values to
> use the new SIL_ values and to call siginfo_layout to get those
> values.  Escept where not all of the cases are handled remove the
> defaults in the switch statements so that if a new case is missed in
> the future the lack will show up at compile time.
> 
> Modify the code that copies siginfo si_code to userspace to just copy
> the value and not cast si_code to a short first.  The high bits are no
> longer used to hold a magic union member.
> 
> Fixup the siginfo header files to stop including the __SI_ values in
> their constants and for the headers that were missing it to properly
> update the number of si_codes for each signal type.
> 
> The fixes to copy_siginfo_from_user32 implementations has the
> interesting property that several of them perviously should never have
> worked as the __SI_ values they depended up where kernel internal.
> With that dependency gone those implementations should work much
> better.
> 
> The idea of not passing the __SI_ values out to userspace and then
> not reinserting them has been tested with criu and criu worked without
> changes.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> ---
>  arch/alpha/include/uapi/asm/siginfo.h    |   2 +-
>  arch/arm64/kernel/signal32.c             |  23 +++----
>  arch/blackfin/include/uapi/asm/siginfo.h |  30 +++++----
>  arch/frv/include/uapi/asm/siginfo.h      |   2 +-
>  arch/ia64/include/uapi/asm/siginfo.h     |  20 +++---
>  arch/ia64/kernel/signal.c                |  17 +++---
>  arch/mips/include/uapi/asm/siginfo.h     |   6 +-
>  arch/mips/kernel/signal32.c              |  19 +++---
>  arch/parisc/kernel/signal32.c            |  31 +++++-----
>  arch/powerpc/kernel/signal_32.c          |  20 +++---
>  arch/s390/kernel/compat_signal.c         |  32 +++++-----
>  arch/sparc/include/uapi/asm/siginfo.h    |   4 +-
>  arch/sparc/kernel/signal32.c             |  16 ++---
>  arch/tile/include/uapi/asm/siginfo.h     |   4 +-
>  arch/tile/kernel/compat_signal.c         |  18 +++---
>  arch/tile/kernel/traps.c                 |   1 -
>  arch/x86/kernel/signal_compat.c          |  21 +++----
>  fs/fcntl.c                               |   2 +-
>  fs/signalfd.c                            |  22 +++----
>  include/asm-generic/siginfo.h            |  22 ++++---
>  include/uapi/asm-generic/siginfo.h       | 102 ++++++++++++++-----------------
>  kernel/compat.c                          |   2 -
>  kernel/exit.c                            |   6 +-
>  kernel/ptrace.c                          |   6 +-
>  kernel/signal.c                          |  72 ++++++++++++++++------
>  25 files changed, 254 insertions(+), 246 deletions(-)
> 
<...>
> diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
> index 54804866f238..4433d1dc28e6 100644
> --- a/arch/tile/kernel/traps.c
> +++ b/arch/tile/kernel/traps.c
> @@ -188,7 +188,6 @@ static int special_ill(tile_bundle_bits bundle, int *sigp, int *codep)
>  
>  	/* Make it the requested signal. */
>  	*sigp = sig;
> -	*codep = code | __SI_FAULT;

Are you sure that we don't need to set codep here?

>  	return 1;
>  }
>  
