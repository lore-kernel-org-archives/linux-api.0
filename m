From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/1] arm64: Fix /proc/cpuinfo
Date: Fri, 24 Oct 2014 16:42:18 +0100
Message-ID: <20141024154217.GT27405@n2100.arm.linux.org.uk>
References: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
 <20141024141936.GS27405@n2100.arm.linux.org.uk>
 <20141024142435.GK24265@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141024142435.GK24265@leverpostej>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "cross-distro-cunTk1MwBs8s++Sfvej+rw@public.gmane.org" <cross-distro-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Serban Constantinescu <Serban.Constantinescu-5wv7dgnIgG8@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "ijc-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 24, 2014 at 03:24:35PM +0100, Mark Rutland wrote:
> On Fri, Oct 24, 2014 at 03:19:36PM +0100, Russell King - ARM Linux wrote:
> > It's unfortunate that people have decided that parsing the ELF HWCAPs
> > from /proc/cpuinfo is an acceptable way to go, rather than using the
> > binary information passed, but procfs is a much more visible source
> > of information than some binary interface which you need to read man
> > pages to find.
> > 
> > That's the danger of publishing information in either procfs or sysfs.
> > Once published, it becomes part of the userspace API, and it can become
> > hard to remove it.  This is why we should /always/ think very carefully
> > about what we expose through these filesystems.
> 
> Yes. We made a mistake here with the arm64 format. Hopefully there's a
> way by which we can keep applications happy.
> 
> For future architectures, it's probably worth putting stronger
> guidelines in place to prevent precisely the issues we've hit here.

You know, I saw something like this happening years ago.

I guess that if people had listened to me when ARM64 was in the process
of being released about my concerns about the ARM64 code diverging from
the ARM32 code, we wouldn't be having this problem right now, because
we would have been aware of the API differences much earlier on.

As ARM64 wants to be compatible with ARM32 (in that it wants to be able
to run ARM32 applications), ARM64 *has* to offer a compatible user API
for everything that is a user API.

That means you have to generate an ARM32 compatible /proc/cpuinfo, ARM32
compatible hwcap information, ARM32 compatible signal structures, ARM32
compatible everything else.  Which means you basically need to have a
copy of the ARM32 core code in ARM64, even if you want a different
native ARM64 user API.

This is _exactly_ the reason why architectures like X86 decided it was
silly having separated 32 and 64-bit, and why they went through a
process of merging the two together.  A lot of the code was identical,
and a lot of the 32-bit specific code was needed for 64-bit to provide
the 32-bit API.

Right now, you're finding out this the hard way, and hitting these API
problems in the process, and going "oh fsck" when you hit them - quite
simply because you've backed yourselves into a corner over this.  You
have established a different ARM64 API because you didn't want the ARM32
legacy, but then you've found that you /do/ need the ARM32 legacy.  Now
you're in the position of having to change the ARM64 API, possibly
breaking ARM64 applications in the process.

Welcome to the problems of being separate. :)

For example, some of the differences between ARM64 and ARM32 are really
trivial, and would've been nice to have them reflected into the ARM32
code base.  Here's an example from __die():

-       printk(KERN_EMERG "Internal error: %s: %x [#%d]" S_PREEMPT S_SMP
-              S_ISA "\n", str, err, ++die_counter);
+       pr_emerg("Internal error: %s: %x [#%d]" S_PREEMPT S_SMP "\n",
+                str, err, ++die_counter);

        /* trap and error numbers are mostly meaningless on ARM */
-       ret = notify_die(DIE_OOPS, str, regs, err, tsk->thread.trap_no, SIGSEGV);
+       ret = notify_die(DIE_OOPS, str, regs, err, 0, SIGSEGV);
        if (ret == NOTIFY_STOP)
-               return 1;
+               return ret;

        print_modules();
        __show_regs(regs);
-       printk(KERN_EMERG "Process %.*s (pid: %d, stack limit = 0x%p)\n",
-               TASK_COMM_LEN, tsk->comm, task_pid_nr(tsk), end_of_stack(tsk));
+       pr_emerg("Process %.*s (pid: %d, stack limit = 0x%p)\n",
+                TASK_COMM_LEN, tsk->comm, task_pid_nr(tsk), thread + 1);

        if (!user_mode(regs) || in_interrupt()) {
-               dump_mem(KERN_EMERG, "Stack: ", regs->ARM_sp,
+               dump_mem(KERN_EMERG, "Stack: ", regs->sp,
                         THREAD_SIZE + (unsigned long)task_stack_page(tsk));
                dump_backtrace(regs, tsk);
                dump_instr(KERN_EMERG, regs);
        }

-       return 0;
+       return ret;
 }

Having the printk(KERN_EMERG -> pr_emerg( would be nice.  What's also
revealed is that you've missed out on the end_of_stack() cleanup which
Rabin Vincent submitted in 2012.

I'm sure that there's plenty more instances of stuff which should be
aligned between the two copies of what is essentially the same core
code.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
