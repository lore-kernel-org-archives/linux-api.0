From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Thu, 12 Jul 2018 11:30:32 -0700
Message-ID: <76211EBC-05ED-4FBA-A136-F5EEBFDD9FDF@amacapital.net>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <20180712171505.GA23780@kroah.com> <20180712172024.GZ30522@ZenIV.linux.org.uk> <20180712180304.GA27758@kroah.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180712180304.GA27758@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


> On Jul 12, 2018, at 11:03 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
>> On Thu, Jul 12, 2018 at 06:20:24PM +0100, Al Viro wrote:
>>> On Thu, Jul 12, 2018 at 07:15:05PM +0200, Greg KH wrote:
>>>> On Tue, Jul 10, 2018 at 11:44:09PM +0100, David Howells wrote:
>>>> Provide an fsopen() system call that starts the process of preparing to=

>>>> create a superblock that will then be mountable, using an fd as a conte=
xt
>>>> handle.  fsopen() is given the name of the filesystem that will be used=
:
>>>>=20
>>>>    int mfd =3D fsopen(const char *fsname, unsigned int flags);
>>>>=20
>>>> where flags can be 0 or FSOPEN_CLOEXEC.
>>>>=20
>>>> For example:
>>>>=20
>>>>    sfd =3D fsopen("ext4", FSOPEN_CLOEXEC);
>>>>    write(sfd, "s /dev/sdb1"); // note I'm ignoring write's length arg
>>>>    write(sfd, "o noatime");
>>>>    write(sfd, "o acl");
>>>>    write(sfd, "o user_attr");
>>>>    write(sfd, "o iversion");
>>>>    write(sfd, "o ");
>>>>    write(sfd, "r /my/container"); // root inside the fs
>>>>    write(sfd, "x create"); // create the superblock
>>>=20
>>> Ugh, creating configfs again in a syscall form?  I know people love
>>> file descriptors, but can't you do this with a configfs entry instead if=

>>> you really want to do this type of thing from userspace in this type of
>>> "style"?
>>>=20
>>> Why reinvent the wheel again?
>>=20
>> The damn thing REALLY, REALLY depends upon the fs type.  How would
>> you map it on configfs?
>=20
> /sys/kernel/config/fs/ext4/ would work, right?  Each fs "type" would be
> listed there.
>=20
> Anyway, the whole "write a bunch of options and then do a 'create'" is
> exactly the way configfs works.  Why not use that?
>=20
>=20

How do you mount configfs in the first place?  And how do you use this in a m=
ount namespace without a private configfs instance or where you don=E2=80=99=
t want configfs mounted?=
