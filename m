From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 4/4] arm64/syscalls: Move address limit check in loop
Date: Tue, 12 Sep 2017 11:28:50 -0700
Message-ID: <CAGXu5jLXSxoFLnP-YHab0raYjt8nY_tfnCYmE1_9XOAio4MRCw@mail.gmail.com>
References: <1504798247-48833-1-git-send-email-keescook@chromium.org>
 <1504798247-48833-5-git-send-email-keescook@chromium.org> <20170912182727.GB27652@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170912182727.GB27652-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>, Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 12, 2017 at 11:27 AM, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> Hi Kees,
>
> On Thu, Sep 07, 2017 at 08:30:47AM -0700, Kees Cook wrote:
>> From: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>
>> A bug was reported on ARM where set_fs might be called after it was
>> checked on the work pending function. ARM64 is not affected by this bug
>> but has a similar construct. In order to avoid any similar problems in
>> the future, the addr_limit_user_check function is moved at the beginning
>> of the loop.
>>
>> Fixes: cf7de27ab351 ("arm64/syscalls: Check address limit on user-mode return")
>> Reported-by: Leonard Crestez <leonard.crestez-3arQi8VN3Tc@public.gmane.org>
>> Signed-off-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> ---
>>  arch/arm64/kernel/signal.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> What's the plan for this series? It looks like somehow an old v2 of the
> original series made it into mainline, so I'd like to see these fixes get
> in ASAP. I'm still slightly nervous about pathological setting of the
> FSCHECK flag due to e.g. a PMU IRQ causing a livelock in do_notify_resume,
> but that's at least less likely with this fix :/

Hi! I resent this to Ingo to pick up for -tip. I think he's waiting
for -rc1, IIUC. Ingo, can you comment on timing for this getting sent
to Linus?

-Kees

-- 
Kees Cook
Pixel Security
