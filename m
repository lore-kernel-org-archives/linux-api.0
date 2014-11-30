From: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Subject: Re: kdbus: add documentation
Date: Sun, 30 Nov 2014 18:22:31 +0100
Message-ID: <87zjb8txgo.fsf@mid.deneb.enyo.de>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
	<CALCETrWUekPq6pquuiVperBihQHgcvCF=WzVJTZziHhUJYsh4Q@mail.gmail.com>
	<87tx1hxdgy.fsf@mid.deneb.enyo.de>
	<CANq1E4QJhbypbs1PueKdW7AmBPiiYEg1dN-fsAewDJap82feyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4QJhbypbs1PueKdW7AmBPiiYEg1dN-fsAewDJap82feyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(David Herrmann's message of "Sun, 30 Nov 2014 18:12:39 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

* David Herrmann:

> poll(2) and friends cannot return data for changed descriptors. I
> think a single trap for each KDBUS_CMD_MSG_RECV is acceptable. If this
> turns out to be a bottleneck, we can provide bulk-operations in the
> future. Anyway, I don't see how a _shared_ pool would change any of
> this?

I responded to Andy's messages because it seemed to be about
generalizing the pool functionality.

>> kernel could also queue the data for one specific recipient,
>> addressing the same issue that SO_REUSEPORT tries to solve (on poll
>> notification, the kernel does not know which recipient will eventually
>> retrieve the data, so it has to notify and wake up all of them).
>
> We already queue data only for the addressed recipients. We *do* know
> all recipients of a message at poll-notification time. We only wake up
> recipients that actually got a message queued.

Exactly, but poll on, say, UDP sockets, does not work this way.  What
I'm trying to say is that this functionality is interesting for much
more than kdbus.

> Not sure how this is related to SO_REUSEPORT. Can you elaborate on
> your optimizations?

Without something like SO_REUSEPORT, it is a bad idea to have multiple
threads polling the same socket.  The semantics are such that the
kernel has to wake *all* the waiting threads, and one of them will
eventually pick up the datagram with a separate system call.  But the
kernel does not know which thread this will be.

With SO_REUSEPORT and a separately created socket for each polling
thread, the kernel will only signal one poll operation because it
assumes that any of the waiting threads will process the datagram, so
it's sufficient just to notify one of them.

kdbus behaves like the latter, but also saves the need to separately
obtain the datagram and related data from the kernel.
