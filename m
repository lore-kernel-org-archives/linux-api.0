From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 17:58:21 +0100
Message-ID: <20180712165821.GY30522@ZenIV.linux.org.uk>
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
 
> As a straw man, I suggest:
> 
> fsconfigure(contextfd, ADD_BLOCKDEV, dfd, path, flags);
> 
> fsconfigure(contextfd, ADD_OPTION, 0, “foo=bar”, flags);

Bollocks.  First of all, block device *IS* a fucking option.
Always had been.  It's not even that it's passed as a separate
argument for historical reasons - just look at NFS.  That argument
is a detached part of options, parsed (yes, *parsed*) by filesystem
in question in whatever way it prefers.

Look at the things like e.g. cramfs.  That argument is interpreted
as pathname of block device.  Or that of mtd device.  Or the magic
string "mtd" followed by mtd number.

What's more, filesystems can and do live on more than one device.
Like e.g. btrfs.  Or like something journalled with the journal
on separate device.  So you do *NOT* get away from the need to
open stuff while doing mount - not unless you introduce arseloads
of ADD_... shite in your scheme.  And create a huge centralized
pile of code dealing with it.  ADD_NFS_IPV4_SERVER_AND_PATH, etc.?

You can't avoid parsing stuff.  It's one thing to argue at which
*point* you prefer doing that, but it has to be done kernel-side.
Format of filesystem options is fundamentally up to filesystem,
whichever syscall you use.
