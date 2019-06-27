From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Thu, 27 Jun 2019 16:42:18 -0700
Message-ID: <CALCETrUp3Tj062wG-noNdsY-sU9gsob_kVK=W_DxWciMpZFvyA@mail.gmail.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>
Cc: Song Liu <songliubraving@fb.com>, Network Development <netdev@vger.kernel.org>, bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, kernel-team <kernel-team@fb.com>, lmb@cloudflare.com, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

[sigh, I finally set up lore nntp, and I goofed some addresses.  Hi
Kees and linux-api.]

On Thu, Jun 27, 2019 at 4:40 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On 6/27/19 1:19 PM, Song Liu wrote:
> > This patch introduce unprivileged BPF access. The access control is
> > achieved via device /dev/bpf. Users with write access to /dev/bpf are able
> > to call sys_bpf().
> >
> > Two ioctl command are added to /dev/bpf:
> >
> > The two commands enable/disable permission to call sys_bpf() for current
> > task. This permission is noted by bpf_permitted in task_struct. This
> > permission is inherited during clone(CLONE_THREAD).
> >
> > Helper function bpf_capable() is added to check whether the task has got
> > permission via /dev/bpf.
> >
>
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 0e079b2298f8..79dc4d641cf3 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -9134,7 +9134,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
> >               env->insn_aux_data[i].orig_idx = i;
> >       env->prog = *prog;
> >       env->ops = bpf_verifier_ops[env->prog->type];
> > -     is_priv = capable(CAP_SYS_ADMIN);
> > +     is_priv = bpf_capable(CAP_SYS_ADMIN);
>
> Huh?  This isn't a hardening measure -- the "is_priv" verifier mode
> allows straight-up leaks of private kernel state to user mode.
>
> (For that matter, the pending lockdown stuff should possibly consider
> this a "confidentiality" issue.)
>
>
> I have a bigger issue with this patch, though: it's a really awkward way
> to pretend to have capabilities.  For bpf, it seems like you could make
> this be a *real* capability without too much pain since there's only one
> syscall there.  Just find a way to pass an fd to /dev/bpf into the
> syscall.  If this means you need a new bpf_with_cap() syscall that takes
> an extra argument, so be it.  The old bpf() syscall can just translate
> to bpf_with_cap(..., -1).
>
> For a while, I've considered a scheme I call "implicit rights".  There
> would be a directory in /dev called /dev/implicit_rights.  This would
> either be part of devtmpfs or a whole new filesystem -- it would *not*
> be any other filesystem.  The contents would be files that can't be read
> or written and exist only in memory.  You create them with a privileged
> syscall.  Certain actions that are sensitive but not at the level of
> CAP_SYS_ADMIN (use of large-attack-surface bpf stuff, creation of user
> namespaces, profiling the kernel, etc) could require an "implicit
> right".  When you do them, if you don't have CAP_SYS_ADMIN, the kernel
> would do a path walk for, say, /dev/implicit_rights/bpf and, if the
> object exists, can be opened, and actually refers to the "bpf" rights
> object, then the action is allowed.  Otherwise it's denied.
>
> This is extensible, and it doesn't require the rather ugly per-task
> state of whether it's enabled.
>
> For things like creation of user namespaces, there's an existing API,
> and the default is that it works without privilege.  Switching it to an
> implicit right has the benefit of not requiring code changes to programs
> that already work as non-root.
>
> But, for BPF in particular, this type of compatibility issue doesn't
> exist now.  You already can't use most eBPF functionality without
> privilege.  New bpf-using programs meant to run without privilege are
> *new*, so they can use a new improved API.  So, rather than adding this
> obnoxious ioctl, just make the API explicit, please.
>
> Also, please cc: linux-abi next time.
