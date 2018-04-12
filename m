From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] mmap.2: MAP_FIXED is okay if the address range has been reserved
Date: Thu, 12 Apr 2018 20:49:38 +0200
Message-ID: <CAG48ez2NtCr8+HqnKJTFBcLW+kCKUa=2pz=7HD9p9u1p-MfJqw@mail.gmail.com>
References: <20180412153941.170849-1-jannh@google.com> <b617740b-fd07-e248-2ba0-9e99b0240594@nvidia.com>
 <CAKgNAkgcJ2kCTff0=7=D3zPFwpJt-9EM8yis6-4qDjfvvb8ukw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAkgcJ2kCTff0=7=D3zPFwpJt-9EM8yis6-4qDjfvvb8ukw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk-manpages <mtk.manpages@gmail.com>, John Hubbard <jhubbard@nvidia.com>
Cc: linux-man <linux-man@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 12, 2018 at 8:37 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Hi John,
>
> On 12 April 2018 at 20:33, John Hubbard <jhubbard@nvidia.com> wrote:
>> On 04/12/2018 08:39 AM, Jann Horn wrote:
>>> Clarify that MAP_FIXED is appropriate if the specified address range has
>>> been reserved using an existing mapping, but shouldn't be used otherwise.
>>>
>>> Signed-off-by: Jann Horn <jannh@google.com>
>>> ---
>>>  man2/mmap.2 | 19 +++++++++++--------
>>>  1 file changed, 11 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/man2/mmap.2 b/man2/mmap.2
[...]
>>>  .IP
>>>  For example, suppose that thread A looks through
>>> @@ -284,13 +285,15 @@ and the PAM libraries
>>>  .UR http://www.linux-pam.org
>>>  .UE .
>>>  .IP
>>> -Newer kernels
>>> -(Linux 4.17 and later) have a
>>> +For cases in which the specified memory region has not been reserved using an
>>> +existing mapping, newer kernels (Linux 4.17 and later) provide an option
>>>  .B MAP_FIXED_NOREPLACE
>>> -option that avoids the corruption problem; if available,
>>> -.B MAP_FIXED_NOREPLACE
>>> -should be preferred over
>>> -.BR MAP_FIXED .
>>> +that should be used instead; older kernels require the caller to use
>>> +.I addr
>>> +as a hint (without
>>> +.BR MAP_FIXED )
>>
>> Here, I got lost: the sentence suddenly jumps into explaining non-MAP_FIXED
>> behavior, in the MAP_FIXED section. Maybe if you break up the sentence, and
>> possibly omit non-MAP_FIXED discussion, it will help.
>
> Hmmm -- true. That piece could be a little clearer.

How about something like this?

              For  cases in which MAP_FIXED can not be used because
the specified memory
              region has not been reserved using an existing mapping,
newer kernels
              (Linux  4.17  and  later)  provide  an  option
MAP_FIXED_NOREPLACE  that
              should  be  used  instead. Older kernels require the
              caller to use addr as a hint and take appropriate action if
              the kernel places the new mapping at a different address.

John, Michael, what do you think?

> Jann, I've already pushed the existing patch. Do you want to add a patch on top?
