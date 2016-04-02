From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] x86: Add a turbo mode sysctl
Date: Sat, 2 Apr 2016 13:21:41 -0700
Message-ID: <CALCETrUfy-yZ6FD7J3AwhP7KB5eZ+YRMrKS_CyNDLvJwmiC49g@mail.gmail.com>
References: <cd6157244ae75145e2529a1d73f6174cd829ac9c.1459525715.git.luto@kernel.org>
 <alpine.DEB.2.11.1604011803390.3978@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1604011803390.3978@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 1, 2016 at 9:10 AM, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> On Fri, 1 Apr 2016, Andy Lutomirski wrote:
>> +static void update_local_turbo_mode(void *dummy)
>> +{
>> +     unsigned long cr0 = read_cr0();
>> +
>> +     /*
>> +      * KVM doesn't properly handle CD.
>> +      *
>> +      * XXX: this may interact poorly with CPU hotplug.
>
> Please cc these crazy folks who cleanup the hotplug mess so they can put it on
> their todo list.
>
>> +      */
>> +
>> +     if (turbo_mode)
>> +             write_cr0(cr0 & ~X86_CR0_CD);
>> +     else
>> +             write_cr0(cr0 | X86_CR0_CD);
>
> I think proper turbo mode disable requires ~(X86_CR0_CD | X86_CR0_NW)

I thought that made no difference on family 6 and P4 and was actively
dangerous (disabled coherency) before.  At least, that's what the
table of caching modes and the footnote seems to say.

>
>> +static void update_turbo_mode(void)
>> +{
>> +     on_each_cpu(update_local_turbo_mode, NULL, 1);
>> +
>> +     if (!turbo_mode)
>> +             wbinvd();
>
> You really want to do wbinvd() on each cpu to make sure that each cpu gets out
> of that turbo thing.

Nah, this is an explicit optimization to de-turboize as quickly as possible:

"The instruction then issues a special-function bus cycle that directs
external caches to also write
back modified data and another bus cycle to indicate that the external
caches should be invalidated."

I think we should merge this patch and add a special-case so that
calling unlink on turbo_mode sets it to zero.  Then people who rm -rf
/ will brick their systems more slowly :)

--Andy
