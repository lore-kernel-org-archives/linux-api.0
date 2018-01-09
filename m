From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCHv3 0/2] capability controlled user-namespaces
Date: Tue, 9 Jan 2018 16:28:59 -0600
Message-ID: <20180109222859.GA25956@mail.hallyn.com>
References: <CAF2d9jiPYvMN=_guoZHyTA5FmMgaJb5mtxroi5D9NvcNrHc5gg@mail.gmail.com>
 <alpine.LFD.2.20.1801081131190.8436@localhost>
 <20180108062452.GA21717@mail.hallyn.com>
 <alpine.LFD.2.20.1801082040180.12014@localhost>
 <20180108154733.GA29416@mail.hallyn.com>
 <CAF2d9jgVJpuAH+jgK0v7sQ9Pr75xy=GSnqKDdpeE7d97O0EbcQ@mail.gmail.com>
 <20180108181121.GA32302@mail.hallyn.com>
 <CAF2d9jgar8J+mQjUfF=+XdvrcS=RvtOpKysxOiZkG-rXgm0KVw@mail.gmail.com>
 <20180108183610.GA562@mail.hallyn.com>
 <CAF2d9jjws=jEbybHs18J_xkduAWB+bh6BA_CkD5oYRWz7PwjZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF2d9jjws=jEbybHs18J_xkduAWB+bh6BA_CkD5oYRWz7PwjZA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <james.l.morris@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <mahesh@bandewar.net>
List-Id: linux-api@vger.kernel.org

Quoting Mahesh Bandewar (महेश बंडेवार) (maheshb@google.com):
> On Mon, Jan 8, 2018 at 10:36 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > Quoting Mahesh Bandewar (महेश बंडेवार) (maheshb@google.com):
> >> On Mon, Jan 8, 2018 at 10:11 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> >> > Quoting Mahesh Bandewar (महेश बंडेवार) (maheshb@google.com):
> >> >> On Mon, Jan 8, 2018 at 7:47 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> >> >> > Quoting James Morris (james.l.morris@oracle.com):
> >> >> >> On Mon, 8 Jan 2018, Serge E. Hallyn wrote:
> >> >> >> I meant in terms of "marking" a user ns as "controlled" type -- it's
> >> >> >> unnecessary jargon from an end user point of view.
> >> >> >
> >> >> > Ah, yes, that was my point in
> >> >> >
> >> >> > http://lkml.iu.edu/hypermail/linux/kernel/1711.1/01845.html
> >> >> > and
> >> >> > http://lkml.iu.edu/hypermail/linux/kernel/1711.1/02276.html
> >> >> >
> >> >> >> This may happen internally but don't make it a special case with a
> >> >> >> different name and don't bother users with internal concepts: simply
> >> >> >> implement capability whitelists with the default having equivalent
> >> >
> >> > So the challenge is to have unprivileged users be contained, while
> >> > allowing trusted workloads in containers created by a root user to
> >> > bypass the restriction.
> >> >
> >> > Now, the current proposal actually doesn't support a root user starting
> >> > an application that it doesn't quite trust in such a way that it *is*
> >> > subject to the whitelist.
> >>
> >> Well, this is not hard since root process can spawn another process
> >> and loose privileges before creating user-ns to be controlled by the
> >> whitelist.
> >
> > It would have to drop cap_sys_admin for the container to be marked as
> > "controlled", which may prevent the container runtime from properly starting
> > the container.
> >
> Yes, but that's a conflict of trusted operations (that requires
> SYS_ADMIN) and untrusted processes it may spawn.

Not sure I understand what you're saying, but

I guess that in any case the task which is doing unshare(CLONE_NEWNS)
can drop cap_sys_admin first.  Though that is harder if using clone,
and it is awkward because it's not the container manager, but the user,
who will judge whether the container workload should be restricted.
So the container driver will add a flag like "run-controlled", and
the driver will convert that to dropping a capability; which again
is weird.  It would seem nicer to introduce a userns flag, 'caps-controlled'
For an unprivileged userns, it is always set to 1, and root cannot
change it.  For a root-created userns, it stays 0, but root can set it
to 1 (using /proc file?).  In this way a either container runtime or just an
admin script can say "no wait I want this container to still be controlled".

Or we could instead add a second sysctl to decide whether all or only
'controlled' user namespaces should be controlled.  That's not pretty though.
