From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH RFC v5] pidns: introduce syscall translate_pid
Date: Thu, 31 May 2018 13:02:33 -0500
Message-ID: <871sdrem9y.fsf@xmission.com>
References: <152286911105.615669.14053871624892399807.stgit@buzz>
        <ba7b704f-1fc4-a08d-e7cf-2766160bd419@oracle.com>
        <87h8oqhagl.fsf@xmission.com>
        <112c7cac-1982-3a2e-ffc0-878bc5ae4bb6@yandex-team.ru>
        <71d8d32b-0f59-d418-0ee4-fcc7782646ae@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <71d8d32b-0f59-d418-0ee4-fcc7782646ae@gmail.com> (Michael
        Kerrisk's message of "Fri, 27 Apr 2018 14:15:01 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Prakash Sangappa <prakash.sangappa@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> On 04/05/2018 09:02 AM, Konstantin Khlebnikov wrote:
>> On 05.04.2018 01:29, Eric W. Biederman wrote:
>>> Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com> writes:
>>>
>>>> On 04/04/2018 12:11 PM, Konstantin Khlebnikov wrote:
>>>>> Each process have different pids, one for each pid namespace it belongs.
>>>>> When interaction happens within single pid-ns translation isn't required.
>>>>> More complicated scenarios needs special handling.
>>>>>
>>>>> For example:
>>>>> - reading pid-files or logs written inside container with pid namespace
>>>>> - attaching with ptrace to tasks from different pid namespace
>>>>> - passing pids across pid namespaces in any kind of API
>>>>>
>>>>> Currently there are several interfaces that could be used here:
>>>>>
>>>>> Pid namespaces are identified by inode number of /proc/[pid]/ns/pid.
>>>
>>> Using the inode number in interfaces is not an option.  Especially not
>>> withou referencing the device number for the filesystem as well.
>> 
>> This is supposed to be single-instance fs,
>> not part of proc but referenced but its magic "symlinks".
>> 
>> Device numbers are not mentioned in "man namespaces".
>
> Thanks for the heads-up!
>
> That was a bug in the man-page. ioctl_ns(2) already says the right thing.
> Now I patches namespaces(7), as below.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

For the changes to namespaces.7.  I suspect you have already applied
them by now, but if not.

Eric


> Cheers,
>
> Michael
>
> diff --git a/man7/namespaces.7 b/man7/namespaces.7
> index 725ebaff6..3c155de7e 100644
> --- a/man7/namespaces.7
> +++ b/man7/namespaces.7
> @@ -154,11 +154,14 @@ In Linux 3.7 and earlier, these files were visible as hard links.
>  Since Linux 3.8,
>  .\" commit bf056bfa80596a5d14b26b17276a56a0dcb080e5
>  they appear as symbolic links.
> -If two processes are in the same namespace, then the inode numbers of their
> +If two processes are in the same namespace,
> +then the device IDs and inode numbers of their
>  .IR /proc/[pid]/ns/xxx
>  symbolic links will be the same; an application can check this using the
> +.I stat.st_dev
> +and
>  .I stat.st_ino
> -field returned by
> +fields returned by
>  .BR stat (2).
>  The content of this symbolic link is a string containing
>  the namespace type and inode number as in the following example:
