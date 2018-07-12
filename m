From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Thu, 12 Jul 2018 16:21:35 -0700
Message-ID: <611054C7-D6E8-4C89-958E-3128C9305E1E@amacapital.net>
References: <20180712223223.GA28610@thunk.org> <CA+55aFw1WyKY+-2dg62M-QT_F0-waCTCrba1DW4dStYz-f_fjA@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk> <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <7002.1531407244@warthog.procyon.org.uk> <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com> <16699.1531426991@warthog.procyon.org.uk> <18233.1531430797@warthog.procyon.org.uk> <22105.1531436081@warthog.procyon.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <22105.1531436081@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org



> On Jul 12, 2018, at 3:54 PM, David Howells <dhowells@redhat.com> wrote:
>=20
> Theodore Y. Ts'o <tytso@mit.edu> wrote:
>=20
>> So maybe the answer is that you open /dev/sda1 and /dev/sda2 and then
>> pass the file descriptors to the fsopen object?  We can require that
>> the fd's be opened with O_RDWR and O_EXCL, which has the benefit where
>> if you have multiple block devices, you know *which* block device had
>> a problem with being grabbed for an exclusive open.
>=20
> Would that mean then that doing:
>=20
>    mount /dev/sda3 /a
>    mount /dev/sda3 /b
>=20
> would then fail on the second command because /dev/sda3 is already open
> exclusively?
>=20

I tend to think that this *should* fail using the new API.  The semantics of=
 the second mount request are bizarre at best.=
