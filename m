From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 08:50:46 -0700
Message-ID: <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk>
 <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com> <7002.1531407244@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7002.1531407244@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 7:54 AM David Howells <dhowells@redhat.com> wrote:
>
> I think we *have* to open the source files/devices with the creds of whoever
> called fsopen() or fspick() - that way you can't upgrade your privs by passing
> your context fd to a suid program.  To enforce this, I think it's simplest for
> fscontext_write() to call override_creds() right after taking the uapi_mutex
> and then call revert_creds() right before dropping the mutex.

No.

Don't play games with override_creds. It's wrong.

You have to use file->f_creds - no games, no garbage.

But "write()" simply is *NOT* a good "command" interface. If you want
to send a command, use an ioctl or a system call.

Because it's not just about credentials. It's not just about fooling a
suid app into writing an error message to a descriptor you wrote. It's
also about things like "splice()", which can write to your target
using a kernel buffer, and thus trick you into doing a command while
we have the context set to kernel addresses.

Are we trying to get away from that issue? Yes. But it's just another
example of why "write()" IS NOT TO BE USED FOR COMMANDS.

Only use write() for data.

That's final. We're not adding yet another clueless fuck-up of an
interface just because people cannot understand this very simple rule:
"write()" is for data, not for commands.

No more excuses.

                 Linus
