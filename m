From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Documenting ptrace access mode checking
Date: Wed, 22 Jun 2016 21:20:32 +0200
Message-ID: <4c6a338f-619b-9e99-9fd8-1cf6d86ecfed@gmail.com>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
 <87ziqewc3r.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87ziqewc3r.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On 06/21/2016 09:55 PM, Eric W. Biederman wrote:
>
> Adding Oleg just because he seems to do most of the ptrace related
> maintenance these days.
>
> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
>> Hi Jann, Stephen, et al.
>>
>> Jann, since you recently committed a patch in this area, and Stephen=
,
>> since you committed 006ebb40d3d much further back in time, I wonder =
if
>> you might help me by reviewing the text below that I propose to add =
to
>> the ptrace(2) man page, in order to document "ptrace access mode
>> checking" that is performed in various parts of the kernel-user-spac=
e
>> interface. Of course, I welcome input from anyone else as well.
>>
>> Here's the new ptrace(2) text. Any comments, technical or terminolog=
ical
>> fixes, other improvements, etc. are welcome.
>>
>> [[
>>    Ptrace access mode checking
>>        Various parts of the kernel-user-space API (not just  ptrace(=
2)
>>        operations), require so-called "ptrace access mode permission=
s"
>>        which are gated  by  Linux  Security  Modules  (LSMs)  such  =
as
>>        SELinux,  Yama,  Smack,  or  the  default  LSM.  Prior to Lin=
ux
>>        2.6.27, all such checks were of a  single  type.   Since  Lin=
ux
>>        2.6.27, two access mode levels are distinguished:
>>
>>        PTRACE_MODE_READ
>>               For  "read" operations or other operations that are le=
ss
>>               dangerous, such as: get_robust_list(2); kcmp(2); readi=
ng
>>               /proc/[pid]/auxv,         /proc/[pid]/environ,        =
or
>>               /proc/[pid]/stat; or readlink(2) of  a  /proc/[pid]/ns=
/*
>>               file.
>>
>>        PTRACE_MODE_ATTACH
>>               For  "write"  operations,  or  other operations that a=
re
>>               more    dangerous,    such    as:    ptrace    attachi=
ng
>>               (PTRACE_ATTACH)    to   another   process   or   calli=
ng
>>               process_vm_writev(2).   (PTRACE_MODE_ATTACH  was  effe=
c=E2=80=90
>>               tively the default before Linux 2.6.27.)
>>
>>        Since  Linux  4.5, the above access mode checks may be combin=
ed
>>        (ORed) with one of the following modifiers:
>>
>>        PTRACE_MODE_FSCREDS
>>               Use the caller's filesystem UID  and  GID  (see  crede=
n=E2=80=90
>>               tials(7)) or effective capabilities for LSM checks.
>>
>>        PTRACE_MODE_REALCREDS
>>               Use the caller's real UID and GID or permitted capabil=
i=E2=80=90
>>               ties for LSM checks.  This was effectively  the  defau=
lt
>>               before Linux 4.5.
>>
>>        Because  combining  one of the credential modifiers with one =
of
>>        the aforementioned access modes is  typical,  some  macros  a=
re
>>        defined in the kernel sources for the combinations:
>>
>>        PTRACE_MODE_READ_FSCREDS
>>               Defined as PTRACE_MODE_READ | PTRACE_MODE_FSCREDS.
>>
>>        PTRACE_MODE_READ_REALCREDS
>>               Defined as PTRACE_MODE_READ | PTRACE_MODE_REALCREDS.
>>
>>        PTRACE_MODE_ATTACH_FSCREDS
>>               Defined as PTRACE_MODE_ATTACH | PTRACE_MODE_FSCREDS.
>>
>>        PTRACE_MODE_ATTACH_REALCREDS
>>               Defined as PTRACE_MODE_ATTACH | PTRACE_MODE_REALCREDS.
>>
>>        One further modifier can be ORed with the access mode:
>>
>>        PTRACE_MODE_NOAUDIT (since Linux 3.3)
>>               Don't audit this access mode check.
>>
>> [I'd quite welcome some text to explain "auditing" here.]
>
>          AKA don't let the audit subsystem know.  Which tends to
>          generate audit records capable is called.
>>
>>        The  algorithm  employed for ptrace access mode checking dete=
r=E2=80=90
>>        mines whether the calling process is  allowed  to  perform  t=
he
>>        corresponding action on the target process, as follows:
>>
>>        1.  If the calling thread and the target thread are in the sa=
me
>>            thread group, access is always allowed.
>
> This test only exsits because the LSMs historically and I suspect
> continue to be broken and deny a process the ability to ptrace itself=
=2E
>>
>>        2.  If the access mode specifies PTRACE_MODE_FSCREDS, then  f=
or
>>            the  check in the next step, employ the caller's filesyst=
em
>>            user ID and group ID (see credentials(7));  otherwise  (t=
he
>>            access  mode  specifies  PTRACE_MODE_REALCREDS, so) use t=
he
>>            caller's real user ID and group ID.
>>
>>        3.  Deny access if neither of the following is true:
>>
>>            =C2=B7 The real, effective, and saved-set user IDs of the=
 target
>>              match  the caller's user ID, and the real, effective, a=
nd
>>              saved-set group IDs of  the  target  match  the  caller=
's
>>              group ID.
>>
>>            =C2=B7 The caller has the CAP_SYS_PTRACE capability.
>>
>>        4.  Deny  access if the target process "dumpable" attribute h=
as
>>            a value other than 1 (SUID_DUMP_USER; see the discussion =
of
>>            PR_SET_DUMPABLE  in prctl(2)), and the caller does not ha=
ve
>>            the CAP_SYS_PTRACE capability in the user namespace of  t=
he
>>            target process.
>>
>>        5.  The  kernel LSM security_ptrace_access_check() interface =
is
>>            invoked to see if ptrace access is permitted.  The  resul=
ts
>>            depend on the LSM.  The implementation of this interface =
in
>>            the default LSM performs the following steps:
>>
>>            a) If the access mode  includes  PTRACE_MODE_FSCREDS,  th=
en
>>               use the caller's effective capability set in the follo=
w=E2=80=90
>>               ing  check;  otherwise  (the   access   mode   specifi=
es
>>               PTRACE_MODE_REALCREDS,  so)  use  the caller's permitt=
ed
>>               capability set.
>>
>>            b) Deny access if neither of the following is true:
>>
>>               =C2=B7 The caller's capabilities are a proper superset=
 of the
>>                 target process's permitted capabilities.
>>
>>               =C2=B7 The  caller  has  the CAP_SYS_PTRACE capability=
 in the
>>                 target process's user namespace.
>>
>>               Note that the default LSM does not  distinguish  betwe=
en
>>               PTRACE_MODE_READ and PTRACE_MODE_ATTACH.
>>
>>        6.  If  access  has  not  been  denied  by any of the precedi=
ng
>>            steps, then access is allowed.
>> ]]
>>
>> There are accompanying changes to various pages that refer to
>> the new text in ptrace(2), so that, for example, kcmp(2) adds:
>>
>>        Permission  to  employ kcmp() is governed by ptrace access mo=
de
>>        PTRACE_MODE_ATTACH_REALCREDS checks against both pid1 and pid=
2;
>>        see ptrace(2).
>>
>> and proc.5 has additions such as:
>>
>>        /proc/[pid]/auxv (since 2.6.0-test7)
>>               ...
>>               Permission to access this file is governed by  a  ptra=
ce
>>               access    mode   PTRACE_MODE_READ_FSCREDS   check;   s=
ee
>>               ptrace(2).
>>
>>        /proc/[pid]/cwd
>>               ...
>>               Permission to dereference  or  read  (readlink(2))  th=
is
>>               symbolic  link  is  governed  by  a  ptrace  access mo=
de
>>               PTRACE_MODE_READ_FSCREDS check; see ptrace(2).
>
> Hmm.
>
> When I gave this level of detail about the user namespace permission
> checks you gave me some flack, because it was not particularly
> comprehensible to the end users.  I think you deserve the same feedba=
ck.
>
> How do we say this in a way that does not describes a useful way to
> think about it.  I read this and I know a lot of what is going on and=
 my
> mind goes numb.
>
> How about something like this:
>
>    If the callers uid and gid are the same as a processes uids and gi=
ds
>    and the processes is configured to allow core dumps (aka it was ne=
ver
>    setuid or setgid) then the caller is allowed to ptrace a process.
>
>    Otherwise the caller must have CAP_SYS_PTRACE.
>
>    Linux security modules impose additional restrictions.
>
>    For consistency access to various process attributes are guarded w=
ith
>    the same security checks as the ptrace system call itself.  As the=
y are
>    all methods to get information about a process.
>
> We certainly need something that gives a high level view so people
> reading the man page can know what to expect.   If you get down into =
the
> weeds we run the danger of people beginning to think they can depend
> upon bugs in the implementation.

Thanks for the feedback, but I think more detail is required than you
suggest. (And I added all of that detail somewhat reluctantly.)
See my other replies for my rationale.

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
