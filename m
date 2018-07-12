From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 17:41:10 +0100
Message-ID: <20180712164110.GX30522@ZenIV.linux.org.uk>
References: <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
 <22370.1531293761@warthog.procyon.org.uk>
 <7002.1531407244@warthog.procyon.org.uk>
 <338BC3C4-F3E7-48F0-A82E-2C7295B6640E@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <338BC3C4-F3E7-48F0-A82E-2C7295B6640E@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, tycho@tycho.ws
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 09:23:22AM -0700, Andy Lutomirski wrote:

> If you make a syscall that attaches a block device to an fscontext, you don’t need any of this.  Heck, someone might actually *want* to grab a block device from a different namespace.

Fuck, NO.  The whole notion of "block device of filesystem" is fucking
garbage.  It's up to filesystem driver whether it uses any block
devices.  For backing store or otherwise.  Single or multiple.  Moreover,
it's up to filesystem driver whether it cares if backing store is
a block device, or mtd device, or...

Repeat after me: syscall that attaches a block device to an fscontext
makes as much sense as a syscall that attaches a charset name to the
same.  With a special syscall for attaching a timestamp granularity,
and another for selecting GID semantics on subdirectory creation.

Commit vs. write separation is one thing; fuckloads of special syscalls
for passing vaguely defined classes of mount options (which device
name *is*) is quite different.
