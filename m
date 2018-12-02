From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Sun, 2 Dec 2018 11:03:06 +0100
Message-ID: <20181202100304.labt63mzrlr5utdl@brauner.io>
References: <20181120105124.14733-1-christian@brauner.io>
 <87in0g5aqo.fsf@oldenburg.str.redhat.com>
 <746B7C49-CC7B-4040-A7EF-82491796D360@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <746B7C49-CC7B-4040-A7EF-82491796D360@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Sat, Dec 01, 2018 at 12:52:24PM +1300, Christian Brauner wrote:
> On November 30, 2018 1:28:15 AM GMT+13:00, Florian Weimer <fweimer@redhat.com> wrote:
> >Disclaimer: I'm looking at this patch because Christian requested it.
> >I'm not a kernel developer.
> 
> Given all your expertise this really doesn't matter. :)
> You're the one having to deal with this
> in glibc after all.
> Thanks for doing this and sorry for the late reply.
> I missed that mail.
> 
> >
> >* Christian Brauner:
> >
> >> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl
> >b/arch/x86/entry/syscalls/syscall_32.tbl
> >> index 3cf7b533b3d1..3f27ffd8ae87 100644
> >> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> >> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> >> @@ -398,3 +398,4 @@
> >>  384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
> >> 
> >385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevents
> >>  386	i386	rseq			sys_rseq			__ia32_sys_rseq
> >>
> >+387	i386	procfd_signal		sys_procfd_signal		__ia32_compat_sys_procfd_signal
> >> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl
> >b/arch/x86/entry/syscalls/syscall_64.tbl
> >> index f0b1709a5ffb..8a30cde82450 100644
> >> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> >> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> >> @@ -343,6 +343,7 @@
> >>  332	common	statx			__x64_sys_statx
> >>  333	common	io_pgetevents		__x64_sys_io_pgetevents
> >>  334	common	rseq			__x64_sys_rseq
> >> +335	64	procfd_signal		__x64_sys_procfd_signal
> >>  
> >>  #
> >>  # x32-specific system call numbers start at 512 to avoid cache
> >impact
> >> @@ -386,3 +387,4 @@
> >>  545	x32	execveat		__x32_compat_sys_execveat/ptregs
> >>  546	x32	preadv2			__x32_compat_sys_preadv64v2
> >>  547	x32	pwritev2		__x32_compat_sys_pwritev64v2
> >> +548	x32	procfd_signal		__x32_compat_sys_procfd_signal
> >
> >Is there a reason why these numbers have to be different?
> >
> >(See the recent discussion with Andy Lutomirski.)
> >
> >> +static int do_procfd_signal(int fd, int sig, kernel_siginfo_t
> >*kinfo, int flags,
> >> +			    bool had_siginfo)
> >> +{
> >> +	int ret;
> >> +	struct fd f;
> >> +	struct pid *pid;
> >> +
> >> +	/* Enforce flags be set to 0 until we add an extension. */
> >> +	if (flags)
> >> +		return -EINVAL;
> >> +
> >> +	f = fdget_raw(fd);
> >> +	if (!f.file)
> >> +		return -EBADF;
> >> +
> >> +	/* Is this a process file descriptor? */
> >> +	ret = -EINVAL;
> >> +	if (!proc_is_tgid_procfd(f.file))
> >> +		goto err;
> >[…]
> >> +	ret = kill_pid_info(sig, kinfo, pid);
> >
> >I would like to see some comment here what happens to zombie processes.
> 
> You'd get ESRCH.
> I'm not sure if that has always been the case.
> Eric recently did some excellent refactoring of the signal code.
> Iirc, part of that involved not delivering signals to zombies.
> That's at least how I remember it.
> I don't have access to source code though atm.

Ok, I finally have access to source code again. Scratch what I said above!
I looked at the code and tested it. If the process has exited but not
yet waited upon aka is a zombie procfd_send_signal() will return 0. This
is identical to kill(2) behavior. It should've been sort-of obvious
since when a process is in zombie state /proc/<pid> will still be around
which means that struct pid must still be around.

> 
> >
> >> +/**
> >> + *  sys_procfd_signal - send a signal to a process through a process
> >file
> >> + *                      descriptor
> >> + *  @fd: the file descriptor of the process
> >> + *  @sig: signal to be sent
> >> + *  @info: the signal info
> >> + *  @flags: future flags to be passed
> >> + */
> >> +SYSCALL_DEFINE4(procfd_signal, int, fd, int, sig, siginfo_t __user
> >*, info,
> >> +		int, flags)
> >
> >Sorry, I'm quite unhappy with the name.  “signal” is for signal handler
> >management.  procfd_sendsignal, procfd_sigqueueinfo or something like
> >that would be fine.  Even procfd_kill would be better IMHO.
> 
> Ok. I only have strong opinions to procfd_kill().
> Mainly because the new syscall takes
> the job of multiple other syscalls
> so kill gives the wrong impression.
> I'll come up with a better name in the next iteration.
> 
> >
> >Looking at the rt_tgsigqueueinfo interface, is there a way to implement
> >the “tg” part with the current procfd_signal interface?  Would you use
> >openat to retrieve the Tgid: line from "status"?
> 
> Yes, the tg part can be implemented.
> As I pointed out in another mail my
> I is to make this work by using file
> descriptors for /proc/<pid>/task/<tid>.
> I don't want this in the initial patchset though.
> I prefer to slowly add those features
> once we have gotten the basic functionality
> in.
> 
> 
> >
> >Thanks,
> >Florian
> 
