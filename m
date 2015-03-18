From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4 00/14] Add kdbus implementation
Date: Wed, 18 Mar 2015 11:24:17 -0700
Message-ID: <CALCETrVWbz7YudNQXQD_2PjC1HR0P0cB_1ea8NiYoQPDfQxERg@mail.gmail.com>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrUjqTH14fZCeqU_OBoKX_6x4B=712WTeSqSAztpgXGiDw@mail.gmail.com> <CANq1E4Tf_6Cn+sxY=BPEbRpEr5WY+-rRX5gipz-_=4PNLa9bnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4Tf_6Cn+sxY=BPEbRpEr5WY+-rRX5gipz-_=4PNLa9bnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 18, 2015 at 6:54 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi
>
> On Tue, Mar 17, 2015 at 8:24 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> [...]
>> Can anyone comment on how fast it actually is.  I'm curious
>> about:
>>
>>  - The time it takes to do the ioctl to send a message
>>
>>  - The time it takes to receive a message (poll + whatever ioctls)
>
> I'm not sure I can gather useful absolute data here. This highly
> depends on how you call it, how often you call it, what payloads you
> pass, what machine you're on.. you know all that.
>
> So here's a flamegraph for you (which I use for comparisons to UDS):
>   http://people.freedesktop.org/~dvdhrm/kdbus_8kb.svg
>
> This program sends unicast messages on kdbus and UDS, exactly the same
> number of times with the same 8kb payload. No parsing, no marshaling
> is done, just plain message passing. The interesting spikes are
> sys_read(), sys_write() and the 3 kdbus sys_ioctl(). Everything else
> should be ignored.
>
> sys_read() and sys_ioctl(KDBUS_CMD_RECV) are about the same. But note
> that we don't copy any payload in RECV, so it scales O(1) compared to
> message-size.
>
> sys_write() is about 3x faster than sys_ioctl(KDBUS_CMD_WRITE).

Is that factor of 3 for 8 kb payloads?  If so, I expect it's a factor
of much worse than 3 for small payloads.

>
> I see lots of room for improvement in both RECV and SEND. Caching the
> namespaces on a connection, would get rid of
> kdbus_queue_entry_install() in RECV, thus speeding it up by ~30%. In
> SEND, we could merge the kvec and iovec copying, to avoid calling
> shmem_begin_write() twice. We should also stop allocating management
> structures that are not used (like for metadata, if no metadata is
> transmitted). We should use stack-space for small ioctl objects,
> instead of memdup_user(). And so on.. Oh, and locking can be reduced.
> We haven't even looked at rcu, yet (though that's mostly interesting
> for policy and broadcasts, not unicasts).
>
>>  - The time it takes to transfer a memfd (I don't care about how long
>> it takes to create or map a memfd -- that's exactly the same between
>> kdbus and any other memfds user, I imagine)
>
> The time to transmit a memfd is the same as to transmit a 64-byte
> payload. Ok, you also get to install the fd into the fd-table, but
> that's true regardless of the transport.
> Here's a graph for 64byte transfers (otherwise, same as above):
>   http://people.freedesktop.org/~dvdhrm/kdbus_64b.svg
>
>>  - The time it takes to connect
>
> No idea, never measured it. Why is it of interest?

Gah, sorry, bad terminology.  I mean the time it takes to send a
message to a receiver that you haven't sent to before.

(The kdbus terminology is weird.  You don't send to "endpoints", you
don't "connect" to other participants, and it's not even clear to me
what a participant in the bus is called.)

>
>> I'm also interested in whether the current design is actually amenable
>> to good performance.  I'm told that it is, but ISTM there's a lot of
>> heavyweight stuff going on with each send operation that will be hard
>> to remove.
>
> I disagree. What heavyweight stuff is going on?

At least metadata generation, metadata free, and policy db checks seem
expensive.  It could be worth running a bunch of copies of your
benchmark on different cores and seeing how it scales.

--Andy
