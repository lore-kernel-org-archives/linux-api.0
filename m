From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Documenting ptrace access mode checking
Date: Fri, 24 Jun 2016 10:33:13 +0200
Message-ID: <bb5c265c-2b9f-e4ce-6647-1e4098ab0f24@gmail.com>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
 <fe5a5f9a-87f8-8483-58cf-61c73aa1ecdd@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fe5a5f9a-87f8-8483-58cf-61c73aa1ecdd-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Stephen,

On 06/23/2016 08:05 PM, Stephen Smalley wrote:
> On 06/21/2016 05:41 AM, Michael Kerrisk (man-pages) wrote:
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
>
> That was the intent when the distinction was introduced, but it doesn=
't
> appear to have been properly maintained, e.g. there is now a common
> helper lock_trace() that is used for
> /proc/pid/{stack,syscall,personality} but checks PTRACE_MODE_ATTACH, =
and
> PTRACE_MODE_ATTACH is also used in timerslack_ns_write/show().  Likel=
y
> should review and make them consistent.  There was also some debate
> about proper handling of /proc/pid/fd.  Arguably that one might belon=
g
> back in the _ATTACH camp.

Thanks for the background info.

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
> Some ptrace access mode checks, such as checks when reading
> /proc/pid/stat, merely cause the output to be filtered/sanitized rath=
er
> than an error to be returned to the caller.  In these cases, accessin=
g
> the file is not a security violation and there is no reason to genera=
te
> a security audit record.  This modifier suppresses the generation of
> such an audit record for the particular access check.

Thanks, I've added that text to the man page more or less as you
gave it here.

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
