From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Thu, 12 Jul 2018 09:23:22 -0700
Message-ID: <338BC3C4-F3E7-48F0-A82E-2C7295B6640E@amacapital.net>
References: <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk> <7002.1531407244@warthog.procyon.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7002.1531407244@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, tycho@tycho.ws
List-Id: linux-api@vger.kernel.org



> On Jul 12, 2018, at 7:54 AM, David Howells <dhowells@redhat.com> wrote:
>=20
> Andy Lutomirski <luto@kernel.org> wrote:
>=20
>>> On Jul 11, 2018, at 12:22 AM, David Howells <dhowells@redhat.com> wrote:=

>>>=20
>>> Andy Lutomirski <luto@amacapital.net> wrote:
>>>=20
>>>>>  sfd =3D fsopen("ext4", FSOPEN_CLOEXEC);
>>>>>  write(sfd, "s /dev/sdb1"); // note I'm ignoring write's length arg
>>>>=20
>>>> Imagine some malicious program passes sfd as stdout to a setuid
>>>> program. That program gets persuaded to write "s /etc/shadow".  What
>>>> happens?  You=E2=80=99re okay as long as *every single fs* gets it righ=
t, but
>>>> that=E2=80=99s asking a lot.
>>>=20
>>> Do note that you must already have CAP_SYS_ADMIN to be able to call
>>> fsopen().
>>=20
>> If you're not allowing it already, someone will want user namespace
>> root to be able to use this very, very soon.
>=20
> Yeah, I'm sure.  And I've been thinking on how to deal with it.
>=20
> I think we *have* to open the source files/devices with the creds of whoev=
er
> called fsopen() or fspick() - that way you can't upgrade your privs by pas=
sing
> your context fd to a suid program.  To enforce this, I think it's simplest=
 for
> fscontext_write() to call override_creds() right after taking the uapi_mut=
ex
> and then call revert_creds() right before dropping the mutex.
>=20

If you make a syscall that attaches a block device to an fscontext, you don=E2=
=80=99t need any of this.  Heck, someone might actually *want* to grab a blo=
ck device from a different namespace.

All this override_creds() stuff is maybe okay if we were fixing an old broke=
n thing. But this is brand new.  And having write() call override_creds() an=
d do nontrivial things is a fascinating attack surface.

Just imagine what blows up if I abuse fscontext to open a block device on a p=
ath that traverses an AFS mount or /proc/.../fd or similar.  Or if I splice(=
) from a network filesystem into fscontext.

(Al- can=E2=80=99t we just stop allowing splice() at all on things that don=E2=
=80=99t use iov_iter?)

> Another thing we might want to look at is to allow a supervisory process t=
o
> examine the context before permitting the create/reconfigure action to
> proceed.  It might also be possible to do this through the LSM.

Cc Tycho. He=E2=80=99s working on this exact idea using seccomp. And he=E2=80=
=99d probably much, much prefer if configuration of an fscontext didn=E2=80=99=
t use a performance-critical syscall like write().

As a straw man, I suggest:

fsconfigure(contextfd, ADD_BLOCKDEV, dfd, path, flags);

fsconfigure(contextfd, ADD_OPTION, 0, =E2=80=9Cfoo=3Dbar=E2=80=9D, flags);

Etc. =20
