From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH 1/2] sigaltstack: implement SS_AUTODISARM flag
Date: Sat, 5 Mar 2016 10:40:56 +0300
Message-ID: <56DA8D88.5060301@list.ru>
References: <1456781345-8243-1-git-send-email-stsp@list.ru>
 <1456781345-8243-2-git-send-email-stsp@list.ru>
 <CALCETrWMJ-2xovNnPgsKZtmBWZpqBERCTzne2L81x0tcm0BhbQ@mail.gmail.com>
 <56DA8D25.20600@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56DA8D25.20600-cmBhpYW9OiY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stas Sergeev <stsp-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-api@vger.kernel.org

05.03.2016 10:39, Stas Sergeev =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> 05.03.2016 01:22, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> On Mon, Feb 29, 2016 at 1:29 PM, Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
>>> This patch implements the SS_AUTODISARM flag that can be ORed with
>>> SS_ONSTACK when forming ss_flags.
>>> When this flag is set, sigaltstack will be disabled when entering
>>> the signal handler; more precisely, after saving sas to uc_stack.
>>> When leaving the signal handler, the sigaltstack is restored by
>>> uc_stack.
>>> When this flag is used, it is safe to switch from sighandler with
>>> swapcontext(). Without this flag, the subsequent signal will corrup=
t
>>> the state of the switched-away sighandler.
>>>
>> This looks reasonable to me with one exception: how does a user
>> program detect the presence of this feature?
> Compile-time detection:
> #ifdef SS_AUTODISARM
>   # I have this feature
>   ...
> #endif
>
> Run-time detection:
> int err =3D sigaltstack(SS_ONSTACK | SS_AUTODISARM);
> if (err =3D=3D EINVAL) {
I guess I mean here
if (err && errno =3D=3D EINVAL)
