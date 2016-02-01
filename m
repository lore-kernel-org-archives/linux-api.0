From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Mon, 1 Feb 2016 19:57:45 +0300
Message-ID: <56AF8E89.5090400@list.ru>
References: <56AE3369.2090709@list.ru> <56AE3626.7080706@list.ru>
 <20160201160625.GA18276@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160201160625.GA18276-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

01.02.2016 19:06, Oleg Nesterov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> Honestly, I am not sure I understand what this patch does and why, an=
d it is
> white space damaged, please fix.
Arrr.

> On 01/31, Stas Sergeev wrote:
>> linux implements the sigaltstack() in a way that makes it impossible=
 to
>> use with swapcontext(). Per the man page, sigaltstack is allowed to =
return
>> EPERM if the process is altering its sigaltstack while running on
>> sigaltstack.
>> This is likely needed to consistently return oss->ss_flags, that ind=
icates
>> whether the process is being on sigaltstack or not.
>> Unfortunately, linux takes that permission to return EPERM too liter=
ally:
>> it returns EPERM even if you don't want to change to another sigalts=
tack,
>> but only want to temporarily disable sigaltstack with SS_DISABLE.
>> You can't use swapcontext() without disabling sigaltstack first, or =
the
>> stack will be re-used and overwritten by a subsequent signal.
> So iiuc you want to switch the stack from the signal handler running =
on the
> alt stack, and you need to ensure that another SA_ONSTACK signal won'=
t corrupt
> the alt stack in between, right?
Yes.

> Perhaps you can update the changelog to explain why do we want this c=
hange.
Beyond the fact that swapcontext() is then usable for switching
in/out of sigaltstack? But this is already mentioned and I have no
other reason for getting this in.

>> @@ -2550,8 +2551,11 @@ static inline int sas_ss_flags(unsigned long =
sp)
>>   {
>>       if (!current->sas_ss_size)
>>           return SS_DISABLE;
>> -
>> -    return on_sig_stack(sp) ? SS_ONSTACK : 0;
>> +    if (on_sig_stack(sp))
>> +        return SS_ONSTACK;
>> +    if (current->sas_ss_flags =3D=3D SS_DISABLE)
>> +        return SS_DISABLE;
>> +    return 0;
> So this always return SS_ONSTACK if on_sig_stack(), see below.
>
>> +        onsigstack =3D on_sig_stack(sp);
>> +        if (ss_size =3D=3D 0) {
>> +            switch (ss_flags) {
>> +            case 0:
>> +                error =3D -EPERM;
>> +                if (onsigstack)
>> +                    goto out;
>> +                current->sas_ss_sp =3D 0;
>> +                current->sas_ss_size =3D 0;
>> +                current->sas_ss_flags =3D SS_DISABLE;
>> +                break;
>> +            case SS_ONSTACK:
>> +                /* re-enable previously disabled sas */
>> +                error =3D -EINVAL;
>> +                if (current->sas_ss_size =3D=3D 0)
>> +                    goto out;
>> +                break;
>> +            default:
>> +                break;
>> +            }
> and iiuc the "default" case allows you to write SS_DISABLE into ->sas=
_ss_flags
> even if on_sig_stack().
>
> So the sequence is
>
> 	// running on alt stack
>
> 	sigaltstack(SS_DISABLE);
>
> 	temporary_run_on_another_stack();
>
> 	sigaltstack(SS_ONSTACK);
>
> and SS_DISABLE saves us from another SA_ONSTACK signal, right?
Yes.
Note: there is a test-case in that patch serie from which
you can see or copy/paste the sample code.

> But afaics it can only help after we change the stack. Suppose that S=
A_ONSTACK signal
> comess before temporary_run_on_another_stack(). get_sigframe() should=
 be fine after
> your changes (afaics), it won't pick the alt stack after SS_DISABLE.
>
> However, unless I missed something save_altstack_ex() will record SS_=
ONSTACK in
> uc_stack->ss_flags, and after return from signal handler restore_alts=
tack() will
> enable alt stack again?
I don't think so. Please see the following hunk:

diff --git a/include/linux/signal.h b/include/linux/signal.h
index 92557bb..844b113 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -432,7 +432,7 @@ int __save_altstack(stack_t __user *, unsigned long=
);
      stack_t __user *__uss =3D uss; \
      struct task_struct *t =3D current; \
      put_user_ex((void __user *)t->sas_ss_sp, &__uss->ss_sp); \
-    put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
+    put_user_ex(t->sas_ss_flags, &__uss->ss_flags); \
      put_user_ex(t->sas_ss_size, &__uss->ss_size); \
  } while (0);

It pretends as if it changes __save_altstack(), but the reality
is that it actually changes save_altstack_ex(). This is some bug
in git perhaps (or it can't parse macros), I didn't apply any manual
editing to the patch.
The hunk that really modifies __save_altstack() also exists btw:

@@ -3168,7 +3186,7 @@ int __save_altstack(stack_t __user *uss, unsigned=
=20
long sp)
  {
      struct task_struct *t =3D current;
      return  __put_user((void __user *)t->sas_ss_sp, &uss->ss_sp) |
-        __put_user(sas_ss_flags(sp), &uss->ss_flags) |
+        __put_user(t->sas_ss_flags, &uss->ss_flags) |
          __put_user(t->sas_ss_size, &uss->ss_size);
  }

So I understand this is very confusing, but I think the patch
is correct.

Do you think adding the SS_FORCE flag would be a better solution?
