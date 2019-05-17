From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 0/4] uapi, vfs: Change the mount API UAPI [ver #2]
Date: Fri, 17 May 2019 08:54:52 +0200
Message-ID: <D41D33CA-ADFC-4E79-9C9C-79FE19E068CA@brauner.io>
References: <155800752418.4037.9567789434648701032.stgit@warthog.procyon.org.uk> <20190516162259.GB17978@ZenIV.linux.org.uk> <20190516163151.urrmrueugockxtdy@brauner.io> <20190516165021.GD17978@ZenIV.linux.org.uk> <20190516202331.GA29908@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190516202331.GA29908@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On May 16, 2019 10:23:31 PM GMT+02:00, "Dmitry V=2E Levin" <ldv@altlinux=2E=
org> wrote:
>[looks like linux-abi is a typo, Cc'ed linux-api instead]
>
>On Thu, May 16, 2019 at 05:50:22PM +0100, Al Viro wrote:
>> [linux-abi cc'd]
>>=20
>> On Thu, May 16, 2019 at 06:31:52PM +0200, Christian Brauner wrote:
>> > On Thu, May 16, 2019 at 05:22:59PM +0100, Al Viro wrote:
>> > > On Thu, May 16, 2019 at 12:52:04PM +0100, David Howells wrote:
>> > > >=20
>> > > > Hi Linus, Al,
>> > > >=20
>> > > > Here are some patches that make changes to the mount API UAPI
>and two of
>> > > > them really need applying, before -rc1 - if they're going to be
>applied at
>> > > > all=2E
>> > >=20
>> > > I'm fine with 2--4, but I'm not convinced that cloexec-by-default
>crusade
>> > > makes any sense=2E  Could somebody give coherent arguments in
>favour of
>> > > abandoning the existing conventions?
>> >=20
>> > So as I said in the commit message=2E From a userspace perspective
>it's
>> > more of an issue if one accidently leaks an fd to a task during
>exec=2E
>> >=20
>> > Also, most of the time one does not want to inherit an fd during an
>> > exec=2E It is a hazzle to always have to specify an extra flag=2E
>> >=20
>> > As Al pointed out to me open() semantics are not going anywhere=2E
>Sure,
>> > no argument there at all=2E
>> > But the idea of making fds cloexec by default is only targeted at
>fds
>> > that come from separate syscalls=2E fsopen(), open_tree_clone(), etc=
=2E
>they
>> > all return fds independent of open() so it's really easy to have
>them
>> > cloexec by default without regressing anyone and we also remove the
>need
>> > for a bunch of separate flags for each syscall to turn them into
>> > cloexec-fds=2E I mean, those for syscalls came with 4 separate flags
>to be
>> > able to specify that the returned fd should be made cloexec=2E The
>other
>> > way around, cloexec by default, fcntl() to remove the cloexec bit
>is way
>> > saner imho=2E
>>=20
>> Re separate flags - it is, in principle, a valid argument=2E  OTOH, I'm
>not
>> sure if they need to be separate - they all have the same value and
>> I don't see any reason for that to change=2E=2E=2E
>>=20
>> Only tangentially related, but I wonder if something like
>close_range(from, to)
>> would be a more useful approach=2E=2E=2E  That kind of open-coded loops=
 is
>not
>> rare in userland and kernel-side code can do them much cheaper=2E=20
>Something
>> like
>> 	/* that exec is sensitive */
>> 	unshare(CLONE_FILES);
>> 	/* we don't want anything past stderr here */
>> 	close_range(3, ~0U);
>> 	execve(=2E=2E=2E=2E);
>> on the userland side of thing=2E  Comments?
>
>glibc people need a syscall to implement closefrom properly, see
>https://sourceware=2Eorg/bugzilla/show_bug=2Ecgi?id=3D10353#c14

I have a prototype for close_range()=2E
I'll send it out after rc1=2E

Christian
