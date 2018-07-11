From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Tue, 10 Jul 2018 18:48:30 -0700
Message-ID: <CA+55aFznwKKy0Vj4Wxe16=2EUmgas_Dcr9QQ1tOJOQOEAVfr+w@mail.gmail.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <CA+55aFzknfBLjg4-pRSCUeBFY3DWq04zX3PPyc949M0OygHktw@mail.gmail.com>
 <20180711011520.GL30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711011520.GL30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 10, 2018 at 6:15 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Umm...  How about "use credentials of opener for everything"?

yeah, we have that for writes in general.

Nobody ever actually follows that rule. They may *think* they do, and
then they call to some helper that does "capability(CAP_SYS_WHATEVAH)"
without even realizing it.

But I'm certainly ok with writes, if it's just filling a buffer.
Preferably a standard buffer we already have, like a seqfile or pipe
(hey, splice!) or whatever.

And then you have that final op to actually "commit" the state. Which
shouldn't be a write (and not the close).

           Linus
