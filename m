From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Wed, 11 Jul 2018 02:15:20 +0100
Message-ID: <20180711011520.GL30522@ZenIV.linux.org.uk>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
 <CA+55aFzknfBLjg4-pRSCUeBFY3DWq04zX3PPyc949M0OygHktw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFzknfBLjg4-pRSCUeBFY3DWq04zX3PPyc949M0OygHktw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 10, 2018 at 06:05:49PM -0700, Linus Torvalds wrote:
> Yeah, Andy is right that we should *not* make "write()" have side effects.
> 
> Use it to queue things by all means, but not "do" things. Not unless
> there's a very sane security model.
> 
> On Tue, Jul 10, 2018 at 4:59 PM Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > I think the right solution is one of:
> >
> > (a) Pass a netlink-formatted blob to fsopen() and do the whole thing in one syscall. I don’t mean using netlink sockets — just the nlattr format.  Or you could use a different format. The part that matters is using just one syscall to do the whole thing.
> 
> Please no. Not another nasty marshalling thing.
> 
> > (b) Keep the current structure but use a new syscall instead of write().
> >
> > (c) Keep using write() but literally just buffer the data. Then have a new syscall to commit it.  In other words, replace “x” with a syscall and call all the fs_context_operations helpers in that context instead of from write().
> 
> But yeah, b-or-c sounds fine.

Umm...  How about "use credentials of opener for everything"?
