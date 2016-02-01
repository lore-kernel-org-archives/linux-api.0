From: Stas Sergeev <stsp@list.ru>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Mon, 1 Feb 2016 20:26:53 +0300
Message-ID: <56AF955D.7060601@list.ru>
References: <56AE3369.2090709@list.ru> <56AE3626.7080706@list.ru>
 <20160201160625.GA18276@redhat.com> <20160201170958.GA20735@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160201170958.GA20735@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Amanieu d'Antras <amanieu@gmail.com>, Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jason Low <jason.low2@hp.com>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Andrea Arcangeli <aarcange@redhat.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Josh Triplett <josh@joshtriplett.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Paul Moore <pmoore@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, Vladimir Davydov <vdavydov@parallels.com>
List-Id: linux-api@vger.kernel.org

01.02.2016 20:09, Oleg Nesterov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On 02/01, Oleg Nesterov wrote:
>>> +        onsigstack =3D on_sig_stack(sp);
>>> +        if (ss_size =3D=3D 0) {
>>> +            switch (ss_flags) {
>>> +            case 0:
>>> +                error =3D -EPERM;
>>> +                if (onsigstack)
>>> +                    goto out;
>>> +                current->sas_ss_sp =3D 0;
>>> +                current->sas_ss_size =3D 0;
>>> +                current->sas_ss_flags =3D SS_DISABLE;
>>> +                break;
>>> +            case SS_ONSTACK:
>>> +                /* re-enable previously disabled sas */
>>> +                error =3D -EINVAL;
>>> +                if (current->sas_ss_size =3D=3D 0)
>>> +                    goto out;
>>> +                break;
>>> +            default:
>>> +                break;
>>> +            }
>> and iiuc the "default" case allows you to write SS_DISABLE into ->sa=
s_ss_flags
>> even if on_sig_stack().
>>
>> So the sequence is
>>
>> 	// running on alt stack
>>
>> 	sigaltstack(SS_DISABLE);
>>
>> 	temporary_run_on_another_stack();
>>
>> 	sigaltstack(SS_ONSTACK);
>>
>> and SS_DISABLE saves us from another SA_ONSTACK signal, right?
>>
>> But afaics it can only help after we change the stack. Suppose that =
SA_ONSTACK signal
>> comess before temporary_run_on_another_stack(). get_sigframe() shoul=
d be fine after
>> your changes (afaics), it won't pick the alt stack after SS_DISABLE.
>>
>> However, unless I missed something save_altstack_ex() will record SS=
_ONSTACK in
>> uc_stack->ss_flags, and after return from signal handler restore_alt=
stack() will
>> enable alt stack again?
> OK, I didn't notice you modified save_altstack_ex() to use ->sas_ss_f=
lags instead
> of sas_ss_flags()... still doesn't look right, in this case restore_a=
ltstack() will
> not restore sas_ss_size/sas_ss_sp and they can be changed by signal h=
andler.
How?
Trying to change them in a sighandler with sigaltstack()
will get EPERM. And if you change them in uc_stack without
setting ss_flags back to SS_ONSTACK, they should better be ignored.

> Anyway, whatever I missed I agree with Andy, SS_FORCE looks simpler a=
nd better to me.
But perhaps you missed the most important thing, that
it is not possible to change the altstack in sighandler - you'll
get EPERM, even with my patch. But with SS_FORCE this is
exactly not the case. So I'd like you to confirm your opinion
after all the implementation details are understood.
Also it would be interesting to know what do you think about
just removing the EPERM check instead of this all. There are
3 possibilities to choose from, not 2. Removing EPERM looks
simplest.
