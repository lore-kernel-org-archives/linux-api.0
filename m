From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Thu, 12 Jul 2018 21:23:11 +0100
Message-ID: <16699.1531426991@warthog.procyon.org.uk>
References: <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk> <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <7002.1531407244@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
Content-ID: <16698.1531426991.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Don't play games with override_creds. It's wrong.
> 
> You have to use file->f_creds - no games, no garbage.

You missed the point.

It's all very well to say "use file->f_creds".  The problem is this has to be
handed down all the way through the filesystem and down into the block layer
as appropriate to anywhere there's an LSM call, a CAP_* check or a pathwalk -
but there's not currently any way to do that.

mount_bdev() and blkdev_get_by_path() are examples of this.  At the moment
there is no cred parameter there.  We'd also have to pass the creds down into
path_init() to store in struct nameidata and make sure that every permissions
call that might be invoked during pathwalk in every filesystem uses that, not
current_cred().

I made an attempt to do this a while ago and the patch got rather large before
I gave up.  In many ways, it's what we *should* do, but so many things need an
extra parameter...  If you really want, I can try that again.  It's possible I
can automate it with some perl scripting to parse the error messages from the
compiler.

My suggestion was to use override_creds() to impose the appropriate creds at
the top, be that file->f_creds or fs_context->creds (they would be the same in
any case).

If we want to go down the pass-the-creds-down route, then we can temporarily
do override_creds() until we've made the changes and then remove it later.

> But "write()" simply is *NOT* a good "command" interface. If you want
> to send a command, use an ioctl or a system call.

Okay.

> Because it's not just about credentials. It's not just about fooling a
> suid app into writing an error message to a descriptor you wrote. It's
> also about things like "splice()", which can write to your target
> using a kernel buffer, and thus trick you into doing a command while
> we have the context set to kernel addresses.
> 
> Are we trying to get away from that issue? Yes. But it's just another
> example of why "write()" IS NOT TO BE USED FOR COMMANDS.

Btw, do we protect sysfs, debugfs, tracefs, procfs, etc. writes against
splice?  Some of the things in debugfs are really icky, allowing you to muck
directly with hardware.

David
