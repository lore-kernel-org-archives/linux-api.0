From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4 00/14] Add kdbus implementation
Date: Tue, 31 Mar 2015 11:29:02 -0700
Message-ID: <CALCETrX3vDZsymwC=LK=oK0=QLZqyB2Nv4N8jcjsx2yp1rjBvg@mail.gmail.com>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrUjqTH14fZCeqU_OBoKX_6x4B=712WTeSqSAztpgXGiDw@mail.gmail.com>
 <CANq1E4Tf_6Cn+sxY=BPEbRpEr5WY+-rRX5gipz-_=4PNLa9bnQ@mail.gmail.com>
 <CALCETrVWbz7YudNQXQD_2PjC1HR0P0cB_1ea8NiYoQPDfQxERg@mail.gmail.com>
 <CANq1E4RA1ok=3Z5W2LkzqaUOKtbMVX_Joxe7_LRbLnQgfRUEYA@mail.gmail.com>
 <CALCETrWCBYzbzG3xZznG4AvVf67E_d8BVmBi1bZsDx7x_2Bh5g@mail.gmail.com>
 <CANq1E4TtXq02Ug22fsTr8j0X6+vJKvyryALiTEMbT4SMQB1j3g@mail.gmail.com>
 <CALCETrXqYBeZuOWhm9mz_nt+aWPXHFwkQPEAfwBXzDxnAP7f+g@mail.gmail.com>
 <CANq1E4QiErHp8Q6bzFLkK9=7eBZC8dvh+Xnrh9_D5DAAogyaZA@mail.gmail.com>
 <CALCETrUuWhtJ9w9vyCGgaJDMGithJad4A4wf-BuxWLb_af5eDg@mail.gmail.com>
 <CANq1E4TTt3qanQse30KOZsuo2tfNoj7YSueh3AZ7bY1nQQeZNA@mail.gmail.com>
 <CALCETrV-cHYzcWu3t6tJ1eP0UZHTqoGH0KTYHTpJNit9-59TAA@mail.gmail.com> <CAG-2HqVwfH5fK0YV1+k3T4bFqd5v3Yd-hpL-bTSBK23FFY-zMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG-2HqVwfH5fK0YV1+k3T4bFqd5v3Yd-hpL-bTSBK23FFY-zMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 31, 2015 at 8:10 AM, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org> wrote:
> On Tue, Mar 31, 2015 at 3:58 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>
>> IOW you're taking something that you dislike aspects of and shoving
>> most of it in the kernel.  That guarantees us an API in the kernel
>> that even the creators don't really like.  This is, IMO, very
>> unfortunate.
>
> This is a misrepresentation of what David wrote. We do want this API
> regardless of dbus1 compatibility, but compatibility is by itself a
> sufficient motivation. A further motivation is reliable introspection,
> since this meta-data allows listing current peers on the bus and
> showing their identities. That's hugely useful to make the bus
> transparent to admins.

I've heard the following use cases for per-connection metadata:

 - Authenticating to dbus1 services.

 - Identifying connected users for admin diagnostics.

I've heard the following use cases for per-message metadata:

 - Logging.

 - Authenticating to kdbus services that want this style of authentication.

The only reasonable conclusion I've been able to draw is that the dbus
community intends to use *both* per-connection and per-message
metadata for authentication.  This means that, as a general rule,
dropping privileges while you have an open kdbus connection has poorly
defined effects.

It's particularly alarming that, when I express a concern about
logging, the kdbus authors cite authentication as an alternate
justification, and, when I cite a concern about authentication, the
kdbus authors cite logging as an alternative justificaiton.

This is simply not okay for a modern interface, and in my opinion the
kernel should not carry code to support new APIs with weakly defined
security semantics.  It's important that one be able to tell what the
security implications of one's code is without cross-referencing with
the implementation of the server's you're interacting with.

To top that off, the kdbus policy mechanism has truly bizarre effects
with respect to services that have unique ids and well-known names.
That, too, is apparently for compatibility.

This all feels to me like a total of about four people are going to
understand the tangle that is kdbus security, and that's bad.  I think
that the kernel should insist that new security-critical mechanisms
make sense and be hard to misuse.  The current design of kdbus, in
contrast, feel like it will be very hard to use correctly.

--Andy
