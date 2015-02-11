From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/2] user_namespaces.7: Update the documention to reflect
 the fixes for negative groups
Date: Wed, 11 Feb 2015 09:02:30 +0100
Message-ID: <CAKgNAkhmwK02DJQV84S+dEdrUDjzRuR32j+2gcKkgeDq8jTkuQ@mail.gmail.com>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
 <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
 <87h9x5re41.fsf_-_@x220.int.ebiederm.org> <87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
 <CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
 <87ppbtn4mv.fsf@x220.int.ebiederm.org> <CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
 <87a92xn2io.fsf@x220.int.ebiederm.org> <87r3w8liw4.fsf@x220.int.ebiederm.org>
 <87iohklfvj.fsf_-_@x220.int.ebiederm.org> <87fvcok11h.fsf_-_@x220.int.ebiederm.org>
 <CALCETrVfKiXuY=KY_=nHpkTyLWgpy_3DK=4Mr2mhpyX9z1TzrA@mail.gmail.com>
 <971ad3f6-90fd-4e3f-916c-8988af3c826d@email.android.com> <CALCETrWpzvNm=fjOa3_+4QOqYP8qZUJvQAd6AsRZ71xyHZQRCg@mail.gmail.com>
 <87wq5zf83t.fsf@x220.int.ebiederm.org> <87iohh3c9c.fsf@x220.int.ebiederm.org>
 <8761dh3b7k.fsf_-_@x220.int.ebiederm.org> <878uicy1r9.fsf_-_@x220.int.ebiederm.org>
 <87ppbo1ql4.fsf_-_@x220.int.ebiederm.org> <54CF99BF.8050401@gmail.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54CF99BF.8050401@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Linux Containers <containers@lists.linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

Hi Eric,

Ping!

Cheers,

Michael


On 2 February 2015 at 16:37, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Hi Eric,
>
> Thanks for writing this up!
>
> On 12/12/2014 10:54 PM, Eric W. Biederman wrote:
>>
>> Files with access permissions such as ---rwx---rwx give fewer
>> permissions to their group then they do to everyone else.  Which means
>> dropping groups with setgroups(0, NULL) actually grants a process
>> privileges.
>>
>> The uprivileged setting of gid_map turned out not to be safe after
>> this change.  Privilege setting of gid_map can be interpreted as
>> meaning yes it is ok to drop groups.
>
> I had trouble to parse that sentence (and I'd like to make sure that
> the right sentence ends up in the commit message). Did you mean:
>
>     "*Unprivileged* setting of gid_map can be interpreted as meaning
>      yes it is ok to drop groups"
>
> ?
>
> Or something else?
>
>> To prevent this problem and future problems user namespaces were
>> changed in such a way as to guarantee a user can not obtain
>> credentials without privilege they could not obtain without the
>> help of user namespaces.
>>
>> This meant testing the effective user ID and not the filesystem user
>> ID as setresuid and setregid allow setting any process uid or gid
>> (except the supplemental groups) to the effective ID.
>>
>> Furthermore to preserve in some form the useful applications that have
>> been setting gid_map without privilege the file /proc/[pid]/setgroups
>> was added to allow disabling setgroups.  With the setgroups system
>> call permanently disabled in a user namespace it again becomes safe to
>> allow writes to gid_map without privilege.
>>
>> Here is my meager attempt to update user_namespaces.7 to reflect these
>> issues.
>
> It looked pretty serviceable as patch, IMO. So, thanks again. I've applied,
> tweaking some wordings afterward, but changing nothing essential. See below
> for a question.
>
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  man7/user_namespaces.7 | 52 +++++++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 49 insertions(+), 3 deletions(-)
>>
>> diff --git a/man7/user_namespaces.7 b/man7/user_namespaces.7
>> index d76721d9a0a1..f8333a762308 100644
>> --- a/man7/user_namespaces.7
>> +++ b/man7/user_namespaces.7
>> @@ -533,11 +533,16 @@ One of the following is true:
>>  The data written to
>>  .I uid_map
>>  .RI ( gid_map )
>> -consists of a single line that maps the writing process's filesystem user ID
>> +consists of a single line that maps the writing process's effective user ID
>>  (group ID) in the parent user namespace to a user ID (group ID)
>>  in the user namespace.
>> -The usual case here is that this single line provides a mapping for user ID
>> -of the process that created the namespace.
>> +The writing process must have the same effective user ID as the process
>> +that created the user namespace.
>> +In the case of
>> +.I gid_map
>> +the
>> +.I setgroups
>> +file must have been written to earlier and disabled the setgroups system call.
>>  .IP * 3
>>  The opening process has the
>>  .BR CAP_SETUID
>> @@ -552,6 +557,47 @@ Writes that violate the above rules fail with the error
>>  .\"
>>  .\" ============================================================
>>  .\"
>> +.SS Interaction with system calls that change the uid or gid values
>> +When in a user namespace where the
>> +.I uid_map
>> +or
>> +.I gid_map
>> +file has not been written the system calls that change user IDs
>> +or group IDs respectively will fail.  After the
>> +.I uid_map
>> +and
>> +.I gid_map
>> +file have been written only the mapped values may be used in
>> +system calls that change user IDs and group IDs.
>> +
>> +For user IDs these system calls include
>> +.BR setuid ,
>> +.BR setfsuid ,
>> +.BR setreuid ,
>> +and
>> +.BR setresuid .
>> +
>> +For group IDs these system calls include
>> +.BR setgid ,
>> +.BR setfsgid ,
>> +.BR setregid ,
>> +.BR setresgid ,
>> +and
>> +.BR setgroups.
>> +
>> +Writing
>> +.BR deny
>> +to the
>> +.I /proc/[pid]/setgroups
>> +file before writing to
>> +.I /proc/[pid]/gid_map
>> +will permanently disable the setgroups system call in a user namespace
>> +and allow writing to
>> +.I /proc/[pid]/gid_map
>> +without
>> +.BR CAP_SETGID
>> +in the parent user namespace.
>
> I just want to double check: you really did mean to write "*parent* namespace"
> above, right?
>
> Thanks,
>
> Michael
>
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
