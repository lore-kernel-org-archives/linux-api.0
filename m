From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 18:44:03 +0100
Message-ID: <20180712174403.GA30522@ZenIV.linux.org.uk>
References: <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
 <22370.1531293761@warthog.procyon.org.uk>
 <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <7002.1531407244@warthog.procyon.org.uk>
 <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
 <20180712160030.GV30522@ZenIV.linux.org.uk>
 <CA+55aFwkiFdhGmT8gaSohAQGMWpGUZBQ0dhGNGWEN4cpjK7XHA@mail.gmail.com>
 <20180712163107.GW30522@ZenIV.linux.org.uk>
 <CA+55aFz6Uaqag5qPcT2M3Q07-yc_6y2cAarfw7hjXEiQq4tTYw@mail.gmail.com>
 <CA+55aFw9WuyGqRHerhESw+Shzg1UtCjORLVYT=uCMh8jXbLWmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFw9WuyGqRHerhESw+Shzg1UtCjORLVYT=uCMh8jXbLWmg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Andrew Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 10:14:05AM -0700, Linus Torvalds wrote:
> On Thu, Jul 12, 2018 at 9:39 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I agree that a system call is likely saner. Especially since we'd have
> > one to _start_ this (ie "fsopen()") it would make sense to have the
> > one to finalize it.
> 
> Side note: if we can make do with just a buffer, then we wouldn't need
> "fsopen()". You could literally just open a pipe, and write to it.
> It's got 16 pages worth of buffers by default, and you can increase it
> (within reason) as root.
> 
> Of course, depending on IO patterns, not all the buffer pages are
> necessarily fully used, so it's not like you get a buffer of size
> PAGE_SIZE*16, but we do merge buffers so you should be fairly close.
> 
> Then you really could do without a fsopen(). Just fill a pipe with
> data, and do "fsmount()" on the pipe contents.
> 
> Added upside? You can use "iov_iter_pipe()" to iterate over all that data.
> 
> I'm only half joking.

One semi-historical note here.

Originally, mount(2) (and it had been there since v1) had only one filesystem
type to deal with.  So it was really just "mount <block device pathname> on
<mountpoint pathname>, read-only or read-write".  3 arguments, two strings and
one flag (flag, BTW, was a later addition).

It didn't last.  I can dig out the archaeological notes and cut'n'paste the
whole horror story here, but that'll be way too long and scary.

By 4.2BSD times there had been essentially an enum encoding the filesystem
type and type-tagged union of structs with type-dependent options.  Plus
some options taking more bits in what used to be "is it r/w?" flag.

Leaving aside the whole "mount new/bind/remount/etc." overloading we have
in mount(2) today, we have a bunch of named filesystems, each with its
own set of options.  Device name has ceased to be something special for
many decades; the type name is what's universally present and that's what
decides how the rest (including "device name") is to be interpreted.

Fundamentally, we start with selecting (by name) a filesystem driver we'll
be talking to.  The rest (device name + string options + flags like noexec
that are not handled on VFS level) is given to that driver, which either
tells us to take a hike or gives us a dentry tree that can be attached.

Separating type name from everything else makes a lot of sense, simply
because it's what determines the parsing and interpretation of the rest.
Speaking of half-joking, I suggested AF_FSTYPE at some point.  Then
fsopen(2) would be connect(2)...

I think that having that (connection used to talk to fs driver, with or
without an already set up fs instance we are talking about) as first-class
object makes sense.  That's completely unrelated to the question of buffering,
of course.
