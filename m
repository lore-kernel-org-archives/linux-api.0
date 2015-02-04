From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Wed, 04 Feb 2015 00:30:48 -0600
Message-ID: <874mr2b33b.fsf@x220.int.ebiederm.org>
References: <CALCETrU1O6LjhrXSH2aXWFt2WGh=ssrq4K9HD10f_Z55iT=Otw@mail.gmail.com>
	<54C9F525.4040703@zonque.org>
	<CALCETrV6P+Lx5FRLyDNubG18tqCTLprkXJf=82aa5DsRHjkuKA@mail.gmail.com>
	<54CA1CA2.9060005@zonque.org>
	<CALCETrXD41=ohFSkCmBD8zPHFVUtr49QXMhYnChAxqQtmUjJYw@mail.gmail.com>
	<54CF44B9.8000005@zonque.org>
	<CALCETrUh1Mse4CBQ4bfkJf+ew=kdpn46hMLS2QafLhfRTzQoBQ@mail.gmail.com>
	<54D09E6B.2020903@zonque.org>
	<CALCETrV_q9Y4OWC6fA78WsD+XFhsdGHrqH6OK-hc=Vvj2F5C5w@mail.gmail.com>
	<87siemgzoo.fsf@x220.int.ebiederm.org>
	<20150204031437.GB32207@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150204031437.GB32207-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> (Greg Kroah-Hartman's message
	of "Tue, 3 Feb 2015 19:14:37 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> writes:

> On Tue, Feb 03, 2015 at 08:47:51PM -0600, Eric W. Biederman wrote:
>> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>> 
>> > On Tue, Feb 3, 2015 at 2:09 AM, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org> wrote:
>> >> Hi Andy,
>> >>
>> >> On 02/02/2015 09:12 PM, Andy Lutomirski wrote:
>> >>> On Feb 2, 2015 1:34 AM, "Daniel Mack" <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org> wrote:
>> >>
>> >>>> That's right, but again - if an application wants to gather this kind of
>> >>>> information about tasks it interacts with, it can do so today by looking
>> >>>> at /proc or similar sources. Desktop machines do exactly that already,
>> >>>> and the kernel code executed in such cases very much resembles that in
>> >>>> metadata.c, and is certainly not cheaper. kdbus just makes such
>> >>>> information more accessible when requested. Which information is
>> >>>> collected is defined by bit-masks on both the sender and the receiver
>> >>>> connection, and most applications will effectively only use a very
>> >>>> limited set by default if they go through one of the more high-level
>> >>>> libraries.
>> >>>
>> >>> I should rephrase a bit.  Kdbus doesn't require use of send-time
>> >>> metadata.  It does, however, strongly encourage it, and it sounds like
>> >>
>> >> On the kernel level, kdbus just *offers* that, just like sockets offer
>> >> SO_PASSCRED. On the userland level, kdbus helps applications get that
>> >> information race-free, easier and faster than they would otherwise.
>> >>
>> >>> systemd and other major users will use send-time metadata.  Once that
>> >>> happens, it's ABI (even if it's purely in userspace), and changing it
>> >>> is asking for security holes to pop up.  So you'll be mostly stuck
>> >>> with it.
>> >>
>> >> We know we can't break the ABI. At most, we could deprecate item types
>> >> and introduce new ones, but we want to avoid that by all means of
>> >> course. However, I fail to see how that is related to send time
>> >> metadata, or even to kdbus in general, as all ABIs have to be kept stable.
>> >
>> > I should have said it differently.  ABI is the wrong term -- it's more
>> > of a protocol issue.
>> >
>> > It looks like, with the current code, the kernel will provide
>> > (optional) send-time metadata, and the sd-bus library will use it.
>> > The result will be that the communication protocol between clients and
>> > udev, systemd, systemd-logind, g-s-d, etc, will likely involve
>> > send-time metadata.  This may end up being a bottleneck.
>> 
>> A quick note on a couple of things I have seen in this conversation.
>> 
>> - The reason for kdbus is performance.
>
> No, that's not the only reason for kdbus, don't focus only on this.  I
> set out a long list of things for why we created kdbus, speed was only
> one of the things.  Security is also one, and the ability to gather
> these attributes in an atomic and secure way is very important as
> userspace wants this.

Perhaps I should have said the predominant reason.  Certainly that seems
to be most of what I have seen talked about.

Regardless looking at the performance in the design and removing any
substantial obstacle to making things go fast.

Further.  I had this conversation earlier in an earlier round of the
review and I was told that in fact existing dbus applications do not
want or need these attributes.   I think I heard journald wants them for
pretty printing things.

If security is your concern I really think per message attributes
collected and sent when a message is sent is a bad idea.  It has been a
nasty anti-pattern in the kernel code.  Lots and lots of meta-data
copyed from a task and sent to someone else has significant performance,
maintenance, and security impacts.

Code written in that pattern is complex and hard to analyze, and hard to
think about.  Consider debugging why a message does not get the expected
treatment from your suid application because someone changed the euid
over that particular call and had not thought about it's consequences.
Frankly I have been there and done that and it is a mess. 

So no I do not think breaking encapsulation and having weird side
effects affecting your new primitive will have any security benefits
whatsover.   It will just result in brittle complex code.

If you want to avoid the races causing sends through a file descriptor
to fail that don't have the expected attributes (my constructive
suggestion earlier) is a very different thing from a performance and
mainteance standpoint.  That does not increase the code complexity
nearly as much in the implementation or in use, and unexpected failures
happen right away.

>> - pipes rather than unix domain sockets are likely the standard to meet.
>>   If you can't equal unix domain sockets for simple things you are
>>   likely leaving a lot of stops in.  Last I looked pipes in general were
>>   notiably faster than unix domain sockets.
>> 
>>   The performance numbers I saw posted up-thread were horrible.  I have
>>   seen faster numbers across a network of machines.  If your ping-pong
>>   latency isn't measured in nano-seconds you are probably doing
>>   something wrong.
>
> It all depends on what you are passing on that "ping-pong", a real
> D-Bus connection has real data and meta data that has to be sent.
> Trying to make a fake benchmark number isn't going to show anything.

All that I was intending to convey is that the numbers I have seen have
been orders of magnitude slower than I would expect.  And 10x to 100x
slower than the code should be is a reason to ask why.

In my experience being efficient with small messages are important
because (a) they are the hardest to make go fast (b) they are surprising
common.  Remote X application start-up times are very slow because of
these.

People have a distressing habit of writing applications that
send a small message and synchronously waits for it.  Over time these
small ipc calls build up and you are limited by  how fast they will go.

>> - syscalls remove overhead.  So since performance is kdbus's reason for existence
>>   let's remove some ridiculous stops, and get a fast path into the kernel.
>
> Again, not the only reason, see my first post in this thread for
> details.

But performance is important, and performance is a good reason to use
system calls.

Security is another reason to have real system calls, as there is less
going on (compared to an ioctl multiplexer) so the code is easier to
audit.

Eric
