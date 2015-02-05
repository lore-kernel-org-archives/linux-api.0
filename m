From: David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Thu, 5 Feb 2015 01:16:35 +0100
Message-ID: <CANq1E4ShseFuTp0wPrHM9mFmgA-y9Kqz1m0-FmU9qALuxQ8Qvg@mail.gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
	<1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
	<54BE5DC8.70706@gmail.com>
	<54BE9D08.7010804@zonque.org>
	<54BF805B.4000609@gmail.com>
	<54BFDAAA.50203@zonque.org>
	<54C0CE8A.5080805@gmail.com>
	<CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com>
	<54C10DDC.9000503@gmail.com>
	<20150123160854.GA5210@kroah.com>
	<54C65346.5070504@gmail.com>
	<CANq1E4SkHhs1pWUe-TzG7bzk1M-Q++mB2vmQGuYx0RMF53wg4Q@mail.gmail.com>
	<CALCETrU1O6LjhrXSH2aXWFt2WGh=ssrq4K9HD10f_Z55iT=Otw@mail.gmail.com>
	<54C9F525.4040703@zonque.org>
	<CALCETrV6P+Lx5FRLyDNubG18tqCTLprkXJf=82aa5DsRHjkuKA@mail.gmail.com>
	<54CA1CA2.9060005@zonque.org>
	<CALCETrXD41=ohFSkCmBD8zPHFVUtr49QXMhYnChAxqQtmUjJYw@mail.gmail.com>
	<54CF44B9.8000005@zonque.org>
	<CALCETrUh1Mse4CBQ4bfkJf+ew=kdpn46hMLS2QafLhfRTzQoBQ@mail.gmail.com>
	<54D09E6B.2020903@zonque.org>
	<CALCETrXVDWJOvOTeTwCqrF6sn8e8XQfZSUbgg6hRnv+h-eX1Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXVDWJOvOTeTwCqrF6sn8e8XQfZSUbgg6hRnv+h-eX1Uw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Mack <daniel@zonque.org>, Arnd Bergmann <arnd@arndb.de>, Ted Ts'o <tytso@mit.edu>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Tom Gundersen <teg@jklm.no>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Djalal Harouni <tixxdz@opendz.org>, Johannes Stezenbach <js@sig21.net>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

Hi

On Thu, Feb 5, 2015 at 12:03 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> I see "latencies" of around 20 microseconds with lockdep and context
> tracking off.  For example:

Without metadata nor memfd transmission, I get 2.5us for kdbus, 1.5us
for UDS (8k payload). With 8-byte payloads, I get 2.2us and 1.2us. I
suspect you enabled metadata transmission, which I think is not a fair
comparison.

A few notes on that:

* kdbus is a bus layer. We don't intend to replace UDS, but improve
dbus. Comparing roundtrip times with UDS is tempting, but in no way
fair. To the very least, a bus layer has to perform peer-lookup, which
UDS does not have to do. Imo, 2.5us vs. 1.5us is already pretty nice.
Compare this to ~77us for dbus1 without marshaling.

* We have not optimized kdbus code-paths for speed, yet. Our main
concerns are algorithmic challenges, and we believe they've been
improved considerably with kdbus. I have constantly measured kdbus
performance with 'perf' and flame-graphs, and there're a lot of
possible optimizations (especially on locking). However, I think this
can be done afterwards just fine. Neither API nor ioctl overhead has
shown up in my measurements. If anyone has counter evidence, please
let us know. But I'm a bit reluctant to change our API solely based on
performance guesses.

* We're about 50% slower than UDS on 1-byte transmissions. With 32k
we're on-par. How can a lightweight user-space daemon even get close
to that?

* Broadcast performance is a completely different story. SEND gets
around 30% faster compared to kdbus unicasts (as most of the
control-paths are only taken once per message, instead of once per
destination).

* test-benchmark.c does performance tests in a single process. If the
bus-layer is implemented in user-space, you need to account for
context-switches and task wakeups. My UDS and pipe round-trip latency
tests got around 3x slower if done cross processes (3.7us instead of
1.2us). With a user-space daemon, those slow-downs are taken two times
more often for each roundtrip.

* Process time is accounted on the sender, instead of a shared process
(dbus-daemon). Broadcasts will thus no longer consume time-slices of
dbus-daemon, but only the sender's.


With kdbus, we implement a bus-layer. This is our only target! If your
target environment does not require a bus, then don't use kdbus. We
don't intend to replace UDS. On a bus-layer, we need peer-discovery,
policy-handling, destination-lookups, broadcast-management and more.
Pipes/UDS do not provide any of this.
I cannot see how any other existing bus-implementation comes even
close to kdbus, performance-wise. If someone does, please let us know!

Thanks
David
