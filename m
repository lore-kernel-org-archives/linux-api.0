From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 1/8] signal/alpha: Document a conflict with SI_USER for SIGTRAP
Date: Fri, 14 Jul 2017 05:59:06 -0500
Message-ID: <87fudz5lol.fsf@xmission.com>
References: <87efu22set.fsf@xmission.com>
        <20170630123906.8865-1-ebiederm@xmission.com>
        <20170702141320.GA32254@ls3530.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170702141320.GA32254-PwtjyNU/e7vkVFMGpb/cPg@public.gmane.org> (Helge Deller's message
        of "Sun, 2 Jul 2017 16:13:20 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Willy Tarreau <w@1wt.eu>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, Ivan Kokshaysky <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org> writes:

> * Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>:
>> Setting si_code to __SI_FAULT results in a userspace seeing
>> an si_code of 0.  This is the same si_code as SI_USER.  Posix
>> and common sense requires that SI_USER not be a signal specific
>> si_code.  As such this use of 0 for the si_code is a pretty
>> horribly broken ABI.
>> 
>> Given that alpha is on it's last legs I don't know that it is worth
>> fixing this, but it is worth documenting what is going on so that
>> no one decides to copy this bad decision.
>
> The ABI was already broken, so IMHO I think it's better to somehow "fix"
> it instead. Agreed, alpha and some other architectures are already aged,
> but nevertheless most of them build in debian-ports.  Below is a
> suggested fix which reuses/misuses other existing trap codes instead.

The conflict with SI_USER is real.  I don't know that we have any actual
applications that are suffering.

I simply don't have the architecture specific references handy to know
in which cases the oddities will happen let alone test them.  Plus at
least for ia64 and alpha those architectures don't appear to be
receiving updates for new syscalls, and no new hardware is being built
so I don't know how much longer they will last.

That is building for alpha gives:
>   CALL    /home/eric/projects/linux/linux-exit-cleanups/scripts/checksyscalls.sh
> <stdin>:1239:2: warning: #warning syscall seccomp not implemented [-Wcpp]
> <stdin>:1248:2: warning: #warning syscall bpf not implemented [-Wcpp]
> <stdin>:1299:2: warning: #warning syscall userfaultfd not implemented [-Wcpp]
> <stdin>:1302:2: warning: #warning syscall membarrier not implemented [-Wcpp]
> <stdin>:1305:2: warning: #warning syscall mlock2 not implemented [-Wcpp]
> <stdin>:1308:2: warning: #warning syscall copy_file_range not implemented [-Wcpp]
> <stdin>:1311:2: warning: #warning syscall preadv2 not implemented [-Wcpp]
> <stdin>:1314:2: warning: #warning syscall pwritev2 not implemented [-Wcpp]
> <stdin>:1317:2: warning: #warning syscall pkey_mprotect not implemented [-Wcpp]
> <stdin>:1320:2: warning: #warning syscall pkey_alloc not implemented [-Wcpp]
> <stdin>:1323:2: warning: #warning syscall pkey_free not implemented [-Wcpp]
> <stdin>:1326:2: warning: #warning syscall statx not implemented [-Wcpp]

But a real fix like you have shown if you can get it approved by the
alpha architecture maintainers I am more than happy to see, and would
very much prefer.

You certainly noticed that the middle case was SIGFPE when I missed
that.

Unfortunately I don't currently have the competence to judge the
effects of your patch.

Eric

> Helge
>
> Signed-off-by: Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>
>
> diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
> index 65bb102..2ed37dd 100644
> --- a/arch/alpha/kernel/traps.c
> +++ b/arch/alpha/kernel/traps.c
> @@ -278,7 +278,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
>  	      case 1: /* bugcheck */
>  		info.si_signo = SIGTRAP;
>  		info.si_errno = 0;
> -		info.si_code = __SI_FAULT;
> +		info.si_code = TRAP_HWBKPT;
>  		info.si_addr = (void __user *) regs->pc;
>  		info.si_trapno = 0;
>  		send_sig_info(SIGTRAP, &info, current);
> @@ -318,7 +318,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
>  			break;
>  		case GEN_ROPRAND:
>  			signo = SIGFPE;
> -			code = __SI_FAULT;
> +			code = FPE_FLTSUB;
>  			break;
>  
>  		case GEN_DECOVF:
> @@ -340,7 +340,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
>  		case GEN_SUBRNG7:
>  		default:
>  			signo = SIGTRAP;
> -			code = __SI_FAULT;
> +			code = TRAP_HWBKPT;
>  			break;
>  		}
>  
