From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4 00/14] Add kdbus implementation
Date: Mon, 23 Mar 2015 16:24:05 -0700
Message-ID: <CALCETrXqYBeZuOWhm9mz_nt+aWPXHFwkQPEAfwBXzDxnAP7f+g@mail.gmail.com>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrUjqTH14fZCeqU_OBoKX_6x4B=712WTeSqSAztpgXGiDw@mail.gmail.com>
 <CANq1E4Tf_6Cn+sxY=BPEbRpEr5WY+-rRX5gipz-_=4PNLa9bnQ@mail.gmail.com>
 <CALCETrVWbz7YudNQXQD_2PjC1HR0P0cB_1ea8NiYoQPDfQxERg@mail.gmail.com>
 <CANq1E4RA1ok=3Z5W2LkzqaUOKtbMVX_Joxe7_LRbLnQgfRUEYA@mail.gmail.com>
 <CALCETrWCBYzbzG3xZznG4AvVf67E_d8BVmBi1bZsDx7x_2Bh5g@mail.gmail.com> <CANq1E4TtXq02Ug22fsTr8j0X6+vJKvyryALiTEMbT4SMQB1j3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4TtXq02Ug22fsTr8j0X6+vJKvyryALiTEMbT4SMQB1j3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 23, 2015 at 8:28 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi
>
> On Thu, Mar 19, 2015 at 4:48 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Thu, Mar 19, 2015 at 4:26 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> metadata handling is local to the connection that sends the message.
>>> It does not affect the overall performance of other bus operations in
>>> parallel.
>>
>> Sure it does if it writes to shared cachelines.  Given that you're
>> incrementing refcounts, I'm reasonable sure that you're touching lots
>> of shared cachelines.
>
> Ok, sure, but it's still mostly local to the sending task. We take
> locks and ref-counts on the task-struct and mm, which is for most
> parts local to the CPU the task runs on. But this is inherent to
> accessing this kind of data, which is the fundamental difference in
> our views here, as seen below..

You're also refcounting the struct cred, and there's no good reason
for that to be local.  (It might be a bit more local than intended
because of the absurd things that the key subsystem does to struct
cred, but IMO users should turn that off or the kernel should fix it.)

Even more globally, I think you're touching init_user_ns's refcount in
most scenarios.  That's about as global as it gets.

(Also, is there an easy benchmark to see how much time it takes to
send and receive metadata?  I tried to get the kdbus test to do this,
and I failed.  I probably did it wrong.)

>
>>> Furthermore, it's way faster than collecting the "same" data
>>> via /proc, so I don't think it slows down the overall transaction at
>>> all. If a receiver doesn't want metadata, it should not request it (by
>>> setting the receiver-metadata-mask). If a sender doesn't like the
>>> overhead, it should not send the metadata (by setting the
>>> sender-metadata-mask). Only if both peers set the metadata mask, it
>>> will be transmitted.
>>
>> But you're comparing to the wrong thing, IMO.  Of course it's much
>> faster than /proc hackery, but it's probably much slower to do the
>> metadata operation once per message than to do it when you connect to
>> the endpoint.  (Gah!  It's a "bus" that could easily have tons of
>> users but a single "endpoint".  I'm still not used to it.)
>
> Yes, of course your assumption is right if you compare against
> per-connection caches, instead of per-message metadata. But we do
> support _both_ use-cases, so we don't impose any policy.
> We still believe "live"-metadata is a crucial feature of kdbus,
> despite the known performance penalties.

And you still have not described a single use case for which it's
better than per-connection metadata.

I'm against adding a feature to the kernel (per-message metadata) if
the primary reason it's being added is to support what appears to be a
misfeature in *new* userspace that we have no obligation whatsoever to
be ABI-compatible with.  This is especially true if that feature is
slower than the alternatives.  This is even more true if this feature
is *inconsistent* with legacy userspace (i.e. userspace dbus).

I could be wrong about the lack of use cases.  If so, please enlighten me.

--Andy
