From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v4 00/14] Add kdbus implementation
Date: Mon, 23 Mar 2015 19:20:30 -0500
Message-ID: <87sicvz1o1.fsf@x220.int.ebiederm.org>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
	<CALCETrUjqTH14fZCeqU_OBoKX_6x4B=712WTeSqSAztpgXGiDw@mail.gmail.com>
	<CANq1E4Tf_6Cn+sxY=BPEbRpEr5WY+-rRX5gipz-_=4PNLa9bnQ@mail.gmail.com>
	<CALCETrVWbz7YudNQXQD_2PjC1HR0P0cB_1ea8NiYoQPDfQxERg@mail.gmail.com>
	<CANq1E4RA1ok=3Z5W2LkzqaUOKtbMVX_Joxe7_LRbLnQgfRUEYA@mail.gmail.com>
	<CALCETrWCBYzbzG3xZznG4AvVf67E_d8BVmBi1bZsDx7x_2Bh5g@mail.gmail.com>
	<CANq1E4TtXq02Ug22fsTr8j0X6+vJKvyryALiTEMbT4SMQB1j3g@mail.gmail.com>
	<CALCETrXqYBeZuOWhm9mz_nt+aWPXHFwkQPEAfwBXzDxnAP7f+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXqYBeZuOWhm9mz_nt+aWPXHFwkQPEAfwBXzDxnAP7f+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Mon, 23 Mar 2015 16:24:05 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> On Mon, Mar 23, 2015 at 8:28 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi
>>
>> On Thu, Mar 19, 2015 at 4:48 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>> On Thu, Mar 19, 2015 at 4:26 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>>> But you're comparing to the wrong thing, IMO.  Of course it's much
>>> faster than /proc hackery, but it's probably much slower to do the
>>> metadata operation once per message than to do it when you connect to
>>> the endpoint.  (Gah!  It's a "bus" that could easily have tons of
>>> users but a single "endpoint".  I'm still not used to it.)
>>
>> Yes, of course your assumption is right if you compare against
>> per-connection caches, instead of per-message metadata. But we do
>> support _both_ use-cases, so we don't impose any policy.
>> We still believe "live"-metadata is a crucial feature of kdbus,
>> despite the known performance penalties.
>
> And you still have not described a single use case for which it's
> better than per-connection metadata.
>
> I'm against adding a feature to the kernel (per-message metadata) if
> the primary reason it's being added is to support what appears to be a
> misfeature in *new* userspace that we have no obligation whatsoever to
> be ABI-compatible with.  This is especially true if that feature is
> slower than the alternatives.  This is even more true if this feature
> is *inconsistent* with legacy userspace (i.e. userspace dbus).
>
> I could be wrong about the lack of use cases.  If so, please enlighten
> me.

Please.  I asked this same question on the first revision of this code
to go up for review and I was told that there are no existing users of
dbus that cares.

Right now this looks like a case of the deplorable habit of getting
review comments, and then resubmitting a patch with trivial changes and
ignoring the substantial review comments.  Again and again and again
until the reviewers run out of energy to object.

That seems like a very poor way to add a new ABI that to the kernel that
we will have to support for the next 20 years, because huge swaths of
userspace are going to be using it.

Not to mention that per message meta-data is known to be both a
performance problem but also that it tends to turn in to a security
problem.  It is the kind of information that is easy to mess up and hard
to support long term.

So I agree with Andy that we really need something better than it would
be nice to have.

Eric
