From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: Documenting ptrace access mode checking
Date: Tue, 21 Jun 2016 14:55:36 -0500
Message-ID: <87ziqewc3r.fsf@x220.int.ebiederm.org>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e335a243-2199-2185-c7b3-fb1c898e9ab4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Michael
	Kerrisk's message of "Tue, 21 Jun 2016 11:41:16 +0200")
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Adding Oleg just because he seems to do most of the ptrace related
maintenance these days.

"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Hi Jann, Stephen, et al.
>
> Jann, since you recently committed a patch in this area, and Stephen,
> since you committed 006ebb40d3d much further back in time, I wonder i=
f
> you might help me by reviewing the text below that I propose to add t=
o
> the ptrace(2) man page, in order to document "ptrace access mode=20
> checking" that is performed in various parts of the kernel-user-space
> interface. Of course, I welcome input from anyone else as well.
>
> Here's the new ptrace(2) text. Any comments, technical or terminologi=
cal
> fixes, other improvements, etc. are welcome.
>
> [[
>    Ptrace access mode checking
>        Various parts of the kernel-user-space API (not just  ptrace(2=
)
>        operations), require so-called "ptrace access mode permissions=
"
>        which are gated  by  Linux  Security  Modules  (LSMs)  such  a=
s
>        SELinux,  Yama,  Smack,  or  the  default  LSM.  Prior to Linu=
x
>        2.6.27, all such checks were of a  single  type.   Since  Linu=
x
>        2.6.27, two access mode levels are distinguished:
>
>        PTRACE_MODE_READ
>               For  "read" operations or other operations that are les=
s
>               dangerous, such as: get_robust_list(2); kcmp(2); readin=
g
>               /proc/[pid]/auxv,         /proc/[pid]/environ,        o=
r
>               /proc/[pid]/stat; or readlink(2) of  a  /proc/[pid]/ns/=
*
>               file.
>
>        PTRACE_MODE_ATTACH
>               For  "write"  operations,  or  other operations that ar=
e
>               more    dangerous,    such    as:    ptrace    attachin=
g
>               (PTRACE_ATTACH)    to   another   process   or   callin=
g
>               process_vm_writev(2).   (PTRACE_MODE_ATTACH  was  effec=
=E2=80=90
>               tively the default before Linux 2.6.27.)
>
>        Since  Linux  4.5, the above access mode checks may be combine=
d
>        (ORed) with one of the following modifiers:
>
>        PTRACE_MODE_FSCREDS
>               Use the caller's filesystem UID  and  GID  (see  creden=
=E2=80=90
>               tials(7)) or effective capabilities for LSM checks.
>
>        PTRACE_MODE_REALCREDS
>               Use the caller's real UID and GID or permitted capabili=
=E2=80=90
>               ties for LSM checks.  This was effectively  the  defaul=
t
>               before Linux 4.5.
>
>        Because  combining  one of the credential modifiers with one o=
f
>        the aforementioned access modes is  typical,  some  macros  ar=
e
>        defined in the kernel sources for the combinations:
>
>        PTRACE_MODE_READ_FSCREDS
>               Defined as PTRACE_MODE_READ | PTRACE_MODE_FSCREDS.
>
>        PTRACE_MODE_READ_REALCREDS
>               Defined as PTRACE_MODE_READ | PTRACE_MODE_REALCREDS.
>
>        PTRACE_MODE_ATTACH_FSCREDS
>               Defined as PTRACE_MODE_ATTACH | PTRACE_MODE_FSCREDS.
>
>        PTRACE_MODE_ATTACH_REALCREDS
>               Defined as PTRACE_MODE_ATTACH | PTRACE_MODE_REALCREDS.
>
>        One further modifier can be ORed with the access mode:
>
>        PTRACE_MODE_NOAUDIT (since Linux 3.3)
>               Don't audit this access mode check.
>
> [I'd quite welcome some text to explain "auditing" here.]

         AKA don't let the audit subsystem know.  Which tends to
         generate audit records capable is called.
>
>        The  algorithm  employed for ptrace access mode checking deter=
=E2=80=90
>        mines whether the calling process is  allowed  to  perform  th=
e
>        corresponding action on the target process, as follows:
>
>        1.  If the calling thread and the target thread are in the sam=
e
>            thread group, access is always allowed.

This test only exsits because the LSMs historically and I suspect
continue to be broken and deny a process the ability to ptrace itself.
>
>        2.  If the access mode specifies PTRACE_MODE_FSCREDS, then  fo=
r
>            the  check in the next step, employ the caller's filesyste=
m
>            user ID and group ID (see credentials(7));  otherwise  (th=
e
>            access  mode  specifies  PTRACE_MODE_REALCREDS, so) use th=
e
>            caller's real user ID and group ID.
>
>        3.  Deny access if neither of the following is true:
>
>            =C2=B7 The real, effective, and saved-set user IDs of the =
target
>              match  the caller's user ID, and the real, effective, an=
d
>              saved-set group IDs of  the  target  match  the  caller'=
s
>              group ID.
>
>            =C2=B7 The caller has the CAP_SYS_PTRACE capability.
>
>        4.  Deny  access if the target process "dumpable" attribute ha=
s
>            a value other than 1 (SUID_DUMP_USER; see the discussion o=
f
>            PR_SET_DUMPABLE  in prctl(2)), and the caller does not hav=
e
>            the CAP_SYS_PTRACE capability in the user namespace of  th=
e
>            target process.
>
>        5.  The  kernel LSM security_ptrace_access_check() interface i=
s
>            invoked to see if ptrace access is permitted.  The  result=
s
>            depend on the LSM.  The implementation of this interface i=
n
>            the default LSM performs the following steps:
>
>            a) If the access mode  includes  PTRACE_MODE_FSCREDS,  the=
n
>               use the caller's effective capability set in the follow=
=E2=80=90
>               ing  check;  otherwise  (the   access   mode   specifie=
s
>               PTRACE_MODE_REALCREDS,  so)  use  the caller's permitte=
d
>               capability set.
>
>            b) Deny access if neither of the following is true:
>
>               =C2=B7 The caller's capabilities are a proper superset =
of the
>                 target process's permitted capabilities.
>
>               =C2=B7 The  caller  has  the CAP_SYS_PTRACE capability =
in the
>                 target process's user namespace.
>
>               Note that the default LSM does not  distinguish  betwee=
n
>               PTRACE_MODE_READ and PTRACE_MODE_ATTACH.
>
>        6.  If  access  has  not  been  denied  by any of the precedin=
g
>            steps, then access is allowed.
> ]]
>
> There are accompanying changes to various pages that refer to=20
> the new text in ptrace(2), so that, for example, kcmp(2) adds:
>
>        Permission  to  employ kcmp() is governed by ptrace access mod=
e
>        PTRACE_MODE_ATTACH_REALCREDS checks against both pid1 and pid2=
;
>        see ptrace(2).
>
> and proc.5 has additions such as:
>
>        /proc/[pid]/auxv (since 2.6.0-test7)
>               ...
>               Permission to access this file is governed by  a  ptrac=
e
>               access    mode   PTRACE_MODE_READ_FSCREDS   check;   se=
e
>               ptrace(2).
>
>        /proc/[pid]/cwd
>               ...
>               Permission to dereference  or  read  (readlink(2))  thi=
s
>               symbolic  link  is  governed  by  a  ptrace  access mod=
e
>               PTRACE_MODE_READ_FSCREDS check; see ptrace(2).

Hmm.

When I gave this level of detail about the user namespace permission
checks you gave me some flack, because it was not particularly
comprehensible to the end users.  I think you deserve the same feedback=
=2E

How do we say this in a way that does not describes a useful way to
think about it.  I read this and I know a lot of what is going on and m=
y
mind goes numb.

How about something like this:

   If the callers uid and gid are the same as a processes uids and gids
   and the processes is configured to allow core dumps (aka it was neve=
r
   setuid or setgid) then the caller is allowed to ptrace a process.
  =20
   Otherwise the caller must have CAP_SYS_PTRACE.
  =20
   Linux security modules impose additional restrictions.
  =20
   For consistency access to various process attributes are guarded wit=
h
   the same security checks as the ptrace system call itself.  As they =
are
   all methods to get information about a process.

We certainly need something that gives a high level view so people
reading the man page can know what to expect.   If you get down into th=
e
weeds we run the danger of people beginning to think they can depend
upon bugs in the implementation.

Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
