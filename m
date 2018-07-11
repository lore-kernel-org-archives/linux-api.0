From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for superblock creation [ver #9]
Date: Wed, 11 Jul 2018 09:43:21 +0100
Message-ID: <24376.1531298601@warthog.procyon.org.uk>
References: <CALCETrXWZJfBq-HnQ0vnGUBsDW75d4XFp1aQfTSqrFobQtFfbQ@mail.gmail.com> <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk> <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <CA+55aFzknfBLjg4-pRSCUeBFY3DWq04zX3PPyc949M0OygHktw@mail.gmail.com> <20180711011520.GL30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXWZJfBq-HnQ0vnGUBsDW75d4XFp1aQfTSqrFobQtFfbQ@mail.gmail.com>
Content-ID: <24375.1531298601.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> wrote:

> > Umm...  How about "use credentials of opener for everything"?
> 
> If you want to audit every single filesystem for any code that uses
> credentials for anything and add all the right kernel APIs and make
> sure the filesystem uses them and somehow keep screwups from getting
> added down the line, then okay I guess.  As far as I know, we don't
> even *have* an API for "open this device node using this struct cred
> *".

You can use override_creds() too.

David
