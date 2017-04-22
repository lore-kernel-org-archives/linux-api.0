From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
Date: Fri, 21 Apr 2017 23:51:44 -0700
Message-ID: <CALCETrUT73CcPQx2T=1zWbOUhw9r-c_YqXw5-KTwxgWPgXuTwA@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-3-git-send-email-tixxdz@gmail.com> <CALCETrXFp-apnfRPg9qx6E7g3KDU8DanBW1pMUnA1zShrB5xKg@mail.gmail.com>
 <CAGXu5jJ5dm8yJJ34tEyOP78OxUr2awXmNhm6RaVP8jE4q+L5Ng@mail.gmail.com>
 <CALCETrUueOx1tqj+Ru93KGpy2HHR-A_GQ6DrAppiomkPTtX7Lw@mail.gmail.com>
 <CAGXu5jJBp6VHvDP9182hJgvzS2sBUbUFpmZZ+196K2FcEHUxzw@mail.gmail.com>
 <CALCETrVZ2KH4s2uGW2J3zUQ8RNsrq=N7pJP=YDqd=+cp6fJW=g@mail.gmail.com>
 <CAGXu5jJTdL7To2JsQUXyg6B7Xbb0kow6sXH-L+teVi88=gm7MQ@mail.gmail.com>
 <CALCETrXzZwz4a9uhQfdHb4L2afApTvVLPwVx640vvV-fzbCR0w@mail.gmail.com> <CAEiveUcx8fwQgXdLPeMNsTjX2KPhQKH__a-XzcHko_1aCmh4sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEiveUcx8fwQgXdLPeMNsTjX2KPhQKH__a-XzcHko_1aCmh4sg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Arnaldo Carvalho de Melo <acme@>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 21, 2017 at 5:12 PM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sat, Apr 22, 2017 at 1:51 AM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> [...]
>>>> I personally like my implicit_rights idea, and it might be interesting
>>>> to prototype it.
>>>
>>> I don't like blocking a needed feature behind a large super-feature
>>> that doesn't exist yet. We'd be able to refactor this code into using
>>> such a thing in the future, so I'd prefer to move ahead with this
>>> since it would stop actual exploits.
>>
>> I don't think the super-feature is so hard, and I think we should not
>> add the per-task thing the way it's done in this patch.  Let's not add
>> per-task things where the best argument for their security is "not
>> sure how it would be exploited".
>
> Actually the XFRM framework CVE-2017-7184 [1] is one real example, of
> course there are others. The exploit was used on a generic distro
> during a security contest that distro is Ubuntu. That distro will
> never provide a module autoloading restriction by default to not harm
> it's users. Consumers or containers/sandboxes then can run their
> confined apps using such facilities.
>
> These bugs will stay in embedded devices that use these generic
> distros for ever.
>
>> Anyway, I think the sysctl is really the important bit.  The per-task
>> setting is icing on the cake IMO.  One upon a time autoload was more
>> important, but these days modaliases are supposed to do most of the
>> work.  I bet that modern distros don't need unprivileged autoload at
>> all.
>
> Actually I think they do and we can't just change that. Users may
> depend on it, it is a well established facility.
>
> Now the other problem is CAP_NET_ADMIN which does lot of things, it is
> more like the CAP_SYS_ADMIN.
>
> This is a quick list that I got from only the past months, I'm pretty
> sure there are more:
>
> * DCCP use after free CVE-2017-6074
> * n_hldc CVE-2017-2636
> * XFRM framework CVE-2017-7184
> * L2TPv3 CVE-2016-10200
>
> Most of these need CAP_NET_ADMIN to be autoloaded, however we also
> need CAP_NET_ADMIN for other things... therefore it is better to have
> an extra facility that could coexist with CAP_NET_ADMIN and other
> sandbox features.
>

I agree that the feature is important, but I think your implementation
is needlessly dangerous.  I imagine that the main uses that you care
about involve containers.  How about doing it in a safer way that
works for containers?  I can think of a few.  For example:

1. A sysctl that, if set, prevents autoloading outside the root
userns.  This isn't very flexible at all, but it might work.

2. Your patch, but require privilege within the calling namespace to
set the prctl.

3. A per-user-ns sysctl.
