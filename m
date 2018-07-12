From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Thu, 12 Jul 2018 10:14:05 -0700
Message-ID: <CA+55aFw9WuyGqRHerhESw+Shzg1UtCjORLVYT=uCMh8jXbLWmg@mail.gmail.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk>
 <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <7002.1531407244@warthog.procyon.org.uk> <CA+55aFx+xm333ZZ7d2Z39QuhDu=0XM6nTMChbHvWQOXNk32yxw@mail.gmail.com>
 <20180712160030.GV30522@ZenIV.linux.org.uk> <CA+55aFwkiFdhGmT8gaSohAQGMWpGUZBQ0dhGNGWEN4cpjK7XHA@mail.gmail.com>
 <20180712163107.GW30522@ZenIV.linux.org.uk> <CA+55aFz6Uaqag5qPcT2M3Q07-yc_6y2cAarfw7hjXEiQq4tTYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFz6Uaqag5qPcT2M3Q07-yc_6y2cAarfw7hjXEiQq4tTYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Andrew Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 9:39 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I agree that a system call is likely saner. Especially since we'd have
> one to _start_ this (ie "fsopen()") it would make sense to have the
> one to finalize it.

Side note: if we can make do with just a buffer, then we wouldn't need
"fsopen()". You could literally just open a pipe, and write to it.
It's got 16 pages worth of buffers by default, and you can increase it
(within reason) as root.

Of course, depending on IO patterns, not all the buffer pages are
necessarily fully used, so it's not like you get a buffer of size
PAGE_SIZE*16, but we do merge buffers so you should be fairly close.

Then you really could do without a fsopen(). Just fill a pipe with
data, and do "fsmount()" on the pipe contents.

Added upside? You can use "iov_iter_pipe()" to iterate over all that data.

I'm only half joking.

            Linus
