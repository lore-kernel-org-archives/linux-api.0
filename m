From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Thu, 12 Jul 2018 13:25:58 -0700
Message-ID: <874BAC3E-390F-458F-A33F-986E89BB2987@amacapital.net>
References: <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk> <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <7002.1531407244@warthog.procyon.org.uk> <16699.1531426991@warthog.procyon.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <16699.1531426991@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org



> On Jul 12, 2018, at 1:23 PM, David Howells <dhowells@redhat.com> wrote:
>=20
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>=20
>> Don't play games with override_creds. It's wrong.
>>=20
>> You have to use file->f_creds - no games, no garbage.
>=20
> You missed the point.
>=20

>=20
> My suggestion was to use override_creds() to impose the appropriate creds a=
t
> the top, be that file->f_creds or fs_context->creds (they would be the sam=
e in
> any case).

I think it should be a new syscall and use current=E2=80=99s creds. No overr=
ide needed.


> Btw, do we protect sysfs, debugfs, tracefs, procfs, etc. writes against
> splice?  Some of the things in debugfs are really icky, allowing you to mu=
ck
> directly with hardware.
>=20

We try. It has been a perennial source of severe bugs.

This is part of why I=E2=80=99d like to see splice() be an opt in. Also, it=E2=
=80=99s a major step toward getting rid of set_fs().=
