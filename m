From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v7 3/6] seccomp: add a way to get a listener fd from ptrace
Date: Tue, 9 Oct 2018 18:26:47 +0200
Message-ID: <CAG48ez2ROhq4R1az2TXNmBvCXY=3UVxnmh6CeR05N0xVGrpwpA@mail.gmail.com>
References: <20181008162147.ubfxxsv2425l2zsp@brauner.io> <CAG48ez3O+wAkq+0yDfoMt73ybnCOEPpi3Mu-uF57_v=6hA8ZEw@mail.gmail.com>
 <20181008181815.pwnqxngj22mhm2vj@brauner.io> <CAG48ez3PEce4ynRnDk=yfsAOuFGH=YMmuf13CAxEt07Yjk3ZCw@mail.gmail.com>
 <20181009132850.fp6yne2vgmfpi27k@brauner.io> <CAG48ez2EV8Z=Egn7hNpXd86bHdvQhVxStqE1N=U2L2R7sA-gjg@mail.gmail.com>
 <20181009134923.2fvf5roghqgaj5gq@brauner.io> <CAG48ez1hnKkm7mzXuZLP4n6x8K1JqmTwQb-e79oJguTaH1mkUw@mail.gmail.com>
 <20181009140932.e5w5lgbgucbl72kt@brauner.io> <CAG48ez12SYRUJTWRdzWhpvHBkQion4i8Gpef4r1L6epo9JF-ng@mail.gmail.com>
 <20181009162022.d7fd2wibyq6xi6sg@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009162022.d7fd2wibyq6xi6sg@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: christian@brauner.io
Cc: Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, suda.akihiro@lab.ntt.co.jp, Oleg Nesterov <oleg@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>, linux-security-module <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 9, 2018 at 6:20 PM Christian Brauner <christian@brauner.io> wrote:
> On Tue, Oct 09, 2018 at 05:26:26PM +0200, Jann Horn wrote:
> > On Tue, Oct 9, 2018 at 4:09 PM Christian Brauner <christian@brauner.io> wrote:
> > > On Tue, Oct 09, 2018 at 03:50:53PM +0200, Jann Horn wrote:
> > > > On Tue, Oct 9, 2018 at 3:49 PM Christian Brauner <christian@brauner.io> wrote:
> > > > > On Tue, Oct 09, 2018 at 03:36:04PM +0200, Jann Horn wrote:
> > > > > > On Tue, Oct 9, 2018 at 3:29 PM Christian Brauner <christian@brauner.io> wrote:
> > > > > > > One more thing. Citing from [1]
> > > > > > >
> > > > > > > > I think there's a security problem here. Imagine the following scenario:
> > > > > > > >
> > > > > > > > 1. task A (uid==0) sets up a seccomp filter that uses SECCOMP_RET_USER_NOTIF
> > > > > > > > 2. task A forks off a child B
> > > > > > > > 3. task B uses setuid(1) to drop its privileges
> > > > > > > > 4. task B becomes dumpable again, either via prctl(PR_SET_DUMPABLE, 1)
> > > > > > > > or via execve()
> > > > > > > > 5. task C (the attacker, uid==1) attaches to task B via ptrace
> > > > > > > > 6. task C uses PTRACE_SECCOMP_NEW_LISTENER on task B
> > > > > > >
> > > > > > > Sorry, to be late to the party but would this really pass
> > > > > > > __ptrace_may_access() in ptrace_attach()? It doesn't seem obvious to me
> > > > > > > that it would... Doesn't look like it would get past:
> > > > > > >
> > > > > > >         tcred = __task_cred(task);
> > > > > > >         if (uid_eq(caller_uid, tcred->euid) &&
> > > > > > >             uid_eq(caller_uid, tcred->suid) &&
> > > > > > >             uid_eq(caller_uid, tcred->uid)  &&
> > > > > > >             gid_eq(caller_gid, tcred->egid) &&
> > > > > > >             gid_eq(caller_gid, tcred->sgid) &&
> > > > > > >             gid_eq(caller_gid, tcred->gid))
> > > > > > >                 goto ok;
> > > > > > >         if (ptrace_has_cap(tcred->user_ns, mode))
> > > > > > >                 goto ok;
> > > > > > >         rcu_read_unlock();
> > > > > > >         return -EPERM;
> > > > > > > ok:
> > > > > > >         rcu_read_unlock();
> > > > > > >         mm = task->mm;
> > > > > > >         if (mm &&
> > > > > > >             ((get_dumpable(mm) != SUID_DUMP_USER) &&
> > > > > > >              !ptrace_has_cap(mm->user_ns, mode)))
> > > > > > >             return -EPERM;
> > > > > >
> > > > > > Which specific check would prevent task C from attaching to task B? If
> > > > > > the UIDs match, the first "goto ok" executes; and you're dumpable, so
> > > > > > you don't trigger the second "return -EPERM".
> > > > >
> > > > > You'd also need CAP_SYS_PTRACE in the mm->user_ns which you shouldn't
> > > > > have if you did a setuid to an unpriv user. (But I always find that code
> > > > > confusing.)
> > > >
> > > > Only if the target hasn't gone through execve() since setuid().
> > >
> > > Sorry if I want to know this in excessive detail but I'd like to
> > > understand this properly so bear with me :)
> > > - If task B has setuid()ed and prctl(PR_SET_DUMPABLE, 1)ed but not
> > >   execve()ed then C won't pass ptrace_has_cap(mm->user_ns, mode).
> >
> > Yeah.
> >
> > > - If task B has setuid()ed, exeved()ed it will get its dumpable flag set
> > >   to /proc/sys/fs/suid_dumpable
> >
> > Not if you changed all UIDs (e.g. by calling setuid() as root). In
> > that case, setup_new_exec() calls "set_dumpable(current->mm,
> > SUID_DUMP_USER)".
>
> Actually, looking at this when C is trying to PTRACE_ATTACH to B as an
> unprivileged user even if B execve()ed and it is dumpable C still
> wouldn't have CAP_SYS_PTRACE in the mm->user_ns unless it already is
> privileged over mm->user_ns which means it must be in an ancestor
> user_ns.

Huh? Why would you need CAP_SYS_PTRACE for anything here? You can
ptrace another process running under your UID just fine, no matter
what the namespaces are. I'm not sure what you're saying.
