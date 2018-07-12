From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 17:00:31 +0100
Message-ID: <20180712160030.GV30522@ZenIV.linux.org.uk>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
 <22370.1531293761@warthog.procyon.org.uk>
 <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <7002.1531407244@warthog.procyon.org.uk>
 <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Andrew Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 08:50:46AM -0700, Linus Torvalds wrote:

> But "write()" simply is *NOT* a good "command" interface. If you want
> to send a command, use an ioctl or a system call.
> 
> Because it's not just about credentials. It's not just about fooling a
> suid app into writing an error message to a descriptor you wrote. It's
> also about things like "splice()", which can write to your target
> using a kernel buffer, and thus trick you into doing a command while
> we have the context set to kernel addresses.

Wait a sec - that's only a problem if your command contains pointer-chasing
et.al.  Which is why e.g. /dev/sg is fucked in head.  But for something that
is plain text, what's the problem with splice/write/sendmsg/whatever?

I'm not talking about this particular interface, but "write is bad for
commands" as general policy looks missing the point.  If anything, it's
pointer-chasing crap that should be banned everywhere.  Just look at SG_IO -
it's a ioctl, and it's absolute garbage...
