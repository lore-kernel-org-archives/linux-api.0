From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Wed, 11 Jul 2018 09:42:34 +0100
Message-ID: <24347.1531298554@warthog.procyon.org.uk>
References: <CA+55aFzknfBLjg4-pRSCUeBFY3DWq04zX3PPyc949M0OygHktw@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzknfBLjg4-pRSCUeBFY3DWq04zX3PPyc949M0OygHktw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Yeah, Andy is right that we should *not* make "write()" have side effects.

Note that write() has side effects all over the place: procfs, sysfs, debugfs,
tracefs, ...  Though for the most part they're single-shot jobs and not
cumulative (I'm not sure this is always true for debugfs - there's a lot of
weird stuff in there).

> > (b) Keep the current structure but use a new syscall instead of write().
> >
> > (c) Keep using write() but literally just buffer the data. Then have a new
> > syscall to commit it.  In other words, replace “x” with a syscall and call
> > all the fs_context_operations helpers in that context instead of from
> > write().
> 
> But yeah, b-or-c sounds fine.

I would prefer to avoid the "let's buffer everything" but rather parse the
data as we go along.  What I currently do is store the parsed data in the
context and only actually *apply* it when someone sends the 'x' command.

There are two reasons for this:

 (1) mount()'s error handling is slight: it can only return an error code, but
     creating and mounting something has so many different and interesting
     ways of going wrong and I want to be able to give better error reporting.

     This gets more interesting if it happens inside a container where you
     can't see dmesg.

 (2) Parsing the data means you only need to store the result of the parse and
     can reject anything that's unknown or contradictory.

     Buffering till the end means you have to buffer *everything* - and,
     unless you limit your buffer, you risk running out of RAM.

Now, I can replace the 'x' command with an ioctl() so that just writing random
rubbish to the fd won't cause anything to actually happen.

	fd = fsopen("ext4");
	write(fd, "s /dev/sda1");
	write(fd, "o user_xattr");
	ioctl(fd, FSOPEN_IOC_CREATE_SB, 0);

or I could make a special syscall for it:

	fscommit(fd, FSCOMMIT_CREATE);

or:

	fscommit(fd, FSCOMMIT_RECONFIGURE);

and require that you have CAP_SYS_ADMIN to enact it.

David
