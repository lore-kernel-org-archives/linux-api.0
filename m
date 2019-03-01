From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/2] seccomp.2: document userspace notification
Date: Fri, 1 Mar 2019 17:02:05 +0100
Message-ID: <20ff6d08-d9ac-06d3-5702-d7de3cc17685@gmail.com>
References: <20181213001106.15268-1-tycho@tycho.ws>
 <20181213001106.15268-3-tycho@tycho.ws>
 <2cea5fec-e73e-5749-18af-15c35a4bd23c@gmail.com>
 <20190301145310.GC7413@cisco>
 <052d73e2-c786-a760-f03a-a07b5772de5a@gmail.com>
 <20190301151937.GE7413@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190301151937.GE7413@cisco>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: mtk.manpages@gmail.com, "Serge E. Hallyn" <serge@hallyn.com>, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jann Horn <jann@thejh.net>, Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, Containers <containers@lists.linux-foundation.org>, Aleksa Sarai <asarai@suse.de>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
List-Id: linux-api@vger.kernel.org

On 3/1/19 4:19 PM, Tycho Andersen wrote:
> On Fri, Mar 01, 2019 at 04:16:27PM +0100, Michael Kerrisk (man-pages) wrote:
>> Hello Tycho,
>>
>> On 3/1/19 3:53 PM, Tycho Andersen wrote:
>>> On Thu, Feb 28, 2019 at 01:52:19PM +0100, Michael Kerrisk (man-pages) wrote:
>>>>> +a notification will be sent to this fd. See "Userspace Notification" below for
>>>>
>>>> s/fd/file descriptor/ throughout please.
>>>
>>> Will do.
>>>
>>>>> +more details.
>>>>
>>>> I think the description here could be better worded as something like:
>>>>
>>>>     SECCOMP_FILTER_FLAG_NEW_LISTENER
>>>>         Register a new filter, as usual, but on success return a
>>>>         new file descriptor that provides user-space notifications.
>>>>         When the filter returns SECCOMP_RET_USER_NOTIF, a notification
>>>>         will be provided via this file descriptor. The close-on-exec
>>>>         flag is automatically set on the new file descriptor. ...
>>>>
>>>>>  .RE
>>>>>  .TP
>>>>>  .BR SECCOMP_GET_ACTION_AVAIL " (since Linux 4.14)"
>>>>> @@ -606,6 +613,17 @@ file.
>>>>>  .TP
>>>>>  .BR SECCOMP_RET_ALLOW
>>>>>  This value results in the system call being executed.
>>>>> +.TP
>>>>> +.BR SECCOMP_RET_USER_NOTIF " (since Linux 4.21)"
>>>>
>>>> Please see the start of this hanging list in the manual page.
>>>> Can you confirm that SECCOMP_RET_USER_NOTIF really is the lowest
>>>> in the precedence order of all of the filter return values?
>>>
>>> Oh, no, I didn't realize it was in a particular order. I'll switch it.
>>
>> Just for my immediate education (I'm experimenting right now),
>> where/how does it fit in the precedence order?
> 
> In between RET_ERRNO and RET_TRACE; see include/uapi/linux/seccomp.h
> for details.

Confirmed by experiment :-).

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
