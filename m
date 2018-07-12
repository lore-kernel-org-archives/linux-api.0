From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Thu, 12 Jul 2018 23:54:41 +0100
Message-ID: <22105.1531436081@warthog.procyon.org.uk>
References: <20180712223223.GA28610@thunk.org> <CA+55aFw1WyKY+-2dg62M-QT_F0-waCTCrba1DW4dStYz-f_fjA@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk> <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <7002.1531407244@warthog.procyon.org.uk> <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com> <16699.1531426991@warthog.procyon.org.uk> <18233.1531430797@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180712223223.GA28610@thunk.org>
Content-ID: <22104.1531436081.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

Theodore Y. Ts'o <tytso@mit.edu> wrote:

> So maybe the answer is that you open /dev/sda1 and /dev/sda2 and then
> pass the file descriptors to the fsopen object?  We can require that
> the fd's be opened with O_RDWR and O_EXCL, which has the benefit where
> if you have multiple block devices, you know *which* block device had
> a problem with being grabbed for an exclusive open.

Would that mean then that doing:

	mount /dev/sda3 /a
	mount /dev/sda3 /b

would then fail on the second command because /dev/sda3 is already open
exclusively?

David
