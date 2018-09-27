From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH resend] proc: restrict kernel stack dumps to root
Date: Fri, 28 Sep 2018 00:39:16 +0200
Message-ID: <CAG48ez3CSRuY3g+ug+PaM2ivc2n_fJQuP9U9VKv8JLELtBoLbA@mail.gmail.com>
References: <20180927153316.200286-1-jannh@google.com> <20180927152908.f5c9239d527380c582b1bcfa@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927152908.f5c9239d527380c582b1bcfa@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Ken Chen <kenchen@google.com>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Laura Abbott <labbott@redhat.com>, Andy Lutomirski <luto@amacapital.net>, security@kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 28, 2018 at 12:29 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Thu, 27 Sep 2018 17:33:16 +0200 Jann Horn <jannh@google.com> wrote:
>
> > Restrict the ability to inspect kernel stacks of arbitrary tasks to root
> > in order to prevent a local attacker from exploiting racy stack unwinding
> > to leak kernel task stack contents.
> > See the added comment for a longer rationale.
> >
> > There don't seem to be any users of this userspace API that can't
> > gracefully bail out if reading from the file fails. Therefore, I believe
> > that this change is unlikely to break things.
> > In the case that this patch does end up needing a revert, the next-best
> > solution might be to fake a single-entry stack based on wchan.
> >
> > Fixes: 2ec220e27f50 ("proc: add /proc/*/stack")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jann Horn <jannh@google.com>
>
> It's a bit worrisome cc'ing stable on a patch which might need a revert.
>
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -407,6 +407,20 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
> >       unsigned long *entries;
> >       int err;
> >
> > +     /*
> > +      * The ability to racily run the kernel stack unwinder on a running task
> > +      * and then observe the unwinder output is scary; while it is useful for
> > +      * debugging kernel issues, it can also allow an attacker to leak kernel
> > +      * stack contents.
> > +      * Doing this in a manner that is at least safe from races would require
> > +      * some work to ensure that the remote task can not be scheduled; and
> > +      * even then, this would still expose the unwinder as local attack
> > +      * surface.
> > +      * Therefore, this interface is restricted to root.
> > +      */
>
> The /proc file is 0400 so the user can only read owned-by-self stacks,
> yes?  In what way could exposure of one's own kernel stack contents
> lead to plausible attacks?  I guess maybe post-setuid, perhaps?
>
> I do think we're owed considerably more explanation of the present risk
> before considering a somewhat dangerous -stable backport, please.

I sent a bug report to security@. The short version: Currently, you
can use /proc/self/task/*/stack to cause a stack walk on a task you
control while it is running on another CPU. That means that the stack
can change under the stack walker. The stack walker does have guards
against going completely off the rails and into random kernel memory,
but it can interpret random data from your kernel stack as instruction
pointers and stack pointers. This can cause exposure of kernel stack
contents to userspace.
