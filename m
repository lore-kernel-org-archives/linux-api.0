From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Mon, 2 Feb 2015 12:12:17 -0800
Message-ID: <CALCETrUh1Mse4CBQ4bfkJf+ew=kdpn46hMLS2QafLhfRTzQoBQ@mail.gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com>
 <54BFDAAA.50203@zonque.org> <54C0CE8A.5080805@gmail.com> <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com>
 <54C10DDC.9000503@gmail.com> <20150123160854.GA5210@kroah.com>
 <54C65346.5070504@gmail.com> <CANq1E4SkHhs1pWUe-TzG7bzk1M-Q++mB2vmQGuYx0RMF53wg4Q@mail.gmail.com>
 <CALCETrU1O6LjhrXSH2aXWFt2WGh=ssrq4K9HD10f_Z55iT=Otw@mail.gmail.com>
 <54C9F525.4040703@zonque.org> <CALCETrV6P+Lx5FRLyDNubG18tqCTLprkXJf=82aa5DsRHjkuKA@mail.gmail.com>
 <54CA1CA2.9060005@zonque.org> <CALCETrXD41=ohFSkCmBD8zPHFVUtr49QXMhYnChAxqQtmUjJYw@mail.gmail.com>
 <54CF44B9.8000005@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54CF44B9.8000005-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Feb 2, 2015 1:34 AM, "Daniel Mack" <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org> wrote:
>
> Hi Andy,
>
> On 01/29/2015 01:09 PM, Andy Lutomirski wrote:
> > On Jan 29, 2015 6:42 AM, "Daniel Mack" <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org> wrote:
>
> >> As we explained before, currently, D-Bus peers do collect the same
> >> information already if they need to have them, but they have to do deal
> >> with the inherit races in such cases. kdbus is closing the gap by
> >> optionally providing the same information along with each message, if
> >> requested.
> >
> > In all these discussions, no one ever gave a decent example use case.
> > If a process drops some privilege, it must close all fds it has that
> > captured its old privilege.  This has nothing to do with kdbus.
>
> kdbus does not implement any new concept here but sticks to what
> SCM_CREDENTIALS does on SOL_SEQPACKET. An application can get a
> file-descriptor from socket() or socketpair() and freely pass it around
> between different tasks or threads, but messages will always have the
> credentials attached that are valid at *send* time. SO_PEERCREDS,
> however, still reports the connect-time credentials, and kdbus provides
> exactly the same semantics and both ways of retrieving information.
>
> > I agree that the design seems to have improved to a state of being at
> > least decent,
>
> One reason for that is your feedback. Thanks for that again!
>
> > It's an optional feature that will get used, non-optionally, thousands
> > of times on each boot, apparently.  Keep in mind that it's also a
> > scalability problem because it takes locks.  If it ever gets used
> > thousands of times per CPU on a big thousand-core machine, it's going
> > to suck, and you'll have backed yourself into a corner.
>
> That's right, but again - if an application wants to gather this kind of
> information about tasks it interacts with, it can do so today by looking
> at /proc or similar sources. Desktop machines do exactly that already,
> and the kernel code executed in such cases very much resembles that in
> metadata.c, and is certainly not cheaper. kdbus just makes such
> information more accessible when requested. Which information is
> collected is defined by bit-masks on both the sender and the receiver
> connection, and most applications will effectively only use a very
> limited set by default if they go through one of the more high-level
> libraries.

I should rephrase a bit.  Kdbus doesn't require use of send-time
metadata.  It does, however, strongly encourage it, and it sounds like
systemd and other major users will use send-time metadata.  Once that
happens, it's ABI (even if it's purely in userspace), and changing it
is asking for security holes to pop up.  So you'll be mostly stuck
with it.

>
> Also, when metadata is collected, the code mostly takes temporary
> references on objects like PIDs, namespaces etc. Which operation would
> you consider particularly expensive?

The refcounting, copies of some of the data, and counting bytes and
allocating space.  The refcounting is the part that will scale
particularly badly on many CPUs.

Do you have some simple benchmark code you can share?  I'd like to
play with it a bit.

--Andy

>
>
> Thanks again,
> Daniel
>
