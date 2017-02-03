From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v4 0/2] Add further ioctl() operations for namespace discovery
Date: Fri, 03 Feb 2017 15:34:04 +1300
Message-ID: <87wpd82ear.fsf@xmission.com>
References: <93e5c7f9-9dc1-6c93-ad20-0ba053d8bfef@gmail.com>
        <963f76f9-3ae5-b316-e688-00d3e59cad30@gmail.com>
        <87d1fblx2s.fsf@xmission.com>
        <CAKgNAki0y7TbZbTPt-E6tjPX2BASaFfT+KcX_tywb2ASADiw9g@mail.gmail.com>
        <877f5jlvs1.fsf@xmission.com> <87tw8nkh4k.fsf@xmission.com>
        <CAKgNAkjZTUSbdX0m69+TBOTM3jz_O8byH4W0SrY3wUD5gyUk1A@mail.gmail.com>
        <87a8aea1pp.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87a8aea1pp.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
        "Thu, 26 Jan 2017 17:23:46 +1300")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:

> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
>
>> On 25 January 2017 at 15:28, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>
>>> My concern is that the difference between returning -EOVERFLOW and
>>> overflow_uid is primarily about usability.  If you haven't played with
>>> the usability I don't trust that we have made the proper trade off.
>>
>> So, I had not initially included the no-UID-mapping case, and when you
>> proposed -EOVERFLOW for that case, it seemed better.
>>
>> On reflection, mapping to the overflow_uid seems simpler. Taking the
>> example shown in my other mail a short time ago, the unmapped UID 0
>> from the outer namespace would map to the overflow_uid (which UID my
>> program would print), but my program would still correctly report that
>> the UID 0 process in the outer namespace might (subject to LSM checks)
>> have capabilities in the inner namespace.
>>
>> So, it seems that reverting the EOVERFLOW change is in order (and my
>> example program thus needs no changes). Does that sound reasonable to
>> you?
>
> It does.  I just care that you have thought through the tradeoffs of
> that corner of the interface design.

So I have just reverted the EOVERFLOW change, applied the patches to
my tree and pushed this to for-next.  Otherwise this looks like this
effort will have stalled.

Eric
