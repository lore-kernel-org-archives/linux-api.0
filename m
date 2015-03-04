From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/2] user_namespaces.7: Update the documention to reflect
 the fixes for negative groups
Date: Wed, 04 Mar 2015 15:00:01 +0100
Message-ID: <54F70FE1.60906@gmail.com>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>	<87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>	<CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>	<87ppbtn4mv.fsf@x220.int.ebiederm.org>	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>	<87a92xn2io.fsf@x220.int.ebiederm.org>	<87r3w8liw4.fsf@x220.int.ebiederm.org>	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>	<87fvcok11h.fsf_-_@x220.int.ebiederm.org>	<CALCETrVfKiXuY=KY_=nHpkTyLWgpy_3DK=4Mr2mhpyX9z1TzrA@mail.gmail.com>	<971ad3f6-90fd-4e3f-916c-8988af3c826d@email.android.com>	<CALCETrWpzvNm=fjOa3_+4QOqYP8qZUJvQAd6AsRZ71xyHZQRCg@mail.gmail.com>	<87wq5zf83t.fsf@x220.int.ebiederm.org>	<87iohh3c9c.fsf@x220.int.ebiederm.org>	<8761dh3b7k.fs
 f_-_@x220.int.ebiederm.org>	<878uicy1r9.fsf_-_@x220.int.ebiederm.org>	<87ppbo1ql4.fsf_-_@x220.int.ebiederm.org> <CAMXgnP7phuYTko6fHnxjJTi=HRdoa32uH6dp8DyD9uWPWr2kAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMXgnP7phuYTko6fHnxjJTi=HRdoa32uH6dp8DyD9uWPWr2kAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alban Crequy <alban.crequy@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, Linux Containers <containers@lists.linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On 02/02/2015 10:31 PM, Alban Crequy wrote:
> Hello,
> 
> Thanks for updating the man page.
> 
> On 12 December 2014 at 22:54, Eric W. Biederman <ebiederm@xmission.com> wrote:
> (...)
>> Furthermore to preserve in some form the useful applications that have
>> been setting gid_map without privilege the file /proc/[pid]/setgroups
>> was added to allow disabling setgroups.  With the setgroups system
>> call permanently disabled in a user namespace it again becomes safe to
>> allow writes to gid_map without privilege.
>>
>> Here is my meager attempt to update user_namespaces.7 to reflect these
>> issues.
> 
> The program userns_child_exec.c in user_namespaces.7 should be updated
> to write in /proc/.../setgroups, near the line:
> /* Update the UID and GID maps in the child */
> 
> Otherwise, the example given in the manpage does not work:
> $ ./userns_child_exec -p -m -U -M '0 1000 1' -G '0 1000 1' bash

Thanks, Alban. I've added code to the example to handle /proc/PID/setgroups
(and tested).

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
