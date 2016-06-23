From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: Documenting ptrace access mode checking
Date: Thu, 23 Jun 2016 14:05:07 -0400
Message-ID: <fe5a5f9a-87f8-8483-58cf-61c73aa1ecdd@tycho.nsa.gov>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Jann Horn <jann@thejh.net>
Cc: James Morris <jmorris@namei.org>, linux-man <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 06/21/2016 05:41 AM, Michael Kerrisk (man-pages) wrote:
> Hi Jann, Stephen, et al.
>=20
> Jann, since you recently committed a patch in this area, and Stephen,
> since you committed 006ebb40d3d much further back in time, I wonder i=
f
> you might help me by reviewing the text below that I propose to add t=
o
> the ptrace(2) man page, in order to document "ptrace access mode=20
> checking" that is performed in various parts of the kernel-user-space
> interface. Of course, I welcome input from anyone else as well.
>=20
> Here's the new ptrace(2) text. Any comments, technical or terminologi=
cal
> fixes, other improvements, etc. are welcome.
>=20
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
>=20
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
>=20
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

That was the intent when the distinction was introduced, but it doesn't
appear to have been properly maintained, e.g. there is now a common
helper lock_trace() that is used for
/proc/pid/{stack,syscall,personality} but checks PTRACE_MODE_ATTACH, an=
d
PTRACE_MODE_ATTACH is also used in timerslack_ns_write/show().  Likely
should review and make them consistent.  There was also some debate
about proper handling of /proc/pid/fd.  Arguably that one might belong
back in the _ATTACH camp.

>=20
>        Since  Linux  4.5, the above access mode checks may be combine=
d
>        (ORed) with one of the following modifiers:
>=20
>        PTRACE_MODE_FSCREDS
>               Use the caller's filesystem UID  and  GID  (see  creden=
=E2=80=90
>               tials(7)) or effective capabilities for LSM checks.
>=20
>        PTRACE_MODE_REALCREDS
>               Use the caller's real UID and GID or permitted capabili=
=E2=80=90
>               ties for LSM checks.  This was effectively  the  defaul=
t
>               before Linux 4.5.
>=20
>        Because  combining  one of the credential modifiers with one o=
f
>        the aforementioned access modes is  typical,  some  macros  ar=
e
>        defined in the kernel sources for the combinations:
>=20
>        PTRACE_MODE_READ_FSCREDS
>               Defined as PTRACE_MODE_READ | PTRACE_MODE_FSCREDS.
>=20
>        PTRACE_MODE_READ_REALCREDS
>               Defined as PTRACE_MODE_READ | PTRACE_MODE_REALCREDS.
>=20
>        PTRACE_MODE_ATTACH_FSCREDS
>               Defined as PTRACE_MODE_ATTACH | PTRACE_MODE_FSCREDS.
>=20
>        PTRACE_MODE_ATTACH_REALCREDS
>               Defined as PTRACE_MODE_ATTACH | PTRACE_MODE_REALCREDS.
>=20
>        One further modifier can be ORed with the access mode:
>=20
>        PTRACE_MODE_NOAUDIT (since Linux 3.3)
>               Don't audit this access mode check.
>=20
> [I'd quite welcome some text to explain "auditing" here.]

Some ptrace access mode checks, such as checks when reading
/proc/pid/stat, merely cause the output to be filtered/sanitized rather
than an error to be returned to the caller.  In these cases, accessing
the file is not a security violation and there is no reason to generate
a security audit record.  This modifier suppresses the generation of
such an audit record for the particular access check.

>=20
>        The  algorithm  employed for ptrace access mode checking deter=
=E2=80=90
>        mines whether the calling process is  allowed  to  perform  th=
e
>        corresponding action on the target process, as follows:
>=20
>        1.  If the calling thread and the target thread are in the sam=
e
>            thread group, access is always allowed.
>=20
>        2.  If the access mode specifies PTRACE_MODE_FSCREDS, then  fo=
r
>            the  check in the next step, employ the caller's filesyste=
m
>            user ID and group ID (see credentials(7));  otherwise  (th=
e
>            access  mode  specifies  PTRACE_MODE_REALCREDS, so) use th=
e
>            caller's real user ID and group ID.
>=20
>        3.  Deny access if neither of the following is true:
>=20
>            =C2=B7 The real, effective, and saved-set user IDs of the =
target
>              match  the caller's user ID, and the real, effective, an=
d
>              saved-set group IDs of  the  target  match  the  caller'=
s
>              group ID.
>=20
>            =C2=B7 The caller has the CAP_SYS_PTRACE capability.
>=20
>        4.  Deny  access if the target process "dumpable" attribute ha=
s
>            a value other than 1 (SUID_DUMP_USER; see the discussion o=
f
>            PR_SET_DUMPABLE  in prctl(2)), and the caller does not hav=
e
>            the CAP_SYS_PTRACE capability in the user namespace of  th=
e
>            target process.
>=20
>        5.  The  kernel LSM security_ptrace_access_check() interface i=
s
>            invoked to see if ptrace access is permitted.  The  result=
s
>            depend on the LSM.  The implementation of this interface i=
n
>            the default LSM performs the following steps:
>=20
>            a) If the access mode  includes  PTRACE_MODE_FSCREDS,  the=
n
>               use the caller's effective capability set in the follow=
=E2=80=90
>               ing  check;  otherwise  (the   access   mode   specifie=
s
>               PTRACE_MODE_REALCREDS,  so)  use  the caller's permitte=
d
>               capability set.
>=20
>            b) Deny access if neither of the following is true:
>=20
>               =C2=B7 The caller's capabilities are a proper superset =
of the
>                 target process's permitted capabilities.
>=20
>               =C2=B7 The  caller  has  the CAP_SYS_PTRACE capability =
in the
>                 target process's user namespace.
>=20
>               Note that the default LSM does not  distinguish  betwee=
n
>               PTRACE_MODE_READ and PTRACE_MODE_ATTACH.
>=20
>        6.  If  access  has  not  been  denied  by any of the precedin=
g
>            steps, then access is allowed.
> ]]
>=20
> There are accompanying changes to various pages that refer to=20
> the new text in ptrace(2), so that, for example, kcmp(2) adds:
>=20
>        Permission  to  employ kcmp() is governed by ptrace access mod=
e
>        PTRACE_MODE_ATTACH_REALCREDS checks against both pid1 and pid2=
;
>        see ptrace(2).
>=20
> and proc.5 has additions such as:
>=20
>        /proc/[pid]/auxv (since 2.6.0-test7)
>               ...
>               Permission to access this file is governed by  a  ptrac=
e
>               access    mode   PTRACE_MODE_READ_FSCREDS   check;   se=
e
>               ptrace(2).
>=20
>        /proc/[pid]/cwd
>               ...
>               Permission to dereference  or  read  (readlink(2))  thi=
s
>               symbolic  link  is  governed  by  a  ptrace  access mod=
e
>               PTRACE_MODE_READ_FSCREDS check; see ptrace(2).
>=20
> Thanks,
>=20
> Michael
>=20
