From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Mon, 1 Jul 2019 18:59:13 -0700
Message-ID: <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com> <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: Andy Lutomirski <luto@kernel.org>, "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 1, 2019 at 2:03 AM Song Liu <songliubraving@fb.com> wrote:
>
> Hi Andy,
>
> Thanks for these detailed analysis.
>
> > On Jun 30, 2019, at 8:12 AM, Andy Lutomirski <luto@kernel.org> wrote:
> >
> > On Fri, Jun 28, 2019 at 12:05 PM Song Liu <songliubraving@fb.com> wrote=
:
> >>
> >> Hi Andy,
> >>
> >>> On Jun 27, 2019, at 4:40 PM, Andy Lutomirski <luto@kernel.org> wrote:
> >>>
> >>> On 6/27/19 1:19 PM, Song Liu wrote:
> >>>> This patch introduce unprivileged BPF access. The access control is
> >>>> achieved via device /dev/bpf. Users with write access to /dev/bpf ar=
e able
> >>>> to call sys_bpf().
> >>>> Two ioctl command are added to /dev/bpf:
> >>>> The two commands enable/disable permission to call sys_bpf() for cur=
rent
> >>>> task. This permission is noted by bpf_permitted in task_struct. This
> >>>> permission is inherited during clone(CLONE_THREAD).
> >>>> Helper function bpf_capable() is added to check whether the task has=
 got
> >>>> permission via /dev/bpf.
> >>>
> >>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >>>> index 0e079b2298f8..79dc4d641cf3 100644
> >>>> --- a/kernel/bpf/verifier.c
> >>>> +++ b/kernel/bpf/verifier.c
> >>>> @@ -9134,7 +9134,7 @@ int bpf_check(struct bpf_prog **prog, union bp=
f_attr *attr,
> >>>>             env->insn_aux_data[i].orig_idx =3D i;
> >>>>     env->prog =3D *prog;
> >>>>     env->ops =3D bpf_verifier_ops[env->prog->type];
> >>>> -    is_priv =3D capable(CAP_SYS_ADMIN);
> >>>> +    is_priv =3D bpf_capable(CAP_SYS_ADMIN);
> >>>
> >>> Huh?  This isn't a hardening measure -- the "is_priv" verifier mode a=
llows straight-up leaks of private kernel state to user mode.
> >>>
> >>> (For that matter, the pending lockdown stuff should possibly consider=
 this a "confidentiality" issue.)
> >>>
> >>>
> >>> I have a bigger issue with this patch, though: it's a really awkward =
way to pretend to have capabilities. For bpf, it seems like you could make =
this be a *real* capability without too much pain since there's only one sy=
scall there.  Just find a way to pass an fd to /dev/bpf into the syscall.  =
If this means you need a new bpf_with_cap() syscall that takes an extra arg=
ument, so be it.  The old bpf() syscall can just translate to bpf_with_cap(=
..., -1).
> >>>
> >>> For a while, I've considered a scheme I call "implicit rights".  Ther=
e would be a directory in /dev called /dev/implicit_rights.  This would eit=
her be part of devtmpfs or a whole new filesystem -- it would *not* be any =
other filesystem.  The contents would be files that can't be read or writte=
n and exist only in memory. You create them with a privileged syscall.  Cer=
tain actions that are sensitive but not at the level of CAP_SYS_ADMIN (use =
of large-attack-surface bpf stuff, creation of user namespaces, profiling t=
he kernel, etc) could require an "implicit right".  When you do them, if yo=
u don't have CAP_SYS_ADMIN, the kernel would do a path walk for, say, /dev/=
implicit_rights/bpf and, if the object exists, can be opened, and actually =
refers to the "bpf" rights object, then the action is allowed.  Otherwise i=
t's denied.
> >>>
> >>> This is extensible, and it doesn't require the rather ugly per-task s=
tate of whether it's enabled.
> >>>
> >>> For things like creation of user namespaces, there's an existing API,=
 and the default is that it works without privilege.  Switching it to an im=
plicit right has the benefit of not requiring code changes to programs that=
 already work as non-root.
> >>>
> >>> But, for BPF in particular, this type of compatibility issue doesn't =
exist now.  You already can't use most eBPF functionality without privilege=
.  New bpf-using programs meant to run without privilege are *new*, so they=
 can use a new improved API.  So, rather than adding this obnoxious ioctl, =
just make the API explicit, please.
> >>>
> >>> Also, please cc: linux-abi next time.
> >>
> >> Thanks for your inputs.
> >>
> >> I think we need to clarify the use case here. In this case, we are NOT
> >> thinking about creating new tools for unprivileged users. Instead, we
> >> would like to use existing tools without root.
> >
> > I read patch 4, and I interpret it very differently.  Patches 2-4 are
> > creating a new version of libbpf and a new version of bpftool.  Given
> > this, I see no real justification for adding a new in-kernel per-task
> > state instead of just pushing the complexity into libbpf.
>
> I am not sure whether we are on the same page. Let me try an example,
> say we have application A, which calls sys_bpf().
>
> Before the series: we have to run A with root;
> After the series:  we add a special user with access to /dev/bpf, and
>                    run A with this special user.
>
> If we look at the whole system, I would say we are more secure after
> the series.
>
> I am not trying to make an extreme example here, because this use case
> is the motivation here.
>
> To stay safe, we have to properly manage the permission of /dev/bpf.
> This is just like we need to properly manage access to /etc/sudoers and
> /dev/mem.
>
> Does this make sense?
>

I think I'm understanding your motivation.  You're not trying to make
bpf() generically usable without privilege -- you're trying to create
a way to allow certain users to access dangerous bpf functionality
within some limits.

That's a perfectly fine goal, but I think you're reinventing the
wheel, and the wheel you're reinventing is quite complicated and
already exists.  I think you should teach bpftool to be secure when
installed setuid root or with fscaps enabled and put your policy in
bpftool.  If you want to harden this a little bit, it would seem
entirely reasonable to add a new CAP_BPF_ADMIN and change some, but
not all, of the capable() checks to check CAP_BPF_ADMIN instead of the
capabilities that they currently check.

Your example of /etc/sudoers is apt, and it does not involve any
kernel support :)
