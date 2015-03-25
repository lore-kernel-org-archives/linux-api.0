From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4 00/14] Add kdbus implementation
Date: Wed, 25 Mar 2015 11:12:05 -0700
Message-ID: <CALCETrUuWhtJ9w9vyCGgaJDMGithJad4A4wf-BuxWLb_af5eDg@mail.gmail.com>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrUjqTH14fZCeqU_OBoKX_6x4B=712WTeSqSAztpgXGiDw@mail.gmail.com>
 <CANq1E4Tf_6Cn+sxY=BPEbRpEr5WY+-rRX5gipz-_=4PNLa9bnQ@mail.gmail.com>
 <CALCETrVWbz7YudNQXQD_2PjC1HR0P0cB_1ea8NiYoQPDfQxERg@mail.gmail.com>
 <CANq1E4RA1ok=3Z5W2LkzqaUOKtbMVX_Joxe7_LRbLnQgfRUEYA@mail.gmail.com>
 <CALCETrWCBYzbzG3xZznG4AvVf67E_d8BVmBi1bZsDx7x_2Bh5g@mail.gmail.com>
 <CANq1E4TtXq02Ug22fsTr8j0X6+vJKvyryALiTEMbT4SMQB1j3g@mail.gmail.com>
 <CALCETrXqYBeZuOWhm9mz_nt+aWPXHFwkQPEAfwBXzDxnAP7f+g@mail.gmail.com> <CANq1E4QiErHp8Q6bzFLkK9=7eBZC8dvh+Xnrh9_D5DAAogyaZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4QiErHp8Q6bzFLkK9=7eBZC8dvh+Xnrh9_D5DAAogyaZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 25, 2015 at 10:29 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi
>
> On Tue, Mar 24, 2015 at 12:24 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Mon, Mar 23, 2015 at 8:28 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On Thu, Mar 19, 2015 at 4:48 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>>> On Thu, Mar 19, 2015 at 4:26 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>> metadata handling is local to the connection that sends the message.
>>>>> It does not affect the overall performance of other bus operations in
>>>>> parallel.
>>>>
>>>> Sure it does if it writes to shared cachelines.  Given that you're
>>>> incrementing refcounts, I'm reasonable sure that you're touching lots
>>>> of shared cachelines.
>>>
>>> Ok, sure, but it's still mostly local to the sending task. We take
>>> locks and ref-counts on the task-struct and mm, which is for most
>>> parts local to the CPU the task runs on. But this is inherent to
>>> accessing this kind of data, which is the fundamental difference in
>>> our views here, as seen below..
>>
>> You're also refcounting the struct cred
>
> No?
>
> We do ref-count the group-info, but that is actually redundant as we
> just copy the IDs. We should drop this, since group-info of 'current'
> can be accessed right away. I noted it down.

OK

>
>> and there's no good reason
>> for that to be local.  (It might be a bit more local than intended
>> because of the absurd things that the key subsystem does to struct
>> cred, but IMO users should turn that off or the kernel should fix it.)
>>
>> Even more globally, I think you're touching init_user_ns's refcount in
>> most scenarios.  That's about as global as it gets.
>
> get_user_ns() in metadata.c is a workaround (as the comment there
> explains). With better export-helpers for caps, we can simply drop it.
> It's conditional on KDBUS_ATTACH_CAPS, anyway.

Fair enough.

>
>> (Also, is there an easy benchmark to see how much time it takes to
>> send and receive metadata?  I tried to get the kdbus test to do this,
>> and I failed.  I probably did it wrong.)
>
> patch for out-of-tree kdbus:
> https://gist.github.com/dvdhrm/3ac4339bf94fadc13b98
>
> Update it to pass _KDBUS_ATTACH_ALL for both arguments of
> kdbus_conn_update_attach_flags().
>
>>>>> Furthermore, it's way faster than collecting the "same" data
>>>>> via /proc, so I don't think it slows down the overall transaction at
>>>>> all. If a receiver doesn't want metadata, it should not request it (by
>>>>> setting the receiver-metadata-mask). If a sender doesn't like the
>>>>> overhead, it should not send the metadata (by setting the
>>>>> sender-metadata-mask). Only if both peers set the metadata mask, it
>>>>> will be transmitted.
>>>>
>>>> But you're comparing to the wrong thing, IMO.  Of course it's much
>>>> faster than /proc hackery, but it's probably much slower to do the
>>>> metadata operation once per message than to do it when you connect to
>>>> the endpoint.  (Gah!  It's a "bus" that could easily have tons of
>>>> users but a single "endpoint".  I'm still not used to it.)
>>>
>>> Yes, of course your assumption is right if you compare against
>>> per-connection caches, instead of per-message metadata. But we do
>>> support _both_ use-cases, so we don't impose any policy.
>>> We still believe "live"-metadata is a crucial feature of kdbus,
>>> despite the known performance penalties.
> [...]
>> This is even more true if this feature
>> is *inconsistent* with legacy userspace (i.e. userspace dbus).
>
> Live metadata is already supported on UDS via SCM_CREDENTIALS, we just
> extend it to other metadata items. It's not a new invention by us.
> Debian code-search on SO_PASSCRED and SCM_CREDENTIALS gives lots of
> results.
>
> Netlink, as a major example of an existing bus API, already uses
> SCM_CREDENTIALS as primary way to transmit metadata.
>
>> I could be wrong about the lack of use cases.  If so, please enlighten me.
>
> We have several dbus APIs that allow clients to register as a special
> handler/controller/etc. (eg., see systemd-logind TakeControl()). The
> API provider checks the privileges of a client on registration and
> then just tracks the client ID. This way, the client can be privileged
> when asking for special access, then drop privileges and still use the
> interface. You cannot re-connect in between, as the API provider
> tracks your bus ID. Without message-metadata, all your (other) calls
> on this bus would always be treated as privileged. We *really* want to
> avoid this.

Connect twice?

You *already* have to reconnect or connect twice because you have
per-connection metadata.  That's part of my problem with this scheme
-- you support *both styles*, which seems like it'll give you most of
the downsides of both without the upsides.

>
> Another example is logging, where we want exact data at the time a
> message is logged. Otherwise, the data is useless.

Why?

No, really, why is exact data at the time of logging so important?  It
sounds nice, but I really don't see it.

> With
> message-metadata, you can figure out the exact situation a process was
> in when a specific message was logged. Furthermore, it is impossible
> to read such data from /proc, as the process might already be dead.
> Which is a _real_ problem right now!
> Similarly, system monitoring wants message-metadata for the same
> reasons. And it needs to be reliable, you don't want malicious
> sandboxes to mess with your logs.

Huh?  A "malicious sandbox" can always impersonate itself, whether by
connecting and handing off a connection or simply by relaying mesages.

>
> kdbus is a _bus_, not a p2p channel. Thus, a peer may talk to multiple
> destinations, and it may want to look different to each of them. DBus
> method-calls allow 'syscall'-ish behavior when calling into other
> processes. We *want* to be able to drop privileges after doing process
> setup. We want further bus-calls to no longer be treated privileged.

You could have an IOCTL that re-captures your connection metata.

>
> Furthermore, DBus was designed to allow peers to track other peers
> (which is why it always had the NameOwnerChanged signal). This is an
> essential feature, that simplifies access-management considerably, as
> you can cache it together with the unique name of a peer. We only open
> a single connection to a bus. glib, libdbus, efl, ell, qt, sd-bus, and
> others use cached bus-connections that are shared by all code of a
> single thread. Hence, the bus connection is kinda part of the process
> itself, like stdin/stdout. Without message-metadata, it is impossible
> to ever drop privileges on a bus, without losing all state.

See above about an IOCTL that re-captures your connection metadata.

Again, you seem to be arguing that per-connection metadata is bad, but
you still have an implementation of per-connection metadata, so you
still have all these problems.

I'm actually okay with per-message metadata in principle, but I'd like
to see evidence (with numbers, please) that a send+recv of per-message
metadata is *not* significantly slower than a recv of already-captured
per-connection metadata.  If this is in fact the case, then maybe you
should trash per-connection metadata instead and the legacy
compatibility code can figure out a way to deal with it.  IMO that
would be a pretty nice outcome, since you would never have to worry
whether your connection to the bus is inadvertantly privileged.

(Also, FWIW, it seems like what you really want is a capability model,
in which you grab a handle to some service and that handle captures
all your privileges wrt that service.  Per-message metadata is even
farther from this than per-connection-to-the-bus metadata, but neither
one is particularly close.)

>
> Thanks
> David



-- 
Andy Lutomirski
AMA Capital Management, LLC
