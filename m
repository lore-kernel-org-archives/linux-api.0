From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Sat, 10 Oct 2009 15:32:35 +0900
Message-ID: <2f11576a0910092332s6e0e3dcs35864e3a2164be0@mail.gmail.com>
References: <20091009134354.12A7.A69D9226@jp.fujitsu.com>
	 <20091009171344.3fc5f28b.akpm@linux-foundation.org>
	 <3e8340490910091922g7891b31al649e91f15ffae687@mail.gmail.com>
	 <20091009194250.eb76e338.akpm@linux-foundation.org>
	 <3e8340490910091957t21eb16e0r63eba2314ddb83a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753303AbZJJGdO@vger.kernel.org>
In-Reply-To: <3e8340490910091957t21eb16e0r63eba2314ddb83a8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>, linux-api@vger.kernel.org, Timo Sirainen <tss@iki.fi>
List-Id: linux-api@vger.kernel.org

(Doh, I've forgot cc to original author. sorry. cc to timo.)

Hi

very interesting discussion. great.


2009/10/10 Bryan Donlan <bdonlan@gmail.com>:
> On Fri, Oct 9, 2009 at 10:42 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>
>>> >> + __ __ __ __ __ __ __ __ __ __ __ __ __ __ res +=3D access_proc=
ess_vm(task, mm->env_start,
>>
>> Your email client is converting tabs to non-ascii crap. =A0gmail. =A0=
Sigh.
>
> Weird ... I'll have to see if I can do something about that :/
>
>> OK.
>>
>> But there's no way in which the reader of either the patch or the
>> resulting code can discover this subtlety.
>
> I didn't write the log message or the code - I just mentioned these
> same issues back in the lkml thread :) But yes, this should be
> mentioned somewhere.
>

This is documented in access_process_vm.

3224/*
3225 * Access another process' address space.
3226 * Source/target buffer must be kernel space,
3227 * Do not walk the page table directly, use get_user_pages
3228 */
3229int access_process_vm(struct task_struct *tsk, unsigned long addr,
void *buf, int len, int write)
3230{
3231        struct mm_struct *mm;
3232        struct vm_area_struct *vma;
3233        void *old_buf =3D buf;
3234
3235        mm =3D get_task_mm(tsk);
3236        if (!mm)
3237                return 0;
3238
3239        down_read(&mm->mmap_sem);
3240        /* ignore errors, just check how much was successfully
transferred */
3241        while (len) {

However, yes, it is pretty bad place ;)
/* ignore errors, just check how much was successfully transferred */
comment should
be placed in function header comment.

I think separate another patch is better.


>>> The solution is to use the seqlock to detect this, and prevent the
>>> secret information from ever making it back to process B's userspac=
e.
>>> Note that it's not enough to just recheck arg_start, as process A m=
ay
>>> reassign the proctitle area back to its original position after hav=
ing
>>> it somewhere else for a while.
>>
>> Well seqlock is _a_ solution. =A0Another is to use a mutex or an rws=
em
>> around the whole operation.
>>
>> With the code as you propose it, what happens if a process sits in a
>> tight loop running setproctitle? =A0Do other processes running `ps' =
get
>> stuck in a livelock until the offending process gets scheduled out?
>
> It does seem like a maximum spin count should be put in there - and
> maybe a timeout as well (since with FUSE etc it's possible to enginee=
r
> page faults that take arbitrarily long).
> Also, it occurs to me that:

makes sense.
I like maximum spin rather than timeout.


>> + =A0 =A0 do {
>> + =A0 =A0 =A0 =A0 =A0 =A0 seq =3D read_seqbegin(&mm->arg_lock);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D mm->arg_end - mm->arg_start;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (len > PAGE_SIZE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D PAGE_SIZE;
>
> If arg_end or arg_start are modified after this, is it truly safe to
> assume that len will remain <=3D PAGE_SIZE without a memory barrier
> before the conditional?

1) access_process_vm() doesn't return error value.
2) read_seqretry(&mm->arg_lock, seq)) check seq, not mm->arg_start or l=
en.

then, if arg_{start,end} is modified, access_process_vm() may return 0
and strnlen
makes bad calculation, but read_seqretry() can detect its modify
rightly. I think.
