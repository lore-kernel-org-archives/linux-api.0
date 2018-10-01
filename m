From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path resolution
Date: Mon, 1 Oct 2018 07:28:34 -0700
Message-ID: <C89D720F-3CC4-4FA9-9CBB-E41A67360A6B@amacapital.net>
References: <20180929103453.12025-1-cyphar@cyphar.com> <20180929131534.24472-1-cyphar@cyphar.com> <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com> <20181001054246.gfinmx3api7kjhmc@ryuk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181001054246.gfinmx3api7kjhmc@ryuk>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


>>> Currently most container runtimes try to do this resolution in
>>> userspace[1], causing many potential race conditions. In addition, the
>>> "obvious" alternative (actually performing a {ch,pivot_}root(2))
>>> requires a fork+exec which is *very* costly if necessary for every
>>> filesystem operation involving a container.
>>=20
>> Wait. fork() I understand, but why exec? And actually, you don't need
>> a full fork() either, clone() lets you do this with some process parts
>> shared. And then you also shouldn't need to use SCM_RIGHTS, just keep
>> the file descriptor table shared. And why chroot()/pivot_root(),
>> wouldn't you want to use setns()?
>=20
> You're right about this -- for C runtimes. In Go we cannot do a raw
> clone() or fork() (if you do it manually with RawSyscall you'll end with
> broken runtime state). So you're forced to do fork+exec (which then
> means that you can't use CLONE_FILES and must use SCM_RIGHTS). Same goes
> for CLONE_VFORK.

I must admit that I=E2=80=99m not very sympathetic to the argument that =E2=80=
=9CGo=E2=80=99s runtime model is incompatible with the simpler solution.=E2=80=
=9D

Anyway, it occurs to me that the real problem is that setns() and chroot() a=
re both overkill for this use case. What=E2=80=99s needed is to start your w=
alk from /proc/pid-in-container/root, with two twists:

1. Do the walk as though rooted at a directory. This is basically just your A=
T_THIS_ROOT, but the footgun is avoided because the dirfd you use is from a f=
oreign namespace, and, except for symlinks to absolute paths, no amount of .=
. racing is going to escape the *namespace*.

2. Avoid /proc. It=E2=80=99s not just the *links* =E2=80=94 you really don=E2=
=80=99t want to walk into /proc/self. *Maybe* procfs is already careful enou=
gh when mounted in a namespace?
