From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 30/38] vfs: syscall: Add fsmount() to create a mount for a
 superblock [ver #10]
Date: Fri, 27 Jul 2018 12:43:53 -0700
Message-ID: <CALCETrVmZKeFv7b+c8hBQ-3Dcryv7VXTHdyWftvNG1G4aQk9Mw@mail.gmail.com>
References: <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
 <153271288242.9458.18050138471208178879.stgit@warthog.procyon.org.uk> <D09916DC-DA22-48AA-A62B-F874BB3C15BC@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D09916DC-DA22-48AA-A62B-F874BB3C15BC@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 27, 2018 at 12:27 PM, Andy Lutomirski <luto@amacapital.net> wro=
te:
>
>
>> On Jul 27, 2018, at 10:34 AM, David Howells <dhowells@redhat.com> wrote:
>>
>> Provide a system call by which a filesystem opened with fsopen() and
>> configured by a series of writes can be mounted:
>>
>>    int ret =3D fsmount(int fsfd, unsigned int flags,
>>              unsigned int ms_flags);
>>
>> where fsfd is the file descriptor returned by fsopen().  flags can be 0 =
or
>> FSMOUNT_CLOEXEC.  ms_flags is a bitwise-OR of the following flags:
>
> I have a potentially silly objection. For the old timers, =E2=80=9Cmount=
=E2=80=9D means to stick a reel of tape or some similar object onto a reade=
r, which seems to imply that =E2=80=9Cmount=E2=80=9D means to start up the =
filesystem. For younguns, this meaning is probably lost, and the more obvio=
us meaning is to =E2=80=9Cmount=E2=80=9D it into some location in the VFS h=
ierarchy a la vfsmount. The patch description doesn=E2=80=99t disambiguate =
it, and obviously people used to mount(2)/mount(8) are just likely to be co=
nfused.
>
> At the very least, your description should make it absolutely clear what =
you mean. Even better IMO would be to drop the use of the word =E2=80=9Cmou=
nt=E2=80=9D entirely and maybe rename the syscall.
>
> From a very brief reading, I think you are giving it the meaning that wou=
ld be implied by fsstart(2).
>

After further reading, maybe what you actually mean is:

int mfd =3D fsmount(...);

where you pass in an fscontext fd and get out an fd referring to the
root of the filesystem?  In this case, maybe fs_open_root(2) would be
a better name.

This *definitely* needs to be clearer in the description.
