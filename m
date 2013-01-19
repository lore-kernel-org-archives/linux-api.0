From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/3] signalfd: add ability to return siginfo in a raw
 format (v2)
Date: Sun, 20 Jan 2013 00:27:09 +0100
Message-ID: <CAKgNAkjK9iWh_PuJ92A-MKW6Q6_B8DvTL5-fkxyULqx9ZoDPfg@mail.gmail.com>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
 <1358182435-19245-3-git-send-email-avagin@openvz.org> <20130116123502.70af6b85.akpm@linux-foundation.org>
 <CAKgNAkgHVB3=k_XOevobcMWuEqy2r75tdTc85ZYiD8rkn5OZKA@mail.gmail.com> <CANaxB-wXdPZFzD3BhkD6niDA6M1NiNrc5coKf9bSx+ar_fZecg@mail.gmail.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CANaxB-wXdPZFzD3BhkD6niDA6M1NiNrc5coKf9bSx+ar_fZecg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrey Wagin <avagin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

Hello Andrey,

On Sat, Jan 19, 2013 at 11:50 AM, Andrey Wagin <avagin@gmail.com> wrote:
> 2013/1/19 Michael Kerrisk (man-pages) <mtk.manpages@gmail.com>:
>>> As SFD_RAW is being added to the kernel API we should document it.
>>> Please keep Michael cc'ed and work with him on getting the manpages
>>> updated.
>>
>> The API is certainly no thing of beauty, as I already remarked here:
>> http://thread.gmane.org/gmane.linux.file-systems/70420/focus=1420228
>
> All of us have similar thoughts, but we don't know a better solution.
>
> Here is an example of usage signalfd and pread:
> http://lists.openvz.org/pipermail/criu/2013-January/007040.html
>
>>
>> A description of the API can be found here:
>> https://lwn.net/Articles/531939/
>
> Thanks you for the attempt to involve more people to this discussion.
>
>>
>> The main problem is the ugliness of changing the meaning of pread()'s
>> 'offset' argument to be a multiplexed [signal queue selector + queue
>> position].
>>
>> I do wonder if we can do better, though I have no particular solution
>> to offer beyond the sledgehammer of adding a new system call.
>
> If we are choosing between this interface or a new syscall, I would
> prefer this interface.

A agree. That's why I called using a new syscall a sledgehammer.
Still, I just wanted to remind folk who might think of something
better.

> signalfd is a special descriptor, so I think it
> is not a big deal, that it works a bit strange.

Sure, but the more we special case things, the uglier the ABI as a
whole becomes. So special casing should be avoided as far as we can.

> If all other would
> decides, that a new syscall is better, I will not ague.

And that's more or less how I see it too. I'm not going to argue for a
new syscall, based on what I know so far.

Here is one idea to think about though, while more or less maintaining
your proposed interface.

At the moment, you select signal queues in the pread() call. An
alternative would be to do it in the signalfd() call. In other words,
you could have the following flags used with signalfd()

SFD_RAW
SFD_SHARED_QUEUE -- reads will be from process-wide shared signal queue
SFD_PER_THREAD_QUEUE --reads will be from per-thread signal queue

Specifying both SFD_SHARED_QUEUE  and SFD_PER_THREAD_QUEUE would be
the same as omitting them both, providing the default behavior of
slecting from both queues.

My point here is that you can then separate the RAW functionality from
the queue selector functionality. Now, it might be that at the moment
you always require that if the caller specifies SFD_SHARED_QUEUE  or
SFD_PER_THREAD_QUEUE, then they must also specify SFD_RAW. But later,
that constraint might be relaxed, so that users could use signalfd()
to select from a particular queue when reading traditional (non-RAW)
signalfd_siginfo structures from a signalfd. This does seem like a
very sensible design optimization to make now (and an easy one, I
would suppose). What do you think?

Cheers,

Michael
