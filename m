From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Wed, 11 Jul 2018 09:03:10 -0700
Message-ID: <CA+55aFzxMzz2+LRmE7_9y3SE7sz1dTz+ERYGdEcs-PYaWvf0XQ@mail.gmail.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <CA+55aFzknfBLjg4-pRSCUeBFY3DWq04zX3PPyc949M0OygHktw@mail.gmail.com>
 <24347.1531298554@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <24347.1531298554@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 11, 2018 at 1:42 AM David Howells <dhowells@redhat.com> wrote:
>
>      Buffering till the end means you have to buffer *everything* - and,
>      unless you limit your buffer, you risk running out of RAM

Do we really care?

Can't we limit the buffer size to something small?

Right now, the mount options can't be bigger than a page anyway. Why
would we want to extend on that?

Btw, the magic word here is "why". I really really want to see a
fairly exhaustive explanation of why this all is such a big deal, and
exactly what limitations (including perhaps the mount option buffer
size) are such a pain right now and need changing.

> Now, I can replace the 'x' command with an ioctl() so that just writing random
> rubbish to the fd won't cause anything to actually happen.
>
>         fd = fsopen("ext4");
>         write(fd, "s /dev/sda1");
>         write(fd, "o user_xattr");
>         ioctl(fd, FSOPEN_IOC_CREATE_SB, 0);
>
> or I could make a special syscall for it:
>
>         fscommit(fd, FSCOMMIT_CREATE);
>
> or:
>
>         fscommit(fd, FSCOMMIT_RECONFIGURE);
>
> and require that you have CAP_SYS_ADMIN to enact it.

I think any of them sound fairly ok, with that whole "we need reasons" caveat.

               Linus
