From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?=
        <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend 1/2] capability: introduce sysctl for controlled
 user-ns capability whitelist
Date: Fri, 10 Nov 2017 12:43:47 +0900
Message-ID: <CAF2d9jg__SpwvqwYuiXC2d-WxC2C3wq-o-66=K5+ze+BMFPkdQ@mail.gmail.com>
References: <20171103004433.39954-1-mahesh@bandewar.net> <20171109173037.GC26229@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171109173037.GC26229-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 10, 2017 at 2:30 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> Quoting Mahesh Bandewar (mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org):
>> From: Mahesh Bandewar <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>
>> Add a sysctl variable kernel.controlled_userns_caps_whitelist. This
>
> I understand the arguments in favor of whitelists in most cases for
> security purposes.  But given that you've said the goal here is to
> prevent use of a capability in a user namespace when a CVE has been
> found, a whitelist seems the wrong choice, since
>
> 1. it means that an attacker may through some other means be able
> to add a capability back into the whitelist when you specifically
> wanted to drop it.  With a blacklist, you could say "once a cap has
> been dropped it can never be re-added without rebooting".
> 2. it means by default all capabilities will be denied once the
> switch is pulled which is specifically not what you want in this
> case.
> 3. the admin can't just say "drop CAP_NET_ADMIN", but needs to
> know to echo ~CAP_NET_ADMIN.
>
> Why not make it a blacklist, and once a cap is dropped it can
> never be re-added?
>
Well, I'm not going to deny that blacklist approach would work equally
well but code becomes little simpler when you use the whitelist
approach. especially less complicated when a new capability needs to
be added (not that we add capabilities very often) but that would be
something one would have to pay attention to. However with this
approach I can just the CAP_FULL_SET which is readily available.

Having said that I specifically don't have strong preference in this
regard (whitelist vs. blacklist).

> -serge
