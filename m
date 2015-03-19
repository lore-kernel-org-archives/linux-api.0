From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4 00/14] Add kdbus implementation
Date: Thu, 19 Mar 2015 08:48:41 -0700
Message-ID: <CALCETrWCBYzbzG3xZznG4AvVf67E_d8BVmBi1bZsDx7x_2Bh5g@mail.gmail.com>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrUjqTH14fZCeqU_OBoKX_6x4B=712WTeSqSAztpgXGiDw@mail.gmail.com>
 <CANq1E4Tf_6Cn+sxY=BPEbRpEr5WY+-rRX5gipz-_=4PNLa9bnQ@mail.gmail.com>
 <CALCETrVWbz7YudNQXQD_2PjC1HR0P0cB_1ea8NiYoQPDfQxERg@mail.gmail.com> <CANq1E4RA1ok=3Z5W2LkzqaUOKtbMVX_Joxe7_LRbLnQgfRUEYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4RA1ok=3Z5W2LkzqaUOKtbMVX_Joxe7_LRbLnQgfRUEYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 19, 2015 at 4:26 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi
>
> On Wed, Mar 18, 2015 at 7:24 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Wed, Mar 18, 2015 at 6:54 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> [...]
>>> This program sends unicast messages on kdbus and UDS, exactly the same
>>> number of times with the same 8kb payload. No parsing, no marshaling
>>> is done, just plain message passing. The interesting spikes are
>>> sys_read(), sys_write() and the 3 kdbus sys_ioctl(). Everything else
>>> should be ignored.
>>>
>>> sys_read() and sys_ioctl(KDBUS_CMD_RECV) are about the same. But note
>>> that we don't copy any payload in RECV, so it scales O(1) compared to
>>> message-size.
>>>
>>> sys_write() is about 3x faster than sys_ioctl(KDBUS_CMD_WRITE).
>>
>> Is that factor of 3 for 8 kb payloads?  If so, I expect it's a factor
>> of much worse than 3 for small payloads.
>
> Yes, factor of 3x for 8kb payloads. ~3.8x for 64byte payloads (see the
> second flamegraph I linked, which contains data for 64byte payloads
> (which is basically nothing)).

I find this surprising.  Are both of them so slow that copying 8kb is
negligible?  That's rather sad.

>
>>>>  - The time it takes to connect
>>>
>>> No idea, never measured it. Why is it of interest?
>>
>> Gah, sorry, bad terminology.  I mean the time it takes to send a
>> message to a receiver that you haven't sent to before.
>
> Cold message transactions are horribly slow for both, kdbus and UDS,
> and the performance varies heavily (factor of 10x). I haven't figured
> out whether it's icache/dcache misses, cold branch predictor, process
> mem faults, scheduler, whatever..
>
> What I can say, is the kdbus paths are more expensive, in both LOC and
> execution time. We might be able to improve the cold-transaction
> performance with _unlikely_() annotations, shortcuts, etc. But I want
> much more benchmark data before I try to outsmart the compiler. It
> works reasonably well right now.
>
> Note that from a algorithmic view, there's no difference between the
> first transaction and a following transaction. All relevant accesses
> are O(1).
>
> (Actually looking at the numbers again, worst-case vs. average-case in
> message transaction is exactly 10x for both, UDS and kdbus. Skipping
> the first couple, I get <2x. std-dev is roughly 2%)
>
>> (The kdbus terminology is weird.  You don't send to "endpoints", you
>> don't "connect" to other participants, and it's not even clear to me
>> what a participant in the bus is called.)
>
> A participant is called a "connection" or "peer" (I prefer 'peer'). It
> "connects" to a bus via an endpoint of the bus. Endpoints are
> file-system entries and can be shared, and usually are.
> Unlike binder, kdbus does not know peer-to-peer links. That is, there
> is never (not even a temporary) link between only two peers. Messages
> are always sent to the bus, and the bus makes sure only the addressed
> recipients will get the message.
>
>>>
>>>> I'm also interested in whether the current design is actually amenable
>>>> to good performance.  I'm told that it is, but ISTM there's a lot of
>>>> heavyweight stuff going on with each send operation that will be hard
>>>> to remove.
>>>
>>> I disagree. What heavyweight stuff is going on?
>>
>> At least metadata generation, metadata free, and policy db checks seem
>> expensive.  It could be worth running a bunch of copies of your
>> benchmark on different cores and seeing how it scales.
>
> metadata handling is local to the connection that sends the message.
> It does not affect the overall performance of other bus operations in
> parallel.

Sure it does if it writes to shared cachelines.  Given that you're
incrementing refcounts, I'm reasonable sure that you're touching lots
of shared cachelines.

> Furthermore, it's way faster than collecting the "same" data
> via /proc, so I don't think it slows down the overall transaction at
> all. If a receiver doesn't want metadata, it should not request it (by
> setting the receiver-metadata-mask). If a sender doesn't like the
> overhead, it should not send the metadata (by setting the
> sender-metadata-mask). Only if both peers set the metadata mask, it
> will be transmitted.

But you're comparing to the wrong thing, IMO.  Of course it's much
faster than /proc hackery, but it's probably much slower to do the
metadata operation once per message than to do it when you connect to
the endpoint.  (Gah!  It's a "bus" that could easily have tons of
users but a single "endpoint".  I'm still not used to it.)

>
> The policy-db does indeed look like a bottleneck. Until v2 we used to
> have a policy-cache, which I ripped out as it didn't meet our
> expectations. There are plans to rewrite it, but it's low-priority.
> Thing is, policy-setup is bus-privileged. As long as it's done in a
> sane manner (keeping the entries per name minimal), the hash-table
> based name-lookup gives suitable performance. Only if the number of
> entries per name rises, it gets problematic due to O(n)
> list-traversal. But even that could be optimized without a policy
> cache, by merging matching entries (see kdbus_policy_db_entry_access).
> Furthermore, the policy-db is skipped for privileged peers or if both,
> sender and recipient, trust each other (eg., have the same
> endpoint+uid). Thus, if you have a trusted transaction, the policy-db
> is skipped, anyway.

Yeah, that's reasonable.  I don't see any obvious way around that.
(The policy semantics are still insane wrt connections with multiple
names, though, but that should have nothing to do with performance.
Insanity for historical reasons is still insanity.)

--Andy
