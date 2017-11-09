From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
Date: Thu, 9 Nov 2017 12:05:36 -0600
Message-ID: <20171109180536.GA27994@mail.hallyn.com>
References: <20171103004436.40026-1-mahesh@bandewar.net>
 <20171104235346.GA17170@mail.hallyn.com>
 <CAF2d9jg1tZz-hnVBeXm3geq7jSBt5v5w6+p5B1V-7huS4qbMBA@mail.gmail.com>
 <20171106150302.GA26634@mail.hallyn.com>
 <1510003994.736.0.camel@gmail.com>
 <20171106221418.GA32543@mail.hallyn.com>
 <1510020963.736.42.camel@gmail.com>
 <20171107032310.GA6429@mail.hallyn.com>
 <da764cbf-7522-06a0-6c21-adfa3eaac9c2@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <da764cbf-7522-06a0-6c21-adfa3eaac9c2-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chris hyser <chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting chris hyser (chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org):
> On 11/06/2017 10:23 PM, Serge E. Hallyn wrote:
> >I think I definately prefer what I mentioned in the email to Boris.
> >Basically a "permanent capability bounding set".  The normal bounding
> >set gets reset to a full set on every new user_ns creation.  In this
> >proposal, it would instead be set to the calling task's permanent
> >capability set, which starts (at boot) full, and which privileged
> >tasks can pull capabilities out of.
> 
> Actually, this may solve a similar problem I've been looking at. The
> idea was basically at strategic points in the kernel (possibly LSM
> hook sites, still evaluating, and probably syscall entry) validate
> that a task has not "magically" acquired capabilities that it or
> parent specifically said it cannot have and then take some action
> like say killing it immediately. Using your terms, basically make
> the "permanent capability set" a write-once privilege escalation
> defense. To handle the 0-day threat, perhaps make it writable but
> only with more "restrictive" values.

Would the existing capability bounding set not suffice for that?

The 'permanent' bounding set turns out to not be a good fit for
the problem being discussed in this thread, but please feel free
to start a new thread if you want to discuss your use case.
