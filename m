From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path resolution
Date: Wed, 3 Oct 2018 15:09:18 -0700
Message-ID: <CALCETrXZ_Kg25gToCzzM=4g1Z3mQgou8RmF6OWoh3+vuPk3vUA@mail.gmail.com>
References: <20180929103453.12025-1-cyphar@cyphar.com> <20180929131534.24472-1-cyphar@cyphar.com>
 <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
 <20181001054246.gfinmx3api7kjhmc@ryuk> <C89D720F-3CC4-4FA9-9CBB-E41A67360A6B@amacapital.net>
 <20181002073220.7mzndna4tdnxdvdt@ryuk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002073220.7mzndna4tdnxdvdt@ryuk>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuah@kernel.org>, David Howells <dhowells@redhat.com>, Andrew Lutomirski <luto@kernel.org>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 2, 2018 at 12:32 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
> On 2018-10-01, Andy Lutomirski <luto@amacapital.net> wrote:
> > >>> Currently most container runtimes try to do this resolution in
> > >>> userspace[1], causing many potential race conditions. In addition, =
the
> > >>> "obvious" alternative (actually performing a {ch,pivot_}root(2))
> > >>> requires a fork+exec which is *very* costly if necessary for every
> > >>> filesystem operation involving a container.
> > >>
> > >> Wait. fork() I understand, but why exec? And actually, you don't nee=
d
> > >> a full fork() either, clone() lets you do this with some process par=
ts
> > >> shared. And then you also shouldn't need to use SCM_RIGHTS, just kee=
p
> > >> the file descriptor table shared. And why chroot()/pivot_root(),
> > >> wouldn't you want to use setns()?
> > >
> > > You're right about this -- for C runtimes. In Go we cannot do a raw
> > > clone() or fork() (if you do it manually with RawSyscall you'll end w=
ith
> > > broken runtime state). So you're forced to do fork+exec (which then
> > > means that you can't use CLONE_FILES and must use SCM_RIGHTS). Same g=
oes
> > > for CLONE_VFORK.
> >
> > I must admit that I=E2=80=99m not very sympathetic to the argument that=
 =E2=80=9CGo=E2=80=99s
> > runtime model is incompatible with the simpler solution.=E2=80=9D
>
> Multi-threaded programs have a similar issue (though with Go it's much
> worse). If you fork a multi-threaded C program then you can only safely
> use AS-Safe glibc functions (those that are safe within a signal
> handler). But if you're just doing three syscalls this shouldn't be as
> big of a problem as Go where you can't even do said syscalls.
>
> > Anyway, it occurs to me that the real problem is that setns() and
> > chroot() are both overkill for this use case.
>
> I agree. My diversion to Go was to explain why it was particularly bad
> for cri-o/rkt/runc/Docker/etc.
>
> > What=E2=80=99s needed is to start your walk from /proc/pid-in-container=
/root,
> > with two twists:
> >
> > 1. Do the walk as though rooted at a directory. This is basically just
> > your AT_THIS_ROOT, but the footgun is avoided because the dirfd you
> > use is from a foreign namespace, and, except for symlinks to absolute
> > paths, no amount of .. racing is going to escape the *namespace*.
>
> This is quite clever and I'll admit I hadn't thought of this. This
> definitely fixes the ".." issue, but as you've said it won't handle
> absolute symlinks (which means userspace has the same races that we
> currently have even if you assume that you have a container process
> already running -- CVE-2018-15664 is one of many examples of this).
>
> (AT_THIS_ROOT using /proc/$container/root would in principle fix all of
> the mentioned issues -- but as I said before I'd like to see whether
> hardening ".." would be enough to solve the escape problem.)

Hmm.  Good point.
