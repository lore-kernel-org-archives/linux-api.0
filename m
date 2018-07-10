From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Tue, 10 Jul 2018 16:59:34 -0700
Message-ID: <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, jannh@google.com
List-Id: linux-api@vger.kernel.org

[cc Jann - you love this stuff]

> On Jul 10, 2018, at 3:44 PM, David Howells <dhowells@redhat.com> wrote:
>=20
> Provide an fsopen() system call that starts the process of preparing to
> create a superblock that will then be mountable, using an fd as a context
> handle.  fsopen() is given the name of the filesystem that will be used:
>=20
>    int mfd =3D fsopen(const char *fsname, unsigned int flags);

This is great in principle, but I think you=E2=80=99re seriously playing wit=
h fire with the API.=20

>=20
> where flags can be 0 or FSOPEN_CLOEXEC.
>=20
> For example:
>=20
>    sfd =3D fsopen("ext4", FSOPEN_CLOEXEC);
>    write(sfd, "s /dev/sdb1"); // note I'm ignoring write's length arg

Imagine some malicious program passes sfd as stdout to a setuid program. Tha=
t program gets persuaded to write =E2=80=9Cs /etc/shadow=E2=80=9D.  What hap=
pens?  You=E2=80=99re okay as long as *every single fs* gets it right, but t=
hat=E2=80=99s asking a lot.

>    write(sfd, "o noatime");
>    write(sfd, "o acl");
>    write(sfd, "o user_attr");
>    write(sfd, "o iversion");
>    write(sfd, "o ");
>    write(sfd, "r /my/container"); // root inside the fs
>    write(sfd, "x create"); // create the superblock

=46rom cursory inspection of a bunch of the code, I think the expectation is=
 that the actual device access happens in the =E2=80=9Cx=E2=80=9D action. Th=
is is not okay. You can=E2=80=99t do this kind of thing in a write() handler=
, unless you somehow make every single access using f_cred, which is a real p=
ain.

I think the right solution is one of:

(a) Pass a netlink-formatted blob to fsopen() and do the whole thing in one s=
yscall. I don=E2=80=99t mean using netlink sockets =E2=80=94 just the nlattr=
 format.  Or you could use a different format. The part that matters is usin=
g just one syscall to do the whole thing.

(b) Keep the current structure but use a new syscall instead of write().

(c) Keep using write() but literally just buffer the data. Then have a new s=
yscall to commit it.  In other words, replace =E2=80=9Cx=E2=80=9D with a sys=
call and call all the fs_context_operations helpers in that context instead o=
f from write().=
