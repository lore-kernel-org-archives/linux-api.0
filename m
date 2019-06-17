From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
Date: Mon, 17 Jun 2019 10:49:44 -0700
Message-ID: <CAHk-=wjCwnk0nfgCcMYqqX6o9bBrutDtut_fzZ-2VwiZR1y4kw@mail.gmail.com>
References: <20190319165123.3967889-1-arnd@arndb.de> <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
 <87tvd2j9ye.fsf@oldenburg2.str.redhat.com> <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
 <871s05fd8o.fsf@oldenburg2.str.redhat.com> <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
 <87sgs8igfj.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87sgs8igfj.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Joseph Myers <joseph@codesourcery.com>, Arnd Bergmann <arnd@arndb.de>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Laura Abbott <labbott@redhat.com>, Paul Burton <pburton@wavecomp.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 17, 2019 at 4:45 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> I wanted to introduce a new header, <asm/kernel_long_t.h>, and include
> it where the definition of __kernel_long_t is needed, something like
> this (incomplete, untested):

So this doesn't look interesting to me: __kernel_long_t is neither
interesting as a type anyway (it's just a way for user space to
override "long"), nor is it a namespace violation.

So honestly, user space could do whatever it wants for __kernel_long_t anyway.

The thing that I think we should try to fix is just the "val[]" thing, ie

> A different approach would rename <asm/posix_types.h> to something more
> basic, exclude the two structs, and move all internal #includes which do
> need the structs to the new header.

In fact, I wouldn't even rename <posix_types.h> at all, I'd just make
sure it's namespace-clean.

I _think_ the only thing causing problems is  '__kernel_fsid_t' due to
that "val[]" thing, so just remove ity entirely, and add it to
<statfs.h> instead.

And yeah, then we'd need to maybe make sure that the (couple) of
__kernel_fsid_t users properly include that statfs.h file.

Hmm?

               Linus
