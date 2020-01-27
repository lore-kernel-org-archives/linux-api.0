From: Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 03/34] ns: Introduce Time Namespace
Date: Mon, 27 Jan 2020 14:19:27 +0000
Message-ID: <c0a13024-5f56-133a-61f1-c4185f5ac210@gmail.com>
References: <20191112012724.250792-1-dima@arista.com>
 <20191112012724.250792-4-dima@arista.com>
 <CACT4Y+b70bRRS2XD3yxhBoy4E-LFy_K3wMrjeuPmiEvaPe_c2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACT4Y+b70bRRS2XD3yxhBoy4E-LFy_K3wMrjeuPmiEvaPe_c2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dmitry Safonov <dima-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Adrian Reber <adrian-5+Cda9B46AM@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Dmitry,

On 1/27/20 2:12 PM, Dmitry Vyukov wrote:
> On Tue, Nov 12, 2019 at 2:30 AM Dmitry Safonov <dima-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org> wrote:
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 3f7f8cdbc471..037abc28c414 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -13172,6 +13172,8 @@ T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
>>  S:     Maintained
>>  F:     fs/timerfd.c
>>  F:     include/linux/timer*
>> +F:     include/linux/time_namespace.h
>> +F:     kernel/time_namespace.c
> 
> Is it supposed to be kernel/time/namespace.c?

Yes, thanks for catching this.
I'll send a fixup shortly.

Thanks,
          Dmitry
