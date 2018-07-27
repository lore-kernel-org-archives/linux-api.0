From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 30/38] vfs: syscall: Add fsmount() to create a mount for a superblock [ver #10]
Date: Fri, 27 Jul 2018 23:09:41 +0100
Message-ID: <9160.1532729381@warthog.procyon.org.uk>
References: <CALCETrVmZKeFv7b+c8hBQ-3Dcryv7VXTHdyWftvNG1G4aQk9Mw@mail.gmail.com> <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk> <153271288242.9458.18050138471208178879.stgit@warthog.procyon.org.uk> <D09916DC-DA22-48AA-A62B-F874BB3C15BC@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVmZKeFv7b+c8hBQ-3Dcryv7VXTHdyWftvNG1G4aQk9Mw@mail.gmail.com>
Content-ID: <9159.1532729381.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> int mfd = fsmount(...);
> 
> where you pass in an fscontext fd and get out an fd referring to the
> root of the filesystem?  In this case, maybe fs_open_root(2) would be
> a better name.

It's not necessarily the root of the filesystem in the sense of sb->s_root.
It might be a subset of that, or it might be a part of a filesystem that might
have multiple roots because it doesn't know where the real root is (NFS2, for
example).

> This *definitely* needs to be clearer in the description.

I'm open to suggestions of better wording.  It's a bit hard to explain
because, as you pointed out, the terminology is overloaded.

David
