From: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Fri, 9 Oct 2009 22:22:10 -0400
Message-ID: <3e8340490910091922g7891b31al649e91f15ffae687@mail.gmail.com>
References: <20091009134354.12A7.A69D9226@jp.fujitsu.com> <20091009171344.3fc5f28b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964859AbZJJCXk@vger.kernel.org>
In-Reply-To: <20091009171344.3fc5f28b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 9, 2009 at 8:13 PM, Andrew Morton <akpm@linux-foundation.or=
g> wrote:

>> + =A0 =A0 =A0 =A0 =A0 =A0 res =3D access_process_vm(task, mm->arg_st=
art, buffer, len, 0);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (mm->arg_end !=3D mm->env_start)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* PR_SET_PROCTITLE_AREA u=
sed */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 res =3D strnlen(buffer, =
res);
>
> Hang on.
>
> If PR_SET_PROCTITLE_AREA installed a bad address then
> access_process_vm() will return -EFAULT and nothing was written to
> `buffer'?
>
> Also, concurrent PR_SET_PROCTITLE_AREA could cause arg_start and
> arg_end to have inconsistent/incoherent values. =A0This might result =
in a
> fault but it also might result in a read of garbage userspace memory.
>
> I guess all of these issues could be written off as "userspace bugs",
> but our behaviour here isn't nice. =A0We should at least return that
> -EFAULT!.

access_process_vm() does not return an error code - just the number of
bytes successfully transferred. If there's a fault, we just get 0 (or
some intermediate value) back (as discussed on lkml).

>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 res +=3D a=
ccess_process_vm(task, mm->env_start,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0buffer+res, len, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 res =3D st=
rnlen(buffer, res);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> And if access_process_vm() returns a -ve errno here, the code simply
> flies off into the weeds.

This code was originally there - it's just been lifted into an if :)
and since access_process_vm will never return a negative errno, it's
not a problem.

Now, there might be a case for arguing that we should try harder to
get an error code (-EIO if we don't read the number of bytes we asked
for), but /proc/pid/cmdline never has before, and that would then make
this a visible change for consumers of /proc/pid/cmdline. Can ps
handle reading cmdline returning -EIO?

> seqlocks are nice but I have to wonder if they made this patch
> unnecessarily complex. =A0Couldn't we just do:
>
> =A0 =A0 =A0 =A0 PR_SET_PROCTITLE_AREA:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(mm->lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mm->arg_start =3D addr;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mm->arg_end =3D addr + len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(mm->lock);
>
> and
>
> =A0 =A0 =A0 =A0proc_pid_cmdline()
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long addr;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long end;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(mm->lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0addr =3D mm->arg_start;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0end =3D mm->arg_end;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(mm->lock);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0<use `addr' and `len'>
> =A0 =A0 =A0 =A0}
>
> ?

As discussed on the lkml thread, this opens up a nasty race:

Process A: calls PR_SET_PROCTITLE_AREA
Process B: read cmdline:
Process B: spin_lock
Process B: read mm->arg_*
Process B: unlock
Process A: mm->arg_* =3D ...
Process A: free(old_cmdline_area)
Process A: secret_password =3D malloc(...)
Process A: strcpy(secret_password, stuff);
Process B: access_process_vm

If secret_password =3D=3D arg_start, then process B just read secret
information from process A's address space. Since process A has no
idea when or even if process B will complete its read, it has no way
of protecting itself from this, save from never reusing any memory
which has ever been assigned to a proctitle area.

The solution is to use the seqlock to detect this, and prevent the
secret information from ever making it back to process B's userspace.
Note that it's not enough to just recheck arg_start, as process A may
reassign the proctitle area back to its original position after having
it somewhere else for a while.
