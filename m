From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4 00/14] Add kdbus implementation
Date: Tue, 31 Mar 2015 06:58:49 -0700
Message-ID: <CALCETrV-cHYzcWu3t6tJ1eP0UZHTqoGH0KTYHTpJNit9-59TAA@mail.gmail.com>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrUjqTH14fZCeqU_OBoKX_6x4B=712WTeSqSAztpgXGiDw@mail.gmail.com>
 <CANq1E4Tf_6Cn+sxY=BPEbRpEr5WY+-rRX5gipz-_=4PNLa9bnQ@mail.gmail.com>
 <CALCETrVWbz7YudNQXQD_2PjC1HR0P0cB_1ea8NiYoQPDfQxERg@mail.gmail.com>
 <CANq1E4RA1ok=3Z5W2LkzqaUOKtbMVX_Joxe7_LRbLnQgfRUEYA@mail.gmail.com>
 <CALCETrWCBYzbzG3xZznG4AvVf67E_d8BVmBi1bZsDx7x_2Bh5g@mail.gmail.com>
 <CANq1E4TtXq02Ug22fsTr8j0X6+vJKvyryALiTEMbT4SMQB1j3g@mail.gmail.com>
 <CALCETrXqYBeZuOWhm9mz_nt+aWPXHFwkQPEAfwBXzDxnAP7f+g@mail.gmail.com>
 <CANq1E4QiErHp8Q6bzFLkK9=7eBZC8dvh+Xnrh9_D5DAAogyaZA@mail.gmail.com>
 <CALCETrUuWhtJ9w9vyCGgaJDMGithJad4A4wf-BuxWLb_af5eDg@mail.gmail.com> <CANq1E4TTt3qanQse30KOZsuo2tfNoj7YSueh3AZ7bY1nQQeZNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4TTt3qanQse30KOZsuo2tfNoj7YSueh3AZ7bY1nQQeZNA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2015 at 9:56 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi
>
> On Wed, Mar 25, 2015 at 7:12 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Wed, Mar 25, 2015 at 10:29 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> [...]
>>>> I could be wrong about the lack of use cases.  If so, please enlighten me.
>>>
>>> We have several dbus APIs that allow clients to register as a special
>>> handler/controller/etc. (eg., see systemd-logind TakeControl()). The
>>> API provider checks the privileges of a client on registration and
>>> then just tracks the client ID. This way, the client can be privileged
>>> when asking for special access, then drop privileges and still use the
>>> interface. You cannot re-connect in between, as the API provider
>>> tracks your bus ID. Without message-metadata, all your (other) calls
>>> on this bus would always be treated as privileged. We *really* want to
>>> avoid this.
>>
>> Connect twice?
>
> The remote peer might cache your connection ID to track you. You have
> to use the same connection to talk to that peer, in this given
> scenario. That's how D-Bus1 is used today, and we have to follow the
> semantics.

That's yet another reason that you really ought to disconnect and
reconnect after a privilege change -- the remote peer might remember
you.

The "might" will be a big problem.  Users of kdbus can't rely on any
particular concept of privilege because you have too many of them.

>
>> You *already* have to reconnect or connect twice because you have
>> per-connection metadata.  That's part of my problem with this scheme
>> -- you support *both styles*, which seems like it'll give you most of
>> the downsides of both without the upsides.
>
> Not necessarily. Connection metadata describes the state at the time
> you connected to the bus. If someone ask for this information, they
> will get exactly that. In this model, you cannot drop privileges, if
> you need to be privileged during setup.
> If someone asks for per-message metadata, they better ought not ask
> for per-connection creds. It's not the information they're looking
> for, so it will not match the data that at the time the message was
> sent.
>
> There is no immediate need to make both match. For security decisions,
> we mandate per-message creds. Per-connection creds are for
> backwards-compatibility to dbus1 and for passive introspection of bus
> connections.

Backwards compatibility doesn't magically exempt security
considerations.  If new code is insecure when talking to a legacy
service, it's still insecure.

[...]

>> Again, you seem to be arguing that per-connection metadata is bad, but
>> you still have an implementation of per-connection metadata, so you
>> still have all these problems.
>
> I don't see why we get the problems of per-connection metadata. Just
> because you _can_ use it, doesn't mean you should use it for all
> imaginable use-cases. The same goes for reading information from
> /proc. There are valid use-cases to do so, but also a lot of cases
> where it will not provide the information you want.
>

Then you'll need to document really carefully which metadata is used
for which service.  This actually seems impossible to do, since some
services will exist in legacy and kdbus forms.

>> I'm actually okay with per-message metadata in principle, but I'd like
>> to see evidence (with numbers, please) that a send+recv of per-message
>> metadata is *not* significantly slower than a recv of already-captured
>> per-connection metadata.  If this is in fact the case, then maybe you
>> should trash per-connection metadata instead and the legacy
>> compatibility code can figure out a way to deal with it.  IMO that
>> would be a pretty nice outcome, since you would never have to worry
>> whether your connection to the bus is inadvertantly privileged.
>
> Per-message metadata makes SEND about 25% slower, if you transmit the
> full set of all possible information. Just 3% if you only use
> PIDs+UIDs. The expensive metadata is cgroup-path and exe-path.
> If a service needs that information, however, and if that information
> is not guaranteed to be up-to-date, the service _will_ go and look it
> up in /proc or somewhere else, which is certainly a whole lot more
> expensive than the code in kdbus.

Can you give actual numbers, in ns or cycles, of how much overhead
metadata adds?

>
> In general, there seems to be a number of misconception in this thread
> about what kdbus is supposed to be. We're not inventing something new
> here with a clean slate, but we're moving parts of an existing
> implementation that has tons of users into the kernel, in order to fix
> issues that cannot be fixed otherwise in userspace (most notably, the
> race gaps that exist when retrieving per-message metadata). Therefore,
> we have to keep existing semantics stable, otherwise the exercise is
> somewhat pointless.

IOW you're taking something that you dislike aspects of and shoving
most of it in the kernel.  That guarantees us an API in the kernel
that even the creators don't really like.  This is, IMO, very
unfortunate.

Have you considered porting the kdbus per-message metadata mechanism to UDS?

--Andy
