From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Sun, 8 Feb 2015 08:54:42 -0800
Message-ID: <CALCETrWOhw+OKUBNaTDUcqmgc21LfZ4EZ5zJvL9vzGoMd4_TmQ@mail.gmail.com>
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
 <54D09E6B.2020903@zonque.org> <CALCETrXVDWJOvOTeTwCqrF6sn8e8XQfZSUbgg6hRnv+h-eX1Uw@mail.gmail.com>
 <CANq1E4ShseFuTp0wPrHM9mFmgA-y9Kqz1m0-FmU9qALuxQ8Qvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4ShseFuTp0wPrHM9mFmgA-y9Kqz1m0-FmU9qALuxQ8Qvg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Feb 4, 2015 4:16 PM, "David Herrmann" <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Hi
>
> On Thu, Feb 5, 2015 at 12:03 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> > I see "latencies" of around 20 microseconds with lockdep and context
> > tracking off.  For example:
>
> Without metadata nor memfd transmission, I get 2.5us for kdbus, 1.5us
> for UDS (8k payload). With 8-byte payloads, I get 2.2us and 1.2us. I
> suspect you enabled metadata transmission, which I think is not a fair
> comparison.

I tried to disable metadata.  I may have failed.

Regardless, if metadata is very slow, then that's more reason not to
use it on send.  And if you shouldn't use it, then maybe the kernel
shouldn't provide it.

I assumed there was a context switch in there.  I can try to test
differently.  If UDS is twice as fast *with* a contest switch, then a
userspace solution should be faster.

Also, UDS can use memfds, too.

>
> A few notes on that:
>
> * kdbus is a bus layer. We don't intend to replace UDS, but improve
> dbus. Comparing roundtrip times with UDS is tempting, but in no way
> fair. To the very least, a bus layer has to perform peer-lookup, which
> UDS does not have to do. Imo, 2.5us vs. 1.5us is already pretty nice.
> Compare this to ~77us for dbus1 without marshaling.

This makes me wonder what dbus1 is doing wrong.

>
> * We have not optimized kdbus code-paths for speed, yet. Our main
> concerns are algorithmic challenges, and we believe they've been
> improved considerably with kdbus. I have constantly measured kdbus
> performance with 'perf' and flame-graphs, and there're a lot of
> possible optimizations (especially on locking). However, I think this
> can be done afterwards just fine. Neither API nor ioctl overhead has
> shown up in my measurements. If anyone has counter evidence, please
> let us know. But I'm a bit reluctant to change our API solely based on
> performance guesses.

But removal of send-time metadata can't be done after the fact.

--Andy
