From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend 1/2] capability: introduce sysctl for controlled
 user-ns capability whitelist
Date: Thu, 9 Nov 2017 22:30:10 -0600
Message-ID: <20171110043010.GA3572@mail.hallyn.com>
References: <20171103004433.39954-1-mahesh@bandewar.net>
 <20171109172201.GA26229@mail.hallyn.com>
 <CAF2d9jhCbZA2J1WCc5MNUssiNSNeP5J8i9VNUETKBGhM4X4t8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAF2d9jhCbZA2J1WCc5MNUssiNSNeP5J8i9VNUETKBGhM4X4t8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Mahesh Bandewar (महेश बंडेवार) (maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
...
> >>
> >>  ==============================================================
> >>
> >> +controlled_userns_caps_whitelist
> >> +
> >> +Capability mask that is whitelisted for "controlled" user namespaces.
> >> +Any capability that is missing from this mask will not be allowed to
> >> +any process that is attached to a controlled-userns. e.g. if CAP_NET_RAW
> >> +is not part of this mask, then processes running inside any controlled
> >> +userns's will not be allowed to perform action that needs CAP_NET_RAW
> >> +capability. However, processes that are attached to a parent user-ns
> >> +hierarchy that is *not* controlled and has CAP_NET_RAW can continue
> >> +performing those actions. User-namespaces are marked "controlled" at
> >> +the time of their creation based on the capabilities of the creator.
> >> +A process that does not have CAP_SYS_ADMIN will create user-namespaces
> >> +that are controlled.
> >
> > Hm.  I think that's fine (the way 'controlled' user namespaces are
> > defined), but that is design decision in itself, and should perhaps be
> > discussed.
> >
> > Did you consider other ways?  What about using CAP_SETPCAP?
> >
> I did try other ways e.g. using another bounding-set etc. but
> eventually settled with this approach because of main two properties -

No, I meant did you try other ways of defining a controlled user
namespace, other than one which is created by a task lacking
CAP_SYS_ADMIN?

...

> >> +The value is expressed as two comma separated hex words (u32). This
> >
> > Why comma separated?  whitespace ok?  Leading 0x ok?  What is the
> > default at boot?  (Obviously the patch tells me, I'm asking for it
> > to be spelled out in the doc)
> >
> I tried multiple ways including representing capabilities in
> string/name form for better readability but didn't want to add
> additional complexities of dealing with strings and possible
> string-related-issues for this. Also didn't want to reinvent the new
> form so settled with something that is widely used (cpu
> bounding/affinity/irq mapping etc.) and is capable of handling growing
> bit set (currently 37 but possibly more later).

Ok, thanks.
