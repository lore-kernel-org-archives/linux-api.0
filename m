From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
Date: Mon, 24 Apr 2017 11:02:37 -0700
Message-ID: <CAGXu5jL_-cxidy_O4ORaN0iX9o7=hsi3DYTRvQs5w5363Z+MVg@mail.gmail.com>
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
 <CAGXu5jLV+WZyj+xnxVFkFEgEthNt6eXdcSgHT-=85mJ1ECZ1Rw@mail.gmail.com> <CAEiveUdQYbx8d9B68n2M12fhu3s8web3zCvkc-C9FWtNnbELuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAEiveUdQYbx8d9B68n2M12fhu3s8web3zCvkc-C9FWtNnbELuA@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro
List-Id: linux-api@vger.kernel.org

On Mon, Apr 24, 2017 at 7:25 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
> On Sat, Apr 22, 2017 at 9:29 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Fri, Apr 21, 2017 at 11:51 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>> On Fri, Apr 21, 2017 at 5:12 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
>>>> On Sat, Apr 22, 2017 at 1:51 AM, Andy Lutomirski <luto@kernel.org> wrote:
>>>>
> [...]
>>>> * DCCP use after free CVE-2017-6074
>>>> * n_hldc CVE-2017-2636
>>>> * XFRM framework CVE-2017-7184
>>>> * L2TPv3 CVE-2016-10200
>>>>
>>>> Most of these need CAP_NET_ADMIN to be autoloaded, however we also
>>>> need CAP_NET_ADMIN for other things... therefore it is better to have
>>>> an extra facility that could coexist with CAP_NET_ADMIN and other
>>>> sandbox features.
>>>>
>>>
>>> I agree that the feature is important, but I think your implementation
>>> is needlessly dangerous.  I imagine that the main uses that you care
>>> about involve containers.  How about doing it in a safer way that
>>> works for containers?  I can think of a few.  For example:
>>>
>>> 1. A sysctl that, if set, prevents autoloading outside the root
>>> userns.  This isn't very flexible at all, but it might work.
>>>
>>> 2. Your patch, but require privilege within the calling namespace to
>>> set the prctl.
>>
>> How about CAP_SYS_ADMIN || no_new_privs?
>>
>> -Kees
>>
>
> Yes I can update as per Andy suggestion to require privileges inside
> the calling namespace to set prctl. Other options that are not prctl
> based have more variants, that make them hard to use.
>
> So I would got with CAP_SYS_ADMIN in the calling userns ||
> no_new_privs , I would have said CAP_SYS_MODULE in the userns but it
> seems better to standardize on CAP_SYS_ADMIN to set the prctl.

Andy's concern is that it would provide an escalation from SYS_MODULE
to SYS_ADMIN through some privileged process being tricked through a
missing API provided by modules, so we have to use either SYS_ADMIN ||
nnp.

-Kees

-- 
Kees Cook
Pixel Security
