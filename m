From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Thu, 12 Jul 2018 15:54:04 +0100
Message-ID: <7002.1531407244@warthog.procyon.org.uk>
References: <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> wrote:

> > On Jul 11, 2018, at 12:22 AM, David Howells <dhowells@redhat.com> wrote:
> >
> > Andy Lutomirski <luto@amacapital.net> wrote:
> >
> >>>   sfd = fsopen("ext4", FSOPEN_CLOEXEC);
> >>>   write(sfd, "s /dev/sdb1"); // note I'm ignoring write's length arg
> >>
> >> Imagine some malicious program passes sfd as stdout to a setuid
> >> program. That program gets persuaded to write "s /etc/shadow".  What
> >> happens?  You’re okay as long as *every single fs* gets it right, but
> >> that’s asking a lot.
> >
> > Do note that you must already have CAP_SYS_ADMIN to be able to call
> > fsopen().
> 
> If you're not allowing it already, someone will want user namespace
> root to be able to use this very, very soon.

Yeah, I'm sure.  And I've been thinking on how to deal with it.

I think we *have* to open the source files/devices with the creds of whoever
called fsopen() or fspick() - that way you can't upgrade your privs by passing
your context fd to a suid program.  To enforce this, I think it's simplest for
fscontext_write() to call override_creds() right after taking the uapi_mutex
and then call revert_creds() right before dropping the mutex.

Another thing we might want to look at is to allow a supervisory process to
examine the context before permitting the create/reconfigure action to
proceed.  It might also be possible to do this through the LSM.

David
