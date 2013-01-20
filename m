From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [CRIU] [PATCH 2/3] signalfd: add ability to return siginfo in a
 raw format (v2)
Date: Sun, 20 Jan 2013 21:33:41 +0100
Message-ID: <CAKgNAkhcha9CkYHESqx72LyFB_xw7du=OU566Nk1LzHw+EnQQA@mail.gmail.com>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
 <1358182435-19245-3-git-send-email-avagin@openvz.org> <20130116123502.70af6b85.akpm@linux-foundation.org>
 <CAKgNAkgHVB3=k_XOevobcMWuEqy2r75tdTc85ZYiD8rkn5OZKA@mail.gmail.com>
 <CANaxB-wXdPZFzD3BhkD6niDA6M1NiNrc5coKf9bSx+ar_fZecg@mail.gmail.com>
 <CAKgNAkjK9iWh_PuJ92A-MKW6Q6_B8DvTL5-fkxyULqx9ZoDPfg@mail.gmail.com>
 <20130120174153.GA5675@paralelels.com> <20130120195555.GA14177@redhat.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130120195555.GA14177@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Vagin <avagin@parallels.com>, Andrey Wagin <avagin@gmail.com>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, criu@openvz.org, Cyrill Gorcunov <gorcunov@openvz.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-api@vger.kernel.org

Hi Oleg,

On Sun, Jan 20, 2013 at 8:55 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/20, Andrew Vagin wrote:
>>
>> > SFD_RAW
>> > SFD_SHARED_QUEUE -- reads will be from process-wide shared signal queue
>> > SFD_PER_THREAD_QUEUE --reads will be from per-thread signal queue
>>
>> I suggested this variant in the initial series, but then we decided to
>> avoid adding new flags.
>
> Yes, because SFD_SHARED/PRIVATE will add even more complications into this
> code. And outside of signalfd.c too. And nobody except c/r will ever use
> these features I guess.

So, I must admit that I don't understand why adding SFD_SHARED and
SFD_PER_THREAD in signalfd() makes things more complicated than adding
the equivalents in pread(). But, I'll take your word for that, if
that's what you meant.

However, note that I did suggest that in the initial implementation
you might require that if SFD_SHARED_QUEUE or SFD_PER_THREAD_QUEUE is
specified in signalfd(), then SFD_RAW could be required as well.
Later, if someone wants to do the work, they could relax the
constraint, so as to allow signalfd() to be used to do per-queue
select even when reading siginfo (i.e., SFD_SHARED_QUEUE or
SFD_PER_THREAD_QUEUE specified but not SFD_RAW). Surely that is not
more complicated than the current implementation. And it allows for an
orthogonal expansion of the design that seems more natural and may one
day be useful.

Cheers,

Michael
