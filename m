From: Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCHv8 02/34] lib/vdso: make do_hres and do_coarse as
 __always_inline
Date: Fri, 10 Jan 2020 11:47:43 +0000
Message-ID: <e74a63cb-5248-4473-81a7-d1b2f959ec7a@arm.com>
References: <20191112012724.250792-1-dima@arista.com>
 <20191112012724.250792-3-dima@arista.com>
 <ed2e65ae-75b0-ed79-0a95-90be6b82e6be@arm.com>
 <878smfa66i.fsf@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <878smfa66i.fsf-ecDvlHI5BZPZikZi3RtOZ1XZhhPuCNm+@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Safonov <dima-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Adrian Reber <adrian-5+Cda9B46AM@public.gmane.org>, Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 1/10/20 11:42 AM, Thomas Gleixner wrote:
> Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org> writes:
>> On 11/12/19 1:26 AM, Dmitry Safonov wrote:
>>> +» » vd·=·&vd[CS_HRES_COARSE];
>>> +out_hres:
>>> +» » return·do_hres(vd,·clock,·ts);
>>> » }·else·if·(msk·&·VDSO_COARSE)·{
>>> » » do_coarse(&vd[CS_HRES_COARSE],·clock,·ts);
>>> » » return·0;
>>> » }·else·if·(msk·&·VDSO_RAW)·{
>>> -» » return·do_hres(&vd[CS_RAW],·clock,·ts);
>>> +» » vd·=·&vd[CS_RAW];
>>> +» » /*·goto·allows·to·avoid·extra·inlining·of·do_hres.·*/
>>> +» » goto·out_hres;
>>
>> What is the performance impact of "goto out_hres"?
> 
> On x86 it's invisible at least in my limited testing.

On arm64 as well based on mine as well. Shall we keep the code more readable
here (without goto)?

> 
> Thanks,
> 
>         tglx
> 

-- 
Regards,
Vincenzo
