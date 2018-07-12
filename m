From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 14:40:49 -0700
Message-ID: <CA+55aFw7ACqm4fzG_52xTR3B-MqB0hLvcprgjm3jayPDDn6=-A@mail.gmail.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk>
 <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <7002.1531407244@warthog.procyon.org.uk> <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
 <16699.1531426991@warthog.procyon.org.uk> <CA+55aFw1WyKY+-2dg62M-QT_F0-waCTCrba1DW4dStYz-f_fjA@mail.gmail.com>
 <18233.1531430797@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18233.1531430797@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 2:26 PM David Howells <dhowells@redhat.com> wrote:
>
> The problem is that there's more than one actual "open" involved.

No. The problem is "write()".

This is not about open, about fsopen, or about anything at all.

This is about the fact that "write()" by definition can happen in a
different - and unexpected - context. Whether that be due to suid or
due to splice, or due to any other random issue is entirely
immaterial.

(The same is true of "read()" too, but very few people try to make
"read()" have side effects, so it's less of an issue. It does happen,
though).

But once you have another interface than "read/write()", the issues go
away. Those other interfaces are synchronous, and now you can decide
"ok, I'll just use current creds".

>  (1) Pass the creds from ->get_tree() all the way down into pathwalk and make
>      sure *every* check that pathwalk does uses it.

No. See above.

If your write() does anything but buffering data, it's not getting merged.

>  (2) When do_the_create_thing() is invoked, it wraps the call to ->get_tree()
>      with override_creds(file->f_cred).

No.

We do not wrap creds in any case. It's just asking for *another* kind
of security issue, where you fool some higher-security thing into
giving you access because it wrapped the higher-security case instead.

>  (3) Forget using an fd to refer to the context.  fsopen() takes absolutely
>      everything, perhaps as a kv array and spits out an O_PATH fd.

That works.

Or you know - do what I told you to do ALL THE TIME, which was to not
use write(), or to only buffer things with write().

But yes, any option that simply avoids read and write is fine.

You can even have a file descriptor. We already have file descriptors
that cannot be read from or written to. It's quite common for special
devices, the whole "open /dev/floppy with O_NONBLOCK only to be able
to do control operations with it" goes back to pretty much day #1.

More recently, we have the whole "FMODE_PATH" kind of file descriptor,
which works as a directory entry, but not for read and write.

So file descriptors can have very useful properties.

But no. We do not use "write()" to implement actions. If you think you
need to check permissions and think you need a "cred", then you're not
using write(). It really is that simple.

Not using write just avouds *all* the problems. If you can fool a suid
application to do arbitrary system calls for you, then it's not the
system call that is the security problem.

                Linus
