From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v4 00/14] Add kdbus implementation
Date: Sun, 5 Apr 2015 15:46:30 +0200
Message-ID: <20150405134630.GA29698@kroah.com>
References: <CANq1E4TtXq02Ug22fsTr8j0X6+vJKvyryALiTEMbT4SMQB1j3g@mail.gmail.com>
 <CALCETrXqYBeZuOWhm9mz_nt+aWPXHFwkQPEAfwBXzDxnAP7f+g@mail.gmail.com>
 <CANq1E4QiErHp8Q6bzFLkK9=7eBZC8dvh+Xnrh9_D5DAAogyaZA@mail.gmail.com>
 <CALCETrUuWhtJ9w9vyCGgaJDMGithJad4A4wf-BuxWLb_af5eDg@mail.gmail.com>
 <CANq1E4TTt3qanQse30KOZsuo2tfNoj7YSueh3AZ7bY1nQQeZNA@mail.gmail.com>
 <CALCETrV-cHYzcWu3t6tJ1eP0UZHTqoGH0KTYHTpJNit9-59TAA@mail.gmail.com>
 <CAG-2HqVwfH5fK0YV1+k3T4bFqd5v3Yd-hpL-bTSBK23FFY-zMA@mail.gmail.com>
 <CALCETrX3vDZsymwC=LK=oK0=QLZqyB2Nv4N8jcjsx2yp1rjBvg@mail.gmail.com>
 <CANq1E4QSja-KhVL2p-d406uLJT600zMpK2UAcwsb0LkMwa8F7w@mail.gmail.com>
 <FFF43E89-B796-4BDE-893A-5CC2AE77AED7@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <FFF43E89-B796-4BDE-893A-5CC2AE77AED7-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Apr 05, 2015 at 07:09:16AM -0500, Eric W. Biederman wrote:
> 
> 
> On April 3, 2015 6:51:34 AM CDT, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >Hi
> >
> >On Tue, Mar 31, 2015 at 8:29 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> >wrote:
> >> On Tue, Mar 31, 2015 at 8:10 AM, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org> wrote:
> >>> On Tue, Mar 31, 2015 at 3:58 PM, Andy Lutomirski
> ><luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> >>>>
> >>>> IOW you're taking something that you dislike aspects of and shoving
> >>>> most of it in the kernel.  That guarantees us an API in the kernel
> >>>> that even the creators don't really like.  This is, IMO, very
> >>>> unfortunate.
> >>>
> >>> This is a misrepresentation of what David wrote. We do want this API
> >>> regardless of dbus1 compatibility, but compatibility is by itself a
> >>> sufficient motivation. A further motivation is reliable
> >introspection,
> >>> since this meta-data allows listing current peers on the bus and
> >>> showing their identities. That's hugely useful to make the bus
> >>> transparent to admins.
> >>
> >> I've heard the following use cases for per-connection metadata:
> >>
> >>  - Authenticating to dbus1 services.
> >
> >Not necessarily authentication, but we need to support the legacy API,
> >for whatever reason it was used by old applications. But..
> >
> >>  - Identifying connected users for admin diagnostics.
> >>
> >> I've heard the following use cases for per-message metadata:
> >>
> >>  - Logging.
> >>
> >>  - Authenticating to kdbus services that want this style of
> >authentication.
> >
> >..please note that authentication on DBus has always been done with
> >per-message metadata (see polkit history). However, this had to be
> >reverted some years ago as it is racy (it used /proc for that, which
> >can be exploited by exec'ing setuid binaries). However, the
> >per-message metadata authentication worked very well for _years_
> >(minus the race..), so this is already a well-established scheme. With
> >kdbus we can finally implement this in a race-free manner.
> >
> >[...]
> >> This is simply not okay for a modern interface, and in my opinion the
> >> kernel should not carry code to support new APIs with weakly defined
> >> security semantics.  It's important that one be able to tell what the
> >> security implications of one's code is without cross-referencing with
> >> the implementation of the server's you're interacting with.
> >
> >Again, I disagree. Our concepts are established and used on UDS and
> >DBus for decades.
> >
> >Yes, we provide two ways to retrieve metadata, but the kernel offers
> >several more paths to gather that information. Just because those APIs
> >are available does not mean they should be used for authentication. We
> >mandate per-message metadata. If applications use per-connection
> >metadata, /proc, netlink, or random data, they're doing it wrong.
> >
> >Furthermore, dbus provides pretty complete and straightforward
> >libraries which hide that from you. If you use glib, qt or sd-bus, you
> >don't even need to deal with all that.
> >
> >> To top that off, the kdbus policy mechanism has truly bizarre effects
> >> with respect to services that have unique ids and well-known names.
> >> That, too, is apparently for compatibility.
> >>
> >> This all feels to me like a total of about four people are going to
> >> understand the tangle that is kdbus security, and that's bad.  I
> >think
> >> that the kernel should insist that new security-critical mechanisms
> >> make sense and be hard to misuse.  The current design of kdbus, in
> >> contrast, feel like it will be very hard to use correctly.
> >
> >Native kdbus clients are authenticated with their credentials at time
> >of method call. Legacy clients will always have their credentials at
> >time of connect in effect. No fallbacks, no choices. It's a simple
> >question whether it's a legacy client or not.
> >Sounds simple to me.
>  
> So I just took a slightly deeper look and the user namespace bits are wrong. Both in implementation
> and in design.
> 
> Passing "capabilities" to user space for reasons of authentication is wrong and a maintenance nightmare.    Further the capabilities maintainer Serge Hallyn has not been copied.

I don't understand, where are passed that are not already exported today
through /proc/ already?  kdbus gathers this information in a race-free
way, unlike having to dig this out of proc and hope that nothing has
changed underneath you.

> There are several other pieces of information in your meta data like cmdline that I have similar concerns about, but are I am less familiar with, and have looked at less.

Again, cmdline is also exported today, why is passing that somehow not
acceptable?

> Which leads my to conclude that in its current form kdbus is inappropriate for inclusion in the kernel.

Ah, so we should also remove those fields from /proc/ today as well, and
just break all of userspace that relies on it today?  Again, kdbus is
just doing the same thing that userspace is doing today, but in a
race-free manner.

> The code is dangerously and inappropriately wrong and comes with a huge maintenance obligation to people outside of kdbus.

How so?  Please explain.

Oh, and please wrap your email properly, reading it this way is a
horrible experience, you know better than that...

greg k-h
