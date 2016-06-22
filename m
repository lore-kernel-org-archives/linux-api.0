From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Documenting ptrace access mode checking
Date: Wed, 22 Jun 2016 21:21:29 +0200
Message-ID: <86486234-d78a-234b-58bb-6ca646881dc6@gmail.com>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
 <20160621205550.GA5191@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20160621205550.GA5191@pc.thejh.net>
Sender: owner-linux-security-module@vger.kernel.org
To: Jann Horn <jann@thejh.net>
Cc: mtk.manpages@gmail.com, James Morris <jmorris@namei.org>, linux-man <linux-man@vger.kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, lkml <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Jann,


On 06/21/2016 10:55 PM, Jann Horn wrote:
> On Tue, Jun 21, 2016 at 11:41:16AM +0200, Michael Kerrisk (man-pages)=
 wrote:
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
>
> As others have said, I'm surprised about seeing documentation about
> kernel-internal constants in manpages - but I think it might be a goo=
d
> thing to have there, given that people who look at ptrace(2) are like=
ly
> to be interested in low-level details.

I agree that it is a little surprising to add kernel-internal
constants in a man page. (There are precedents, but they are few.)
But see my reply to Kees. It's more than just explaining low level
details: there are various kinds of user-space behavior differences
(real vs filesystem credentials; permitted vs effective capabilities)
produced by the ptrace_may_access() checks, and those behaviors need
to be described and *somehow* labeled for cross-referencing from
other man pages.

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
>
> s/may/must/; otherwise __ptrace_may_access() will yell about the kern=
el
> code being broken and deny access.

Good point. I changed "may" to "are". ("must" is not quite right to my
"user-space" ear; it might be misread as implying that the user-space
developer must do something.)

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
>
> Might want to add a "for historical reasons" or so here.

Can you be a little more precise about "here", and maybe tell me why
you think it helps?

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
>
> Might want to also specify here (like below) that the caller needs to
> have the capability relative to the user ns of the target.

Done.

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
>
> For people who are unaware of how the LSM API works, it might be good=
 to
> clarify that the commoncap LSM is *always* invoked; otherwise, it mig=
ht
> give the impression that using another LSM would replace it.

As we can see, I am one of those who are unaware of how the LSM API
works :-/.

> (Also, are there other documents that refer to it as "default LSM"? I
> think that that term is slightly confusing.)

No, that's a terminological confusion of my own making. Fixed now.

I changed this text to:

        Various parts of the kernel-user-space API (not just  ptrace(2)
        operations), require so-called "ptrace access mode permissions"
        which are gated by any enabled Linux Security Module (LSMs)=E2=80=
=94for
        example,  SELinux,  Yama, or Smack=E2=80=94and by the the commo=
ncap LSM
        (which is always invoked).  Prior to  Linux  2.6.27,  all  such
        checks  were  of a single type.  Since Linux 2.6.27, two access
        mode levels are distinguished:

BTW, can you point me at the piece(s) of kernel code that show that
"commoncap" is always invoked in addition to any other LSM that has
been installed?

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
>
> This also requires the caller and the target to be in the same user
> namespace.

Thanks! Fixed.

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
>
> (Actually, kcmp() just needs READ access - you described that accurat=
ely
> earlier, but it's wrong here.)

D'oh! Thanks!

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
> That sounds great! :)

Thanks for the review!

Thanks,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
