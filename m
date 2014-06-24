From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v7 4/9] seccomp: move no_new_privs into seccomp
Date: Tue, 24 Jun 2014 12:50:02 -0700
Message-ID: <CAGXu5jJjuNmf=FRzUPMChvL4D_xkg034pUbRAbaK38f37GYC0A@mail.gmail.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
	<1403560693-21809-5-git-send-email-keescook@chromium.org>
	<20140624191815.GA3623@redhat.com>
	<CALCETrVgpP=zOtiQafVgcic2T95TdEM5DTvHYXWTbcZ14xBqHQ@mail.gmail.com>
	<20140624193055.GA4482@redhat.com>
	<CALCETrU9x05ADgz9JToiw_BuCPz1h0xmOh=1R3eojL9far1aEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrU9x05ADgz9JToiw_BuCPz1h0xmOh=1R3eojL9far1aEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 24, 2014 at 12:34 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Tue, Jun 24, 2014 at 12:30 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On 06/24, Andy Lutomirski wrote:
>>>
>>> On Tue, Jun 24, 2014 at 12:18 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> >>
>>> >> -struct seccomp { };
>>> >> +struct seccomp {
>>> >> +     unsigned long flags;
>>> >> +};
>>> >
>>> > A bit messy ;)
>>> >
>>> > I am wondering if we can simply do
>>> >
>>> >         static inline bool current_no_new_privs(void)
>>> >         {
>>> >                 if (current->no_new_privs)
>>> >                         return true;
>>> >
>>> >         #ifdef CONFIG_SECCOMP
>>> >                 if (test_thread_flag(TIF_SECCOMP))
>>> >                         return true;
>>> >         #endif
>>>
>>> Nope -- privileged users can enable seccomp w/o nnp.
>>
>> Indeed, I am stupid.
>>
>> Still it would be nice to cleanup this somehow. The new member is only
>> used as a previous ->no_new_privs, just it is long to allow the concurent
>> set/get. Logically it doesn't even belong to seccomp{}.
>
> We could add an unsigned long atomic flags field to task_struct.

I thought that had gotten shot down originally, but given the current
state of the patch series, it would be effectively identical, since my
earlier attempt at keeping sizes the same (with alternate accessors)
was too messy. I will change this as well.

> Grr.  Why isn't there an unsigned *int* atomic bitmask type?  Even u64
> would be better.  unsigned long is useless.

Useless beyond 32 bits. ;)

-Kees

-- 
Kees Cook
Chrome OS Security
