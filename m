From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 09:39:31 -0700
Message-ID: <CA+55aFz6Uaqag5qPcT2M3Q07-yc_6y2cAarfw7hjXEiQq4tTYw@mail.gmail.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk>
 <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <7002.1531407244@warthog.procyon.org.uk> <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
 <20180712160030.GV30522@ZenIV.linux.org.uk> <CA+55aFwkiFdhGmT8gaSohAQGMWpGUZBQ0dhGNGWEN4cpjK7XHA@mail.gmail.com>
 <20180712163107.GW30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180712163107.GW30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Andrew Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 9:31 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> And seriously, ioctl? _That_ has a great track record...

I agree that a system call is likely saner. Especially since we'd have
one to _start_ this (ie "fsopen()") it would make sense to have the
one to finalize it.

> [1] one man's data is another man's commands, for starters.  All networking
> protocols would fit your description.  So would ANSI escape sequences ("move
> cursor to line 12 column 45" does sound like a command), so would writing
> postscript to printer, etc.

.. and all of that is just data to the kernel.

Yes, vt100 escape sequences etc _are_ commands, and boy have we had
bugs in that area. But there the excuse is "that's how the world is".

The thing is, "reality" is the ultimate argument. You can't argue with
cold hard facts.

But when designing a new interface that doesn't have that kind of
constraints, do it right.

> IME it's more about data structures that are not marshalled cleanly - that
> tends to go badly wrong.  Again, see SG_IO for recent example...

SG_IO actually gets it right. It doesn't do async, but that's part of
the design (and a big part of why it's a lot simpler - the read-write
thing is actually broken too and just forces user space to basically
know SCSI).

              Linus
