From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Tue, 10 Jul 2018 18:33:16 -0700
Message-ID: <CALCETrXWZJfBq-HnQ0vnGUBsDW75d4XFp1aQfTSqrFobQtFfbQ@mail.gmail.com>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <CA+55aFzknfBLjg4-pRSCUeBFY3DWq04zX3PPyc949M0OygHktw@mail.gmail.com>
 <20180711011520.GL30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711011520.GL30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 10, 2018 at 6:15 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Jul 10, 2018 at 06:05:49PM -0700, Linus Torvalds wrote:
>> Yeah, Andy is right that we should *not* make "write()" have side effect=
s.
>>
>> Use it to queue things by all means, but not "do" things. Not unless
>> there's a very sane security model.
>>
>> On Tue, Jul 10, 2018 at 4:59 PM Andy Lutomirski <luto@amacapital.net> wr=
ote:
>> >
>> > I think the right solution is one of:
>> >
>> > (a) Pass a netlink-formatted blob to fsopen() and do the whole thing i=
n one syscall. I don=E2=80=99t mean using netlink sockets =E2=80=94 just th=
e nlattr format.  Or you could use a different format. The part that matter=
s is using just one syscall to do the whole thing.
>>
>> Please no. Not another nasty marshalling thing.
>>
>> > (b) Keep the current structure but use a new syscall instead of write(=
).
>> >
>> > (c) Keep using write() but literally just buffer the data. Then have a=
 new syscall to commit it.  In other words, replace =E2=80=9Cx=E2=80=9D wit=
h a syscall and call all the fs_context_operations helpers in that context =
instead of from write().
>>
>> But yeah, b-or-c sounds fine.
>
> Umm...  How about "use credentials of opener for everything"?

If you want to audit every single filesystem for any code that uses
credentials for anything and add all the right kernel APIs and make
sure the filesystem uses them and somehow keep screwups from getting
added down the line, then okay I guess.  As far as I know, we don't
even *have* an API for "open this device node using this struct cred
*".

I kind of want to add a hack to set some poison bit in current->cred
in sys_write() and clear it on the way out.  Sigh.

--Andy
