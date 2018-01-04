From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?=
        <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv4 0/2] capability controlled user-namespaces
Date: Wed, 3 Jan 2018 21:53:45 -0800
Message-ID: <CAF2d9jhB56O6dGVokRtU46sbvJk4891Oa6A86okWbWptcG=pMg@mail.gmail.com>
References: <20180103072642.161742-1-mahesh@bandewar.net> <87po6qzycp.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87po6qzycp.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Security <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 3, 2018 at 8:44 AM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org> writes:
>
>> From: Mahesh Bandewar <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>
>> TL;DR version
>> -------------
>> Creating a sandbox environment with namespaces is challenging
>> considering what these sandboxed processes can engage into. e.g.
>> CVE-2017-6074, CVE-2017-7184, CVE-2017-7308 etc. just to name few.
>> Current form of user-namespaces, however, if changed a bit can allow
>> us to create a sandbox environment without locking down user-
>> namespaces.
>
> In other conversations it appears it has been pointed out that user
> namespaces are not necessarily safe under no_new_privs.  In theory
> user namespaces should be safe but in practice not so much.
>
> So let me ask.  Would your concerns be addressed if we simply made
> creation and joining of user namespaces impossible in a no_new_privs
> sandbox?
>
Isn't this another form of locking down user-ns similar to setting per
user-ns sysctl max_userns = 0?

Having said that, not allowing processes to create and/or attach
user-namespaces is going to be problematic and possibly a regression.
This (current) patchset doesn't do that. It allows users to create
user-ns's of any depth and number permitted by per-ns max_userns
sysctl. However one can decide what to take-off and what to leave in
terms of capabilities for the sandbox environment.

--mahesh..

> Eric
>
[...]
