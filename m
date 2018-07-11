From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Tue, 10 Jul 2018 18:14:10 -0700
Message-ID: <CAG48ez2-p=jGZwmb3soh87RM6qHGEi6ctbLOVZ99LG6aHXUX_g@mail.gmail.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 10, 2018 at 4:59 PM Andy Lutomirski <luto@amacapital.net> wrote=
:
>
> [cc Jann - you love this stuff]
>
> > On Jul 10, 2018, at 3:44 PM, David Howells <dhowells@redhat.com> wrote:
> >
> > Provide an fsopen() system call that starts the process of preparing to
> > create a superblock that will then be mountable, using an fd as a conte=
xt
> > handle.  fsopen() is given the name of the filesystem that will be used=
:
> >
> >    int mfd =3D fsopen(const char *fsname, unsigned int flags);
>
> This is great in principle, but I think you=E2=80=99re seriously playing =
with fire with the API.
>
> >
> > where flags can be 0 or FSOPEN_CLOEXEC.
> >
> > For example:
> >
> >    sfd =3D fsopen("ext4", FSOPEN_CLOEXEC);
> >    write(sfd, "s /dev/sdb1"); // note I'm ignoring write's length arg
>
> Imagine some malicious program passes sfd as stdout to a setuid program. =
That program gets persuaded to write =E2=80=9Cs /etc/shadow=E2=80=9D.  What=
 happens?  You=E2=80=99re okay as long as *every single fs* gets it right, =
but that=E2=80=99s asking a lot.
>
> >    write(sfd, "o noatime");
> >    write(sfd, "o acl");
> >    write(sfd, "o user_attr");
> >    write(sfd, "o iversion");
> >    write(sfd, "o ");
> >    write(sfd, "r /my/container"); // root inside the fs
> >    write(sfd, "x create"); // create the superblock
>
> From cursory inspection of a bunch of the code, I think the expectation i=
s that the actual device access happens in the =E2=80=9Cx=E2=80=9D action. =
This is not okay. You can=E2=80=99t do this kind of thing in a write() hand=
ler, unless you somehow make every single access using f_cred, which is a r=
eal pain.
>
> I think the right solution is one of:
>
> (a) Pass a netlink-formatted blob to fsopen() and do the whole thing in o=
ne syscall. I don=E2=80=99t mean using netlink sockets =E2=80=94 just the n=
lattr format.  Or you could use a different format. The part that matters i=
s using just one syscall to do the whole thing.
>
> (b) Keep the current structure but use a new syscall instead of write().
>
> (c) Keep using write() but literally just buffer the data. Then have a ne=
w syscall to commit it.  In other words, replace =E2=80=9Cx=E2=80=9D with a=
 syscall and call all the fs_context_operations helpers in that context ins=
tead of from write().

I also love ioctls, so I think you could also use an ioctl to do the
commit? You can do anything (well, almost anything) that you can do in
syscall context in ioctl context, too; and when you already have a
file descriptor of a specific type that you want to perform an
operation on, an ioctl works just fine.
