From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Sun, 2 Dec 2018 09:52:29 +0100
Message-ID: <20181202085227.6krrxtxermxd7pcq@brauner.io>
References: <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io>
 <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com>
 <20181129195551.woe2bl3z3yaysqb6@brauner.io>
 <6E21165F-2C76-4877-ABD9-0C86D55FD6AA@amacapital.net>
 <CAK8P3a2i9DFaS9-3A9V_pKwFfwVR0bDqgLosmivge3Cx2VyiuQ@mail.gmail.com>
 <87y39b2lm2.fsf@xmission.com>
 <20181130065606.kmilbbq46oeycjp5@brauner.io>
 <CAK8P3a0kqPii5TwFAo_JHLX=o_FDMFVKXxgzzbDjLFZ7OQ5QCQ@mail.gmail.com>
 <87y399s3sc.fsf@xmission.com>
 <87tvjxp8pc.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87tvjxp8pc.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Sat, Dec 01, 2018 at 09:28:47AM -0600, Eric W. Biederman wrote:
> 
> It just occurs to me that the simple way to implement
> procfd_sigqueueinfo info is like:
> 
> int copy_siginfo_from_user_any(kernel_siginfo_t *info, siginfo_t *uinfo)
> {
> #ifdef CONFIG_COMPAT
> 	if (in_compat_syscall)
> 		return copy_siginfo_from_user32(info, uinfo);

Right, though that would require a cast afaict.

static int __copy_siginfo_from_user_generic(int signo, kernel_siginfo_t *kinfo,
                                           siginfo_t *info)
{
#ifdef CONFIG_COMPAT
       if (in_compat_syscall())
               return __copy_siginfo_from_user32(
                       signo, kinfo, (struct compat_siginfo __user *)info);
#endif
       return __copy_siginfo_from_user(signo, kinfo, info);
}

It seems that a cast to (compat_siginfo __user *) should be safe in this
context? I've at least seen similar things done for __sys_sendmsg().

> #endif
> 	return copy_siginfo_from_user(info, uinfo);                        
> }
> 
> long procfd_sigqueueinfo(int fd, siginfo_t *uinfo)

**bikeshedding**
Not a fan of that name. I'm going to go with procfd_send_signal().
sigqueue gives non-native speakers a lot of room for spelling errors and
it always seemed opaque to me what this function is doing without
consulting the manpage. :)

> {
> 	kernel_siginfo info;
> 
>         if (copy_siginfo_from_user_any(&info, uinfo))
>         	return -EFAULT;
> 	...;                
> }
> 
> It looks like there is already a place in ptrace.c that already
> hand rolls copy_siginfo_from_user_any.
> 
> So while I would love to figure out the subset of siginfo_t tha we can
> just pass through, as I think that would make a better more forward
> compatible copy_siginfo_from_user32.  I think for this use case we just
> add the in_compat_syscall test and then we just need to ensure this new
> system call is placed in the proper places in the syscall table.
> 
> Because we will need 3 call sights: x86_64, x32 and ia32.  As the layout
> changes between those three subarchitecuters.
> 
> Eric
> 
