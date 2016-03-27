From: Loganaden Velvindron <loganaden-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [RFC v1 00/17] seccomp-object: From attack
 surface reduction to sandboxing
Date: Sun, 27 Mar 2016 05:03:10 +0000
Message-ID: <CAOp4FwTc6C=E2fynp85tVWrZpthMvFpJFmV=HG+czHH_D41OXA@mail.gmail.com>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
	<CAGXu5jLModth62F8PsFfNVCL=7PrAd+kT_NEsMP5WwOJvLS8EQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jLModth62F8PsFfNVCL=7PrAd+kT_NEsMP5WwOJvLS8EQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk-ASgREoAs3yw@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 24, 2016 at 4:24 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrot=
e:
> On Wed, Mar 23, 2016 at 6:46 PM, Micka=C3=ABl Sala=C3=BCn <mic@digiko=
d.net> wrote:
>> Hi,
>>
>> This series is a proof of concept (not ready for production) to exte=
nd seccomp
>> with the ability to check argument pointers of syscalls as kernel ob=
ject (e.g.
>> file path). This add a needed feature to create a full sandbox manag=
ed by
>> userland like the Seatbelt/XNU Sandbox or the OpenBSD Pledge. It was=
 initially
>> inspired from a partial seccomp-LSM prototype [1] but has evolved a =
lot since :)
>
> This is interesting! I'd really like to get argument inspection
> working. I'm going to spend some time examining this series more
> closely, but my initial reaction is that I'm suspicious of the ToCToU
> checking -- I'd rather there be no race at all. As for the bug-fixes,
> I'll get those pulled in now. Thanks!
>

Personally, I love the OpenBSD pledge() mechanism. It makes it so easy
to apply attack surface reduction. If seccomp moves closer to pledge,
that would be great.

See here:
https://github.com/dimkr/libwaive
