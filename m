From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
Date: Tue, 18 Jun 2019 09:44:38 +0200
Message-ID: <87lfxzbamx.fsf@oldenburg2.str.redhat.com>
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
        <87a7egdqgr.fsf@oldenburg2.str.redhat.com>
        <CAHk-=wjF6ek4v04w2O3CuOaauDERfdyduW+h=u9uN5ja1ObLzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wjF6ek4v04w2O3CuOaauDERfdyduW+h=u9uN5ja1ObLzQ@mail.gmail.com>
        (Linus Torvalds's message of "Mon, 17 Jun 2019 11:48:47 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joseph Myers <joseph@codesourcery.com>, Arnd Bergmann <arnd@arndb.de>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Laura Abbott <labbott@redhat.com>, Paul Burton <pburton@wavecomp.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Linus Torvalds:

> On Mon, Jun 17, 2019 at 11:19 AM Florian Weimer <fweimer@redhat.com> wrote:
>> >
>> > Unlike the "val[]" thing, I don't think anybody is supposed to access
>> > those fields directly.
>>
>> Well, glibc already calls it __val …
>
> Hmm. If user space already doesn't see the "val[]" array anyway, I
> guess we could just do that in the kernel too.
>
> Looking at the glibc headers I have for fds_bits, glibc seems to do
> *both* fds_bits[] and __fds_bits[] depending on __USE_XOPEN or not.
>
> Anyway, that all implies to me that we might as well just go the truly
> mindless way, and just do the double underscores and not bother with
> renaming any files.
>
> I thought people actually might care about the "val[]" name because I
> find that in documentation, but since apparently it's already not
> visible to user space anyway, that can't be true.
>
> I guess that makes the original patch acceptable, and we should just
> do the same thing to fds_bits..

Hah.

I think Arnd's original patch already had both.  So it's ready to go in
after all?

Thanks,
Florian
