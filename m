From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Wed, 4 Feb 2015 15:03:09 -0800
Message-ID: <CALCETrXVDWJOvOTeTwCqrF6sn8e8XQfZSUbgg6hRnv+h-eX1Uw@mail.gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com>
 <54BFDAAA.50203@zonque.org> <54C0CE8A.5080805@gmail.com> <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com>
 <54C10DDC.9000503@gmail.com> <20150123160854.GA5210@kroah.com>
 <54C65346.5070504@gmail.com> <CANq1E4SkHhs1pWUe-TzG7bzk1M-Q++mB2vmQGuYx0RMF53wg4Q@mail.gmail.com>
 <CALCETrU1O6LjhrXSH2aXWFt2WGh=ssrq4K9HD10f_Z55iT=Otw@mail.gmail.com>
 <54C9F525.4040703@zonque.org> <CALCETrV6P+Lx5FRLyDNubG18tqCTLprkXJf=82aa5DsRHjkuKA@mail.gmail.com>
 <54CA1CA2.9060005@zonque.org> <CALCETrXD41=ohFSkCmBD8zPHFVUtr49QXMhYnChAxqQtmUjJYw@mail.gmail.com>
 <54CF44B9.8000005@zonque.org> <CALCETrUh1Mse4CBQ4bfkJf+ew=kdpn46hMLS2QafLhfRTzQoBQ@mail.gmail.com>
 <54D09E6B.2020903@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D09E6B.2020903-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 3, 2015 at 2:09 AM, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org> wrote:
> Hi Andy,
>
> On 02/02/2015 09:12 PM, Andy Lutomirski wrote:
>> On Feb 2, 2015 1:34 AM, "Daniel Mack" <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org> wrote:
>
>>> That's right, but again - if an application wants to gather this kind of
>>> information about tasks it interacts with, it can do so today by looking
>>> at /proc or similar sources. Desktop machines do exactly that already,
>>> and the kernel code executed in such cases very much resembles that in
>>> metadata.c, and is certainly not cheaper. kdbus just makes such
>>> information more accessible when requested. Which information is
>>> collected is defined by bit-masks on both the sender and the receiver
>>> connection, and most applications will effectively only use a very
>>> limited set by default if they go through one of the more high-level
>>> libraries.
>>
>> I should rephrase a bit.  Kdbus doesn't require use of send-time
>> metadata.  It does, however, strongly encourage it, and it sounds like
>
> On the kernel level, kdbus just *offers* that, just like sockets offer
> SO_PASSCRED. On the userland level, kdbus helps applications get that
> information race-free, easier and faster than they would otherwise.
>
>> systemd and other major users will use send-time metadata.  Once that
>> happens, it's ABI (even if it's purely in userspace), and changing it
>> is asking for security holes to pop up.  So you'll be mostly stuck
>> with it.
>
> We know we can't break the ABI. At most, we could deprecate item types
> and introduce new ones, but we want to avoid that by all means of
> course. However, I fail to see how that is related to send time
> metadata, or even to kdbus in general, as all ABIs have to be kept stable.
>
>> Do you have some simple benchmark code you can share?  I'd like to
>> play with it a bit.
>
> Sure, it's part of the self-test suite. Call it with "-t benchmark" to
> run the benchmark as isolated test with verbose output. The code for
> that lives in test-benchmark.c.

I see "latencies" of around 20 microseconds with lockdep and context
tracking off.  For example:

stats  (UNIX): 226730 packets processed, latency (nsecs) min/max/avg
 3845 //   34828 //    4069
stats (KDBUS): 37103 packets processed, latency (nsecs) min/max/avg
19123 //   99660 //   20696

This is IMO not very good.  With memfds off:

stats  (UNIX): 226061 packets processed, latency (nsecs) min/max/avg
 3885 //   32019 //    4079
stats (KDBUS): 83284 packets processed, latency (nsecs) min/max/avg
10525 //   42578 //   10932

With memfds off and the payload set to 8 bytes:

stats (KDBUS): 77669 packets processed, latency (nsecs) min/max/avg
9963 //   64325 //   11645
stats  (UNIX): 253695 packets processed, latency (nsecs) min/max/avg
 2986 //   56094 //    3565

Am I missing something here?  This is slow enough that a lightweight
userspace dbus daemon should be able to outperform kdbus, or at least
come very close.

It would be kind of nice to know how long just the send call takes, too.

--Andy
