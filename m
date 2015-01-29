From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Thu, 29 Jan 2015 09:53:57 +0100
Message-ID: <54C9F525.4040703@zonque.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com> <54BFDAAA.50203@zonque.org> <54C0CE8A.5080805@gmail.com> <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com> <54C10DDC.9000503@gmail.com> <20150123160854.GA5210@kroah.com> <54C65346.5070504@gmail.com> <CANq1E4SkHhs1pWUe-TzG7bzk1M-Q++mB2vmQGuYx0RMF53wg4Q@mail.gmail.com> <CALCETrU1O6LjhrXSH2aXWFt2WGh=ssrq4K9HD10f_Z55iT=Otw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrU1O6LjhrXSH2aXWFt2WGh=ssrq4K9HD10f_Z55iT=Otw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Theodore T'so <tytso-3s7WtUTddSA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andy,

On 01/27/2015 05:03 PM, Andy Lutomirski wrote:
> On Tue, Jan 27, 2015 at 7:05 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>> A 16byte copy does not affect the performance of kdbus message
>> transactions in any way that matters.

> What are the performance goals of kdbus?  How fast is it ever intended
> to be?

One of the design goals of kdbus is to speed up a typical D-Bus message
turnaround. That is, to minimize the number of context switches it
currently takes to get a message across the bus, and to avoid
unnecessary extra payload copies.

Even though I'm sure there's still room for future improvement, the
benchmark test we provided in the kernel self-tests shows that basic
data transmission performance is roughly comparable to that of UDS for
smaller payloads. For payloads of bigger sizes (>128kb), kdbus is
actually faster due to its zero-copy mechanism.

> The reason I ask is that, in the current design, kdbus
> collects "metadata" (credentials and other identifying information,
> collected in kdbus_meta_proc_collect) from the sender of every message
> *at send time*. [1]  This is slow, and it will always be slow.  The
> slowness of this operation will, in my personal system performance
> crystal ball, overshadow the cost of a 16 byte copy by several orders
> of magnitude.

That's certainly true, but that's not a contradiction to the performance
argument. Please keep in mind that if a receiving peer does not request
any metadata, the kernel doesn't collect and attach any. We know that
gathering of some of the metadata comes at a price, which is why we
split up the information is such fine-grained pieces.

Also note that if a receiving peer opts in for a certain piece of
metadata, it should do that that for a good reason, because it needs
that data to process a request. Letting kdbus do the work of providing
such information is still a lot faster than having the receiving peer
gather it itself, as that would involve more syscalls and more context
switches (let alone the fact that doing so is inherently racy, as
explained in earlier threads).

So, yes, collecting metadata can slow down message exchange, but after
all, that's an optional feature that has to be used with sense. I'll add
some words on that to the man-pages.


HTH,
Daniel
