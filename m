From: Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH 16/32] x86/vdso: Generate vdso{,32}-timens.lds
Date: Wed, 27 Mar 2019 11:00:00 -0700
Message-ID: <20190327175957.GA9309@gmail.com>
References: <20190206001107.16488-1-dima@arista.com>
 <20190206001107.16488-17-dima@arista.com>
 <a2bbe610-7553-0ba6-b58b-1013e034b8f6@rasmusvillemoes.dk>
 <alpine.DEB.2.21.1902081051410.1645@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1902081051410.1645@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Dmitry Safonov <dima@arista.com>, LKML <linux-kernel@vger.kernel.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

While the generic vdso patchset is in development, we decided to think
about what other ways of generating two vdso libraries. In this
patchset, we use a linker script, but it looks too complicated, so we
decided to look at other options. Another obvious approach is the code
patching technique. The main idea was to reduce the amount of
arch-dependent code and Dmitry brought with the idea of three labels.
Let’s look at this pseudo-code:

Int vdso_clock_gettime(clockid_t clk, struct timespec *ts)
{
...
l_call:
               clk_to_ns(clk, ts)
l_return:
               return 0;
               annotate_reachable();
l_out:
               nop();
               return 0;
}

Here we can see three labels. Without patching this code, the function
will apply vdso offsets. But if we copy the code between the last two
labels to the first label, we will get a version which skips vdso
offsets. The patch which implements this idea will be in replies to this
email. It was tested on x86_64 and with gcc as a compiler, but we
suspect that there might be some issues on other architectures or with
other compilers. So we would like to ask the help of the community to
understand what we have to do to be sure that this code works always
correctly.

The second patch implements static_branch for the vdso code.
Here are only a few lines of arch-dependent code:

+static __always_inline bool timens_static_branch(void)
+{
+       asm_volatile_goto("1:\n\t"
+               ".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
+                ".pushsection __retcall_table,  \"aw\"\n\t"
+                "2: .word 1b - 2b, %l[l_yes] - 2b\n\t"
+                ".popsection\n\t"
+                : :  :  : l_yes);
+
+       return false;
+l_yes:
+       return true;
+}

This is a slightly modified version of the arch_static_branch()
function. The timens code in vdso looks like this:

           if (timens_static_branch()) {
                   clk_to_ns(clk, ts);
           }

The version of vdso which is compiled from sources will never execute
clk_to_ns(). And then we can patch the 'no-op' in the straight-line
codepath with a 'jump' instruction to the out-of-line true branch and
get the timens version of the vdso library.

Now we can compare these three versions. Our opinion is that the version
with three labels looks cleaner and if it will work with all compilers
on all architectures, we probably have to choose it. Otherwise, we would
prefer the version with static_branches, because it is simpler than the
version with the linker script.

Thanks,
Andrei

On Fri, Feb 08, 2019 at 10:57:57AM +0100, Thomas Gleixner wrote:
> On Thu, 7 Feb 2019, Rasmus Villemoes wrote:
>
> Cc: + Vincenzo, Will
>
> > On 06/02/2019 01.10, Dmitry Safonov wrote:
> > > As it has been discussed on timens RFC, adding a new conditional branch
> > > `if (inside_time_ns)` on VDSO for all processes is undesirable.
> > > It will add a penalty for everybody as branch predictor may mispredict
> > > the jump. Also there are instruction cache lines wasted on cmp/jmp.
> > >
> > > Those effects of introducing time namespace are very much unwanted
> > > having in mind how much work have been spent on micro-optimisation
> > > vdso code.
> > >
> > > Addressing those problems, there are two versions of VDSO's .so:
> > > for host tasks (without any penalty) and for processes inside of time
> > > namespace with clk_to_ns() that subtracts offsets from host's time.
> > >
> > > Unfortunately, to allow changing VDSO VMA on a running process,
> > > the entry points to VDSO should have the same offsets (addresses).
> > > That's needed as i.e. application that calls setns() may have already
> > > resolved VDSO symbols in GOT/PLT.
> >
> > These (14-19, if I'm reading them right) seems to add quite a lot of
> > complexity and fragility to the build, and other architectures would
> > probably have to add something similar to their vdso builds.
>
> Yes and we really want to avoid that. The VDSO implementations are
> pointlessly different accross the architectures and there is effort on the
> way to consolidate them:
>
>   https://lkml.kernel.org/r/20190115135539.24762-1-vincenzo.frascino@arm.com
>
> I talked to Vincenzo earlier this week and he's working on a new version of
> that. The timens stuff wants to go on top of the consolidation otherwise we
> end up with another set of pointlessly different and differently broken
> VDSO variants.
>
> Thanks,
>
> 	tglx
