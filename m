From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
Date: Mon, 24 Apr 2017 20:35:06 +0200
Message-ID: <CAEiveUevKr4FR49PnvKU2f3YzUF2SUvcxjq8Gpsj=Qf1ty+AGg@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-3-git-send-email-tixxdz@gmail.com> <CALCETrXFp-apnfRPg9qx6E7g3KDU8DanBW1pMUnA1zShrB5xKg@mail.gmail.com>
 <CAGXu5jJ5dm8yJJ34tEyOP78OxUr2awXmNhm6RaVP8jE4q+L5Ng@mail.gmail.com>
 <CALCETrUueOx1tqj+Ru93KGpy2HHR-A_GQ6DrAppiomkPTtX7Lw@mail.gmail.com>
 <CAGXu5jJBp6VHvDP9182hJgvzS2sBUbUFpmZZ+196K2FcEHUxzw@mail.gmail.com>
 <CALCETrVZ2KH4s2uGW2J3zUQ8RNsrq=N7pJP=YDqd=+cp6fJW=g@mail.gmail.com>
 <CAGXu5jJTdL7To2JsQUXyg6B7Xbb0kow6sXH-L+teVi88=gm7MQ@mail.gmail.com>
 <CALCETrXzZwz4a9uhQfdHb4L2afApTvVLPwVx640vvV-fzbCR0w@mail.gmail.com>
 <CAEiveUcx8fwQgXdLPeMNsTjX2KPhQKH__a-XzcHko_1aCmh4sg@mail.gmail.com>
 <CALCETrUT73CcPQx2T=1zWbOUhw9r-c_YqXw5-KTwxgWPgXuTwA@mail.gmail.com>
 <CAGXu5jLV+WZyj+xnxVFkFEgEthNt6eXdcSgHT-=85mJ1ECZ1Rw@mail.gmail.com>
 <CAEiveUdQYbx8d9B68n2M12fhu3s8web3zCvkc-C9FWtNnbELuA@mail.gmail.com> <CAGXu5jL_-cxidy_O4ORaN0iX9o7=hsi3DYTRvQs5w5363Z+MVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jL_-cxidy_O4ORaN0iX9o7=hsi3DYTRvQs5w5363Z+MVg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mauro
List-Id: linux-api@vger.kernel.org

On Mon, Apr 24, 2017 at 8:02 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Mon, Apr 24, 2017 at 7:25 AM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Sat, Apr 22, 2017 at 9:29 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>>> On Fri, Apr 21, 2017 at 11:51 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>> On Fri, Apr 21, 2017 at 5:12 PM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>> On Sat, Apr 22, 2017 at 1:51 AM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>>>
>> [...]
>>>>> * DCCP use after free CVE-2017-6074
>>>>> * n_hldc CVE-2017-2636
>>>>> * XFRM framework CVE-2017-7184
>>>>> * L2TPv3 CVE-2016-10200
>>>>>
>>>>> Most of these need CAP_NET_ADMIN to be autoloaded, however we also
>>>>> need CAP_NET_ADMIN for other things... therefore it is better to have
>>>>> an extra facility that could coexist with CAP_NET_ADMIN and other
>>>>> sandbox features.
>>>>>
>>>>
>>>> I agree that the feature is important, but I think your implementation
>>>> is needlessly dangerous.  I imagine that the main uses that you care
>>>> about involve containers.  How about doing it in a safer way that
>>>> works for containers?  I can think of a few.  For example:
>>>>
>>>> 1. A sysctl that, if set, prevents autoloading outside the root
>>>> userns.  This isn't very flexible at all, but it might work.
>>>>
>>>> 2. Your patch, but require privilege within the calling namespace to
>>>> set the prctl.
>>>
>>> How about CAP_SYS_ADMIN || no_new_privs?
>>>
>>> -Kees
>>>
>>
>> Yes I can update as per Andy suggestion to require privileges inside
>> the calling namespace to set prctl. Other options that are not prctl
>> based have more variants, that make them hard to use.
>>
>> So I would got with CAP_SYS_ADMIN in the calling userns ||
>> no_new_privs , I would have said CAP_SYS_MODULE in the userns but it
>> seems better to standardize on CAP_SYS_ADMIN to set the prctl.
>
> Andy's concern is that it would provide an escalation from SYS_MODULE
> to SYS_ADMIN through some privileged process being tricked through a
> missing API provided by modules, so we have to use either SYS_ADMIN ||
> nnp.

Yes, I would say that programs expect that maybe such functionality is
not provided, but we don't know. I will update.

Thanks!


-- 
tixxdz
