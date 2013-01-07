From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 2/4] clone.2: Describe the user namespace
Date: Mon, 07 Jan 2013 00:59:20 -0800
Message-ID: <877gnp8j2v.fsf@xmission.com>
References: <87a9u4rmz0.fsf@xmission.com> <87y5hnq3d5.fsf@xmission.com>
	<CAKgNAkgXWp49wXKom9hMm9fajKVOAwOmFzPdKWBesbBhfZEssA@mail.gmail.com>
	<87sj6rs7zc.fsf@xmission.com>
	<CAKgNAkgRQXn0-x6CXxvW94eeG19dOAOEx78iNC0+w08uX+Sg1w@mail.gmail.com>
	<87a9st5jj4.fsf@xmission.com>
	<CAKgNAkggMKib5v4ND9UR1jH=CrK-viM5hhfmc0Rw=mP5GbenSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkggMKib5v4ND9UR1jH=CrK-viM5hhfmc0Rw=mP5GbenSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Michael Kerrisk's message of "Mon, 7 Jan 2013 09:33:54 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Hi Eric,
>
> On Tue, Jan 1, 2013 at 10:39 AM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>>
>>> Hi Eric,
>>>
>>> On Thu, Dec 27, 2012 at 6:47 PM, Eric W. Biederman
>>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>>>
>>>> There is one other bit that needs to be documented in clone, although
>>>> I am not certain where/how.
>>>>
>>>> The sequences:
>>>>
>>>> unshare(CLONE_NEWPID).
>>>> clone(CLONE_VM)
>>>>
>>>> setns(fd, CLONE_NEWPID).
>>>> clone(CLONE_VM).
>>>>
>>>> Now fail.
>>>
>>> Can you define "now" please. Which kernel version?
>>
>> 3.8
>>
>> The sequence was impossible in 3.7.
>>
>> I think that change that made that impossible happened in the 3.8-rc1 to
                                       ^^^^^^^^^ illegal 3.8-rc1 made the sequence possible.
>> 3.8-rc2 window.
>
> Adding something along these lines to the man page would be fine, but
> we need some text to explain *why* these sequences fail. Could you
> send me a sentence or two about that?

The basic principle is every thread in a process must be in the same pid
namespace.   As unshare(CLONE_NEWPID) and setns(fd, CLONE_NEWPID) only
change the pid namespace for created children creating a child process
that is a thread would put that thread in a different pid namespace.

Creating a multithreaded application and then setns(fd, CLONE_NEWPID or
clone(CLONE_NEWPID) was outlawed because it was two bizarre and no one
cared.  Oleg noticed you could create the threads afterwards and get
into a bizarre state that no one wanted to support.

Eric
