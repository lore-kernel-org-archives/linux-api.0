From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Mon, 5 Aug 2019 10:23:10 -0700
Message-ID: <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com> <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com> <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook> <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com> <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
 <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com> <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
 <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com> <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
 <369476A8-4CE1-43DA-9239-06437C0384C7@fb.com> <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
 <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com> <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
 <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com> <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com> <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 5, 2019 at 12:37 AM Song Liu <songliubraving@fb.com> wrote:
>
> Hi Andy,
>

> >
> > # mount -t bpf bpf /sys/fs/bpf
> > # cd /sys/fs/bpf
> > # mkdir luto
> > # chown luto: luto
> > # setpriv --euid=1000 --ruid=1000 bash
> > $ pwd
> > /sys/fs/bpf
> > bash-5.0$ ls -l
> > total 0
> > drwxr-xr-x 2 luto luto 0 Aug  4 22:41 luto
> > bash-5.0$ bpftool map create /sys/fs/bpf/luto/filename type hash key 8
> > value 8 entries 64 name mapname
> > bash-5.0$ bpftool map dump pinned /sys/fs/bpf/luto/filename
> > Found 0 elements
> >
> > # chown root: /sys/fs/bpf/luto/filename
> >
> > $ bpftool map dump pinned /sys/fs/bpf/luto/filename
> > Error: bpf obj get (/sys/fs/bpf/luto): Permission denied
> >
> > So I think it's possible to get a respectable subset of bpf()
> > functionality working without privilege in short order :)
>
> I think we have two key questions to answer:
>   1. What subset of bpf() functionality will the users need?
>   2. Who are the users?
>
> Different answers to these two questions lead to different directions.
>
>
> In our use case, the answers are
>   1) almost all bpf() functionality
>   2) highly trusted users (sudoers)
>
> So our initial approach of /dev/bpf allows all bpf() functionality
> in one bit in task_struct. (Yes, we can just sudo. But, we would
> rather not use sudo when possible.)

For this, I think some compelling evidence is needed that a new kernel
mechanism is actually better than sudo and better than making bpftool
privileged as previously discussed :)

>
>
> "cgroup management" use case may have answers like:
>   1) cgroup_bpf only
>   2) users in their own containers
>
> For this case, getting cgroup_bpf related features (cgroup_bpf progs;
> some map types, etc.) work with unprivileged users would be the right
> direction.

:)

>
>
> "USDT tracing" use case may have answers like:
>   1) uprobe, stockmap, histogram, etc.
>   2) unprivileged user, w/ or w/o containers
>
> For this case, the first step is likely hacking sys_perf_event_open().
>

This would be nice.

>
> I guess we will need more discussions to decide how to make bpf()
> work better for all these (and more) use cases.
>

I refreshed the branch again.  I had a giant hole in my previous idea
that we could deprivilege program loading: some BPF functions need
privilege.  Now I have a changelog comment to that effect and a patch
that sketches out a way to addressing this.

I don't think I'm going to have time soon to actually get any of this
stuff mergeable, and it would be fantastic if you or someone else who
likes working of bpf were to take this code and run with it.  Feel
free to add my Signed-off-by, and I'd be happy to help review.
