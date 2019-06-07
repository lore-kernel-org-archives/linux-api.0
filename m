From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
Date: Fri, 07 Jun 2019 20:43:03 +0200
Message-ID: <871s05fd8o.fsf@oldenburg2.str.redhat.com>
References: <20190319165123.3967889-1-arnd@arndb.de>
        <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
        <87tvd2j9ye.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
        (Linus Torvalds's message of "Fri, 7 Jun 2019 11:27:57 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joseph Myers <joseph@codesourcery.com>, Arnd Bergmann <arnd@arndb.de>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Laura Abbott <labbott@redhat.com>, Paul Burton <pburton@wavecomp.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Linus Torvalds:

> If we're changing kernel header files, it's easy enough to change the
> kernel users. I'd be more worried about user space that *uses* that
> thing, and currently accesses 'val[]' by name.
>
> So the patch looks a bit odd to me. How are people supposed to use
> fsid_t if they can't look at it?

The problem is that the header was previously not used pervasively in
userspace headers.  See commit a623a7a1a5670c25a16881f5078072d272d96b71
("y2038: fix socket.h header inclusion").  Very little code needed it
before.

On the glibc side, we nowadays deal with this by splitting headers
further.  (We used to suppress definitions with macros, but that tended
to become convoluted.)  In this case, moving the definition of
__kernel_long_t to its own header, so that
include/uapi/asm-generic/socket.h can include that should fix it.

> So now that I _do_ see the patch, there's no way I'll apply it.

Fair enough.

Thanks,
Florian
