From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Tue, 10 Jul 2018 18:05:49 -0700
Message-ID: <CA+55aFzknfBLjg4-pRSCUeBFY3DWq04zX3PPyc949M0OygHktw@mail.gmail.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk> <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

Yeah, Andy is right that we should *not* make "write()" have side effects.

Use it to queue things by all means, but not "do" things. Not unless
there's a very sane security model.

On Tue, Jul 10, 2018 at 4:59 PM Andy Lutomirski <luto@amacapital.net> wrote=
:
>
> I think the right solution is one of:
>
> (a) Pass a netlink-formatted blob to fsopen() and do the whole thing in o=
ne syscall. I don=E2=80=99t mean using netlink sockets =E2=80=94 just the n=
lattr format.  Or you could use a different format. The part that matters i=
s using just one syscall to do the whole thing.

Please no. Not another nasty marshalling thing.

> (b) Keep the current structure but use a new syscall instead of write().
>
> (c) Keep using write() but literally just buffer the data. Then have a ne=
w syscall to commit it.  In other words, replace =E2=80=9Cx=E2=80=9D with a=
 syscall and call all the fs_context_operations helpers in that context ins=
tead of from write().

But yeah, b-or-c sounds fine.

               Linus
