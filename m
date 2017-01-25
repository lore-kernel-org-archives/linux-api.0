From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH v4 0/2] Add further ioctl() operations for namespace discovery
Date: Wed, 25 Jan 2017 16:50:22 +1300
Message-ID: <CAKgNAkjZTUSbdX0m69+TBOTM3jz_O8byH4W0SrY3wUD5gyUk1A@mail.gmail.com>
References: <93e5c7f9-9dc1-6c93-ad20-0ba053d8bfef@gmail.com>
 <963f76f9-3ae5-b316-e688-00d3e59cad30@gmail.com> <87d1fblx2s.fsf@xmission.com>
 <CAKgNAki0y7TbZbTPt-E6tjPX2BASaFfT+KcX_tywb2ASADiw9g@mail.gmail.com>
 <877f5jlvs1.fsf@xmission.com> <87tw8nkh4k.fsf@xmission.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87tw8nkh4k.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On 25 January 2017 at 15:28, Eric W. Biederman <ebiederm@xmission.com> wrote:
> ebiederm@xmission.com (Eric W. Biederman) writes:
>
>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>
>>> Hi Eric,
>>>
>>> On 25 January 2017 at 14:58, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>>
>>>>> I would like to write code that discovers the namespace setup on a live
>>>>> system.  The NS_GET_PARENT and NS_GET_USERNS ioctl() operations added in
>>>>> Linux 4.9 provide much of what I want, but there are still a couple of
>>>>> small pieces missing. Those pieces are added with this patch series.
>>>>
>>>> So it looks like the -EOVERFLOW change broke your example program.
>>>> Causing it to abort if -EOVERFLOW is hit.  Do we really want to return
>>>> -EOVERFLOW?  Or do you want to fix your program?
>>>
>>> Bother! Yes, I should have kept the example program in sync. (I
>>> overlooked that it was not any more in sync.)
>>>
>>> So, I want to make sure I understand correctly, before I aswer your
>>> question. Suppose we have
>>>
>>> 1. Outer namespace owned by UID 0
>>> 2. Inner namespace owned by UID 1000
>>> 3. A UID mapping in the inner namespace that maps '0 1000 1'
>>> 4. A processs, X, in the outer namespace with UID 0 (and all caps).
>>>
>>> That's the case you're meaning, right?
>>
>> I think so I just noticed you did not handle -EOVERFLOW in
>> the one NS_GET_OWNER_UID call.
>>
>>> So, UID 0 doesn't have a
>>> mapping into the inner namespace, but does have all capabilities in
>>> that inner namespace, right?
>>
>> That is correct.
>
> My concern is that the difference between returning -EOVERFLOW and
> overflow_uid is primarily about usability.  If you haven't played with
> the usability I don't trust that we have made the proper trade off.

So, I had not initially included the no-UID-mapping case, and when you
proposed -EOVERFLOW for that case, it seemed better.

On reflection, mapping to the overflow_uid seems simpler. Taking the
example shown in my other mail a short time ago, the unmapped UID 0
from the outer namespace would map to the overflow_uid (which UID my
program would print), but my program would still correctly report that
the UID 0 process in the outer namespace might (subject to LSM checks)
have capabilities in the inner namespace.

So, it seems that reverting the EOVERFLOW change is in order (and my
example program thus needs no changes). Does that sound reasonable to
you?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
