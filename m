From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
Date: Mon, 17 Jun 2019 20:19:48 +0200
Message-ID: <87a7egdqgr.fsf@oldenburg2.str.redhat.com>
References: <20190319165123.3967889-1-arnd@arndb.de>
        <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
        <87tvd2j9ye.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
        <871s05fd8o.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wg4ijSoPq-w7ct_VuZvgHx+tUv_QX-We-62dEwK+AOf2w@mail.gmail.com>
        <87sgs8igfj.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wjCwnk0nfgCcMYqqX6o9bBrutDtut_fzZ-2VwiZR1y4kw@mail.gmail.com>
        <87k1dkdr9c.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wgiZNERDN7p-bsCzzYGRjeqTQw7kJxJnXAHVjqqO8PGrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wgiZNERDN7p-bsCzzYGRjeqTQw7kJxJnXAHVjqqO8PGrg@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 17 Jun 2019 11:13:20 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joseph Myers <joseph@codesourcery.com>, Arnd Bergmann <arnd@arndb.de>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Laura Abbott <labbott@redhat.com>, Paul Burton <pburton@wavecomp.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Linus Torvalds:

> On Mon, Jun 17, 2019 at 11:03 AM Florian Weimer <fweimer@redhat.com> wrote:
>>
>> There's also __kernel_fd_set in <linux/posix_types.h>.  I may have
>> lumped this up with <asm/posix_types.h>, but it has the same problem.
>
> Hmm.
>
> That one we might be able to just fix by renaming "fds_bits" to "__fds_bits".
>
> Unlike the "val[]" thing, I don't think anybody is supposed to access
> those fields directly.

Well, glibc already calls it __val …

> I think fd_set and friends are now supposed to be in <sys/select.h>
> anyway, and the "it was in <sys/types.h>" is all legacy.

Do you suggest to create a <linux/select.h> header to mirror this?

Thanks,
Florian
