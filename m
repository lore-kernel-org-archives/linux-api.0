From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] clone.2: Describe the user namespace
Date: Mon, 7 Jan 2013 09:33:54 +0100
Message-ID: <CAKgNAkggMKib5v4ND9UR1jH=CrK-viM5hhfmc0Rw=mP5GbenSg@mail.gmail.com>
References: <87a9u4rmz0.fsf@xmission.com> <87y5hnq3d5.fsf@xmission.com>
 <CAKgNAkgXWp49wXKom9hMm9fajKVOAwOmFzPdKWBesbBhfZEssA@mail.gmail.com>
 <87sj6rs7zc.fsf@xmission.com> <CAKgNAkgRQXn0-x6CXxvW94eeG19dOAOEx78iNC0+w08uX+Sg1w@mail.gmail.com>
 <87a9st5jj4.fsf@xmission.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87a9st5jj4.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On Tue, Jan 1, 2013 at 10:39 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
>> Hi Eric,
>>
>> On Thu, Dec 27, 2012 at 6:47 PM, Eric W. Biederman
>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>> There is one other bit that needs to be documented in clone, although
>>> I am not certain where/how.
>>>
>>> The sequences:
>>>
>>> unshare(CLONE_NEWPID).
>>> clone(CLONE_VM)
>>>
>>> setns(fd, CLONE_NEWPID).
>>> clone(CLONE_VM).
>>>
>>> Now fail.
>>
>> Can you define "now" please. Which kernel version?
>
> 3.8
>
> The sequence was impossible in 3.7.
>
> I think that change that made that impossible happened in the 3.8-rc1 to
> 3.8-rc2 window.

Adding something along these lines to the man page would be fine, but
we need some text to explain *why* these sequences fail. Could you
send me a sentence or two about that?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
