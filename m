From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
Date: Mon, 17 Jun 2019 20:02:39 +0200
Message-ID: <87k1dkdr9c.fsf@oldenburg2.str.redhat.com>
References: <20190319165123.3967889-1-arnd@arndb.de>
        <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
        <87tvd2j9ye.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
        <871s05fd8o.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
        <87sgs8igfj.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wjCwnk0nfgCcMYqqX6o9bBrutDtut_fzZ-2VwiZR1y4kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wjCwnk0nfgCcMYqqX6o9bBrutDtut_fzZ-2VwiZR1y4kw@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 17 Jun 2019 10:49:44 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joseph Myers <joseph@codesourcery.com>, Arnd Bergmann <arnd@arndb.de>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Laura Abbott <labbott@redhat.com>, Paul Burton <pburton@wavecomp.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Linus Torvalds:

>> A different approach would rename <asm/posix_types.h> to something more
>> basic, exclude the two structs, and move all internal #includes which do
>> need the structs to the new header.
>
> In fact, I wouldn't even rename <posix_types.h> at all, I'd just make
> sure it's namespace-clean.
>
> I _think_ the only thing causing problems is  '__kernel_fsid_t' due to
> that "val[]" thing, so just remove ity entirely, and add it to
> <statfs.h> instead.

There's also __kernel_fd_set in <linux/posix_types.h>.  I may have
lumped this up with <asm/posix_types.h>, but it has the same problem.

If it's okay to move them both to more natural places (maybe
<asm/statfs.h> and <linux/socket.h>), I think that should work well for
glibc.

However, application code may have to include additional header files.
I think the GCC/LLVM sanitizers currently get __kernel_fd_set from
<linux/posix_types.h> (but I think we discussed it before, they really
shouldn't use this type because it's misleading).

Thanks,
Florian
