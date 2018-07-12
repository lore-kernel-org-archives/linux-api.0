From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 16:33:38 -0700
Message-ID: <CAG48ez1S6Gxtsf8OzH_dhLiPVeH=unsghjGJGL0oOoff+T0iRw@mail.gmail.com>
References: <CA+55aFw1WyKY+-2dg62M-QT_F0-waCTCrba1DW4dStYz-f_fjA@mail.gmail.com>
 <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk>
 <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <7002.1531407244@warthog.procyon.org.uk> <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
 <16699.1531426991@warthog.procyon.org.uk> <18233.1531430797@warthog.procyon.org.uk>
 <20180712223223.GA28610@thunk.org> <22105.1531436081@warthog.procyon.org.uk> <CAG48ez1OF0OfdmnRsV5Ne2mOt-j3Pgf7QRsn3q3Hzjpus9LHGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1OF0OfdmnRsV5Ne2mOt-j3Pgf7QRsn3q3Hzjpus9LHGA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 4:23 PM Jann Horn <jannh@google.com> wrote:
>
> On Thu, Jul 12, 2018 at 3:54 PM David Howells <dhowells@redhat.com> wrote:
> >
> > Theodore Y. Ts'o <tytso@mit.edu> wrote:
> >
> > > So maybe the answer is that you open /dev/sda1 and /dev/sda2 and then
> > > pass the file descriptors to the fsopen object?  We can require that
> > > the fd's be opened with O_RDWR and O_EXCL, which has the benefit where
> > > if you have multiple block devices, you know *which* block device had
> > > a problem with being grabbed for an exclusive open.
> >
> > Would that mean then that doing:
> >
> >         mount /dev/sda3 /a
> >         mount /dev/sda3 /b
> >
> > would then fail on the second command because /dev/sda3 is already open
> > exclusively?
>
> Not exactly. mount_bdev() uses FMODE_EXCL, which locks out parallel
> usage *with a different filesystem type*. This is the effect:
>
> # strace -e trace=mount mount -t vfat /dev/loop0 mount
> mount("/dev/loop0", "/home/jannh/tmp/x/mount", "vfat", MS_MGC_VAL, NULL) = 0
> +++ exited with 0 +++
> # strace -e trace=mount mount -t ext4 /dev/loop0 mount
> mount("/dev/loop0", "/home/jannh/tmp/x/mount", "ext4", MS_MGC_VAL,
> NULL) = -1 EBUSY (Device or resource busy)
> mount: /home/jannh/tmp/x/mount: /dev/loop0 already mounted on
> /home/jannh/tmp/x/mount.
> +++ exited with 32 +++
>
> I don't really understand why it's not more strict though...

Er, sorry, of course that's the current behavior, not the behavior of
the suggested API.
