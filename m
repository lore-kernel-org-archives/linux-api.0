From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 2/4] clone.2: Describe the user namespace
Date: Tue, 01 Jan 2013 01:39:43 -0800
Message-ID: <87a9st5jj4.fsf@xmission.com>
References: <87a9u4rmz0.fsf@xmission.com> <87y5hnq3d5.fsf@xmission.com>
	<CAKgNAkgXWp49wXKom9hMm9fajKVOAwOmFzPdKWBesbBhfZEssA@mail.gmail.com>
	<87sj6rs7zc.fsf@xmission.com>
	<CAKgNAkgRQXn0-x6CXxvW94eeG19dOAOEx78iNC0+w08uX+Sg1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkgRQXn0-x6CXxvW94eeG19dOAOEx78iNC0+w08uX+Sg1w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Michael Kerrisk's message of "Tue, 1 Jan 2013 10:29:51 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Hi Eric,
>
> On Thu, Dec 27, 2012 at 6:47 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> There is one other bit that needs to be documented in clone, although
>> I am not certain where/how.
>>
>> The sequences:
>>
>> unshare(CLONE_NEWPID).
>> clone(CLONE_VM)
>>
>> setns(fd, CLONE_NEWPID).
>> clone(CLONE_VM).
>>
>> Now fail.
>
> Can you define "now" please. Which kernel version?

3.8

The sequence was impossible in 3.7.

I think that change that made that impossible happened in the 3.8-rc1 to
3.8-rc2 window.

Eric
