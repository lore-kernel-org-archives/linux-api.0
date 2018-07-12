From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Thu, 12 Jul 2018 10:54:36 -0700
Message-ID: <719E8034-2E07-45C0-9B04-838431F5309F@amacapital.net>
References: <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk> <7002.1531407244@warthog.procyon.org.uk> <338BC3C4-F3E7-48F0-A82E-2C7295B6640E@amacapital.net> <20180712165821.GY30522@ZenIV.linux.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180712165821.GY30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, tycho@tycho.ws
List-Id: linux-api@vger.kernel.org



> On Jul 12, 2018, at 9:58 AM, Al Viro <viro@ZenIV.linux.org.uk> wrote:
>=20
>> On Thu, Jul 12, 2018 at 09:23:22AM -0700, Andy Lutomirski wrote:
>>=20
>> As a straw man, I suggest:
>>=20
>> fsconfigure(contextfd, ADD_BLOCKDEV, dfd, path, flags);
>>=20
>> fsconfigure(contextfd, ADD_OPTION, 0, =E2=80=9Cfoo=3Dbar=E2=80=9D, flags)=
;
>=20
> Bollocks.  First of all, block device *IS* a fucking option.
> Always had been.  It's not even that it's passed as a separate
> argument for historical reasons - just look at NFS.  That argument
> is a detached part of options, parsed (yes, *parsed*) by filesystem
> in question in whatever way it prefers.

Fine, then generalize it. fsconfigure(context, ADD_FD, =E2=80=9Csome fs-spec=
ific string explaining what=E2=80=99s going on=E2=80=9D, fd);  The point bei=
ng that there are tons of cases where the filesystem wants to identify some b=
acking store by some device node, and it seems like we should support someth=
ing along the lines of a modern *at interface.

If I=E2=80=99m writing a daemon that deals with filesystems, I don=E2=80=99t=
 want an API that looks like do_god_knows_what(context, =E2=80=9Cfilesystem s=
pecific string that may contain a path to a device node or a network address=
=E2=80=9D). That API will be a pain to use, since that opaque string may com=
e from some random config file and I have no clue what it does. If I want to=
 pass a device node or other object to a filesystem, I want to pass an fd (s=
o I can use openat, SCM_CREDS, etc), and I want it to be crystal clear that I=
=E2=80=99m passing some object in. And if I tell a filesystem to access the n=
etwork, I want it to be entirely clear which network namespace is in use.

I realize that doing this right is tricky when there are lots of legacy file=
systems that parse opaque strings. That=E2=80=99s fine. We can convert thing=
s slowly.
