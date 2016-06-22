From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Documenting ptrace access mode checking
Date: Wed, 22 Jun 2016 21:20:48 +0200
Message-ID: <bb1664d3-bdae-84c4-48b4-cd7f2b503265@gmail.com>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
 <87ziqewc3r.fsf@x220.int.ebiederm.org>
 <CAGXu5jLwuqS5w-Thpngc=hFhXOdM-Q5_G1v9np1sOnmq+v2c4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jLwuqS5w-Thpngc=hFhXOdM-Q5_G1v9np1sOnmq+v2c4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Kees,

On 06/21/2016 10:29 PM, Kees Cook wrote:
> On Tue, Jun 21, 2016 at 12:55 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> Adding Oleg just because he seems to do most of the ptrace related
>> maintenance these days.
>>
>> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>>
>>> Hi Jann, Stephen, et al.
>>>
>>> Jann, since you recently committed a patch in this area, and Stephe=
n,
>>> since you committed 006ebb40d3d much further back in time, I wonder=
 if
>>> you might help me by reviewing the text below that I propose to add=
 to
>>> the ptrace(2) man page, in order to document "ptrace access mode
>>> checking" that is performed in various parts of the kernel-user-spa=
ce
>>> interface. Of course, I welcome input from anyone else as well.
>
> Your text matches my understand of this code. :)

Thanks for reviewing the text!

>>> Here's the new ptrace(2) text. Any comments, technical or terminolo=
gical
>>> fixes, other improvements, etc. are welcome.
>>>
>>> [[
>>>    Ptrace access mode checking
>>>        Various parts of the kernel-user-space API (not just  ptrace=
(2)
>>>        operations), require so-called "ptrace access mode permissio=
ns"
>>>        which are gated  by  Linux  Security  Modules  (LSMs)  such =
 as
>>>        SELinux,  Yama,  Smack,  or  the  default  LSM.  Prior to Li=
nux
>>>        2.6.27, all such checks were of a  single  type.   Since  Li=
nux
>>>        2.6.27, two access mode levels are distinguished:
>>>
>>>        PTRACE_MODE_READ
>>>               For  "read" operations or other operations that are l=
ess
>>>               dangerous, such as: get_robust_list(2); kcmp(2); read=
ing
>>>               /proc/[pid]/auxv,         /proc/[pid]/environ,       =
 or
>>>               /proc/[pid]/stat; or readlink(2) of  a  /proc/[pid]/n=
s/*
>>>               file.
>>>
>>>        PTRACE_MODE_ATTACH
>>>               For  "write"  operations,  or  other operations that =
are
>>>               more    dangerous,    such    as:    ptrace    attach=
ing
>>>               (PTRACE_ATTACH)    to   another   process   or   call=
ing
>>>               process_vm_writev(2).   (PTRACE_MODE_ATTACH  was  eff=
ec=E2=80=90
>>>               tively the default before Linux 2.6.27.)
>>>
>>>        Since  Linux  4.5, the above access mode checks may be combi=
ned
>>>        (ORed) with one of the following modifiers:
>>>
>>>        PTRACE_MODE_FSCREDS
>>>               Use the caller's filesystem UID  and  GID  (see  cred=
en=E2=80=90
>>>               tials(7)) or effective capabilities for LSM checks.
>>>
>>>        PTRACE_MODE_REALCREDS
>>>               Use the caller's real UID and GID or permitted capabi=
li=E2=80=90
>>>               ties for LSM checks.  This was effectively  the  defa=
ult
>>>               before Linux 4.5.
>>>
>>>        Because  combining  one of the credential modifiers with one=
 of
>>>        the aforementioned access modes is  typical,  some  macros  =
are
>>>        defined in the kernel sources for the combinations:
>>>
>>>        PTRACE_MODE_READ_FSCREDS
>>>               Defined as PTRACE_MODE_READ | PTRACE_MODE_FSCREDS.
>>>
>>>        PTRACE_MODE_READ_REALCREDS
>>>               Defined as PTRACE_MODE_READ | PTRACE_MODE_REALCREDS.
>>>
>>>        PTRACE_MODE_ATTACH_FSCREDS
>>>               Defined as PTRACE_MODE_ATTACH | PTRACE_MODE_FSCREDS.
>>>
>>>        PTRACE_MODE_ATTACH_REALCREDS
>>>               Defined as PTRACE_MODE_ATTACH | PTRACE_MODE_REALCREDS=
=2E
>>>
>>>        One further modifier can be ORed with the access mode:
>>>
>>>        PTRACE_MODE_NOAUDIT (since Linux 3.3)
>>>               Don't audit this access mode check.
>>>
>>> [I'd quite welcome some text to explain "auditing" here.]
>>
>>          AKA don't let the audit subsystem know.  Which tends to
>>          generate audit records capable is called.
>>>
>>>        The  algorithm  employed for ptrace access mode checking det=
er=E2=80=90
>>>        mines whether the calling process is  allowed  to  perform  =
the
>>>        corresponding action on the target process, as follows:
>>>
>>>        1.  If the calling thread and the target thread are in the s=
ame
>>>            thread group, access is always allowed.
>>
>> This test only exsits because the LSMs historically and I suspect
>> continue to be broken and deny a process the ability to ptrace itsel=
f.
>
> Well, it's not that the LSMs are broken, it's that self-inspection is
> a short-circuited "allow". The LSMs aren't involved.
>
>>>        2.  If the access mode specifies PTRACE_MODE_FSCREDS, then  =
for
>>>            the  check in the next step, employ the caller's filesys=
tem
>>>            user ID and group ID (see credentials(7));  otherwise  (=
the
>>>            access  mode  specifies  PTRACE_MODE_REALCREDS, so) use =
the
>>>            caller's real user ID and group ID.
>>>
>>>        3.  Deny access if neither of the following is true:
>>>
>>>            =C2=B7 The real, effective, and saved-set user IDs of th=
e target
>>>              match  the caller's user ID, and the real, effective, =
and
>>>              saved-set group IDs of  the  target  match  the  calle=
r's
>>>              group ID.
>>>
>>>            =C2=B7 The caller has the CAP_SYS_PTRACE capability.
>>>
>>>        4.  Deny  access if the target process "dumpable" attribute =
has
>>>            a value other than 1 (SUID_DUMP_USER; see the discussion=
 of
>>>            PR_SET_DUMPABLE  in prctl(2)), and the caller does not h=
ave
>>>            the CAP_SYS_PTRACE capability in the user namespace of  =
the
>>>            target process.
>>>
>>>        5.  The  kernel LSM security_ptrace_access_check() interface=
 is
>>>            invoked to see if ptrace access is permitted.  The  resu=
lts
>>>            depend on the LSM.  The implementation of this interface=
 in
>>>            the default LSM performs the following steps:
>>>
>>>            a) If the access mode  includes  PTRACE_MODE_FSCREDS,  t=
hen
>>>               use the caller's effective capability set in the foll=
ow=E2=80=90
>>>               ing  check;  otherwise  (the   access   mode   specif=
ies
>>>               PTRACE_MODE_REALCREDS,  so)  use  the caller's permit=
ted
>>>               capability set.
>>>
>>>            b) Deny access if neither of the following is true:
>>>
>>>               =C2=B7 The caller's capabilities are a proper superse=
t of the
>>>                 target process's permitted capabilities.
>>>
>>>               =C2=B7 The  caller  has  the CAP_SYS_PTRACE capabilit=
y in the
>>>                 target process's user namespace.
>>>
>>>               Note that the default LSM does not  distinguish  betw=
een
>>>               PTRACE_MODE_READ and PTRACE_MODE_ATTACH.
>>>
>>>        6.  If  access  has  not  been  denied  by any of the preced=
ing
>>>            steps, then access is allowed.
>>> ]]
>>>
>>> There are accompanying changes to various pages that refer to
>>> the new text in ptrace(2), so that, for example, kcmp(2) adds:
>>>
>>>        Permission  to  employ kcmp() is governed by ptrace access m=
ode
>>>        PTRACE_MODE_ATTACH_REALCREDS checks against both pid1 and pi=
d2;
>>>        see ptrace(2).
>>>
>>> and proc.5 has additions such as:
>>>
>>>        /proc/[pid]/auxv (since 2.6.0-test7)
>>>               ...
>>>               Permission to access this file is governed by  a  ptr=
ace
>>>               access    mode   PTRACE_MODE_READ_FSCREDS   check;   =
see
>>>               ptrace(2).
>>>
>>>        /proc/[pid]/cwd
>>>               ...
>>>               Permission to dereference  or  read  (readlink(2))  t=
his
>>>               symbolic  link  is  governed  by  a  ptrace  access m=
ode
>>>               PTRACE_MODE_READ_FSCREDS check; see ptrace(2).
>>
>> Hmm.
>>
>> When I gave this level of detail about the user namespace permission
>> checks you gave me some flack, because it was not particularly
>> comprehensible to the end users.  I think you deserve the same feedb=
ack.
>>
>> How do we say this in a way that does not describes a useful way to
>> think about it.  I read this and I know a lot of what is going on an=
d my
>> mind goes numb.
>
> If the goal is to document the kernel behavior, then the details
> around the various MODE flags makes sense. If this is just about
> userspace-visible behavior, I would agree: the MODE flag details may
> be overkill (since they are not exposed to userspace).

The problem is that this is about user-space-visible behavior, but in
order to explain that behavior at what I believe is a sufficient level
of detail (e.g., to differentiate the various types of checks that
are performed for various system calls and pseudofile accesses),
one needs (1) to discuss the MODE flag details as implemented in
the kernel, and (2) to have a shorthand way to refer to the various
cases from other pages. It's not absolutely necessary to name the
flags for (1), but using the flag names is certainly a handy
shorthand for (2).

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
