From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 3/4] arm/syscalls: Optimize address limit check
Date: Tue, 29 Aug 2017 12:54:43 -0700
Message-ID: <CAGXu5jKuk9589qap=74kPtefm=xKY0ORDH37W_3iZPd_7yc8VQ@mail.gmail.com>
References: <20170814213732.104301-1-thgarnie@google.com> <20170814213732.104301-3-thgarnie@google.com>
 <CAJcbSZG1b7ObJAv6Kmp-fR3vZRg7AdbcgqDceGB95r-72Yv0yg@mail.gmail.com> <CAJcbSZEd10fMp6OSgSYv_Wmt=wX5fw_Gu-_N=fM_QmP==wUMew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJcbSZEd10fMp6OSgSYv_Wmt=wX5fw_Gu-_N=fM_QmP==wUMew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, =?UTF-8?Q?Lothar_Wa=C3=9Fmann?= <LW-AvR2QvxeiV7DiMYJYoSAnRvVK+yQ3ZXh@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 29, 2017 at 7:32 AM, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Aug 22, 2017 at 9:42 AM, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> On Mon, Aug 14, 2017 at 2:37 PM, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>> Disable the generic address limit check in favor of an architecture
>>> specific optimized implementation. The generic implementation using
>>> pending work flags did not work well with ARM and alignment faults.
>>>
>>> The address limit is checked on each syscall return path to user-mode
>>> path as well as the irq user-mode return function. If the address limit
>>> was changed, a function is called to report data corruption (stopping
>>> the kernel or process based on configuration).
>>>
>>> The address limit check has to be done before any pending work because
>>> they can reset the address limit and the process is killed using a
>>> SIGKILL signal. For example the lkdtm address limit check does not work
>>> because the signal to kill the process will reset the user-mode address
>>> limit.
>>>
>>> Signed-off-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>
>> Any feedback?
>
> CCing LW-AvR2QvxeiV7DiMYJYoSAnRvVK+yQ3ZXh@public.gmane.org who experienced the same issue this patch
> proposal fix.
>
> Russell: Any feedback?

These implement Russell's suggestion. An Ack here would be nice. :) I
can't throw these into the ARM patch tracker because they depend on
stuff in -next (and the commit that needs to be reverted is in tglx's
tree).

Regardless, these all test out correctly for me, so:

Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Tested-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

In a perfect world, these 4 patches should go together with the other
address limit check patches in tglx's tree. Thomas (Gleixner), can you
update your tree for the merge window? At the very least, we need to
revert 73ac5d6a2b6ac ("arm/syscalls: Check address limit on user-mode
return"), which has caused infinite loops in some cases. Better to
take all 4 patches in this series, though.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
