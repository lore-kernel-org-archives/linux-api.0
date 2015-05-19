From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH man-pages v2] capabilities.7, prctl.2: Document ambient
 capabilities
Date: Tue, 19 May 2015 21:13:49 +0200
Message-ID: <555B8B6D.4010608@gmail.com>
References: <f85ae308af4946436e82aaa9dd71bcd4b39bd196.1431672156.git.luto@kernel.org> <555AECC3.4040408@gmail.com> <CALCETrWn2zB2reYjXbA5iUJpwwZ-0S2tr3Q1nS2+Z-Rcir2udQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALCETrWn2zB2reYjXbA5iUJpwwZ-0S2tr3Q1nS2+Z-Rcir2udQ@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: mtk.manpages@gmail.com, Andy Lutomirski <luto@kernel.org>, Serge Hallyn <serge.hallyn@ubuntu.com>, Andrew Morton <akpm@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

Hi Andy,

On 05/19/2015 07:21 PM, Andy Lutomirski wrote:
> On Tue, May 19, 2015 at 12:56 AM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> Hi Andy,
>>
>> Thanks for this patch. There are some broken pieces though. Also,
>> I have some minor questions about the API design. See below.
>>
>> On 05/15/2015 08:43 AM, Andy Lutomirski wrote:
>>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>>> ---
>>>
>>> There was no v1.  I'm calling this v2 to keep it in sync with the kernel
>>> patch versioning.
>>>
>>>  man2/prctl.2        | 10 ++++++++++
>>>  man7/capabilities.7 | 32 ++++++++++++++++++++++++++------
>>>  2 files changed, 36 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/man2/prctl.2 b/man2/prctl.2
>>> index b352f6283624..5861e3aefe9a 100644
>>> --- a/man2/prctl.2
>>> +++ b/man2/prctl.2
>>> @@ -949,6 +949,16 @@ had been called.
>>>  For further information on Intel MPX, see the kernel source file
>>>  .IR Documentation/x86/intel_mpx.txt .
>>>  .\"
>>> +.TP
>>> +.BR PR_CAP_AMBIENT " (since Linux 4.2)"
>>> +Reads or changes the ambient capability set.  If arg2 is PR_CAP_AMBIENT_RAISE,
>>> +then the capability specified in arg3 is added to the ambient set.  This will
>>> +fail, returning EPERM, if the capability is not already both permitted and
>>> +inheritable or if the SECBIT_NO_CAP_AMBIENT_RAISE securebit is set.  If arg2
>>> +is PR_CAP_AMBIENT_LOWER, then the capability specified in arg3 is removed
>>> +from the ambient set.  If arg2 is PR_CAP_AMBIENT_GET, then
>>> +.BR prctl (2)
>>> +will return 1 if the capability in arg3 is in the ambient set and 0 if not.
>>
>> Some API design questions:
>>
>> 1. We already have prctl() operations that work on some capability sets:
>>    PR_CAPBSET_READ and PR_CAPBSET_DROP. These don't use arg3; the operation
>>    is directly encoded in the first argument of prctl(). Just to keep some
>>    consistency, why not do things the same way for these new operations?
> 
> I'm torn.  On the one hand, consistency is nice.  On the other hand,
> prctl is a mess 

Agreed.

> and trying to organize new additions seems like a good
> idea.

Sure, but what is your organizing principle here? (I don't feel strongly
about it, but it's not clear to me what trumps the (mild) degree of 
consistency that I suggest.)


>>    Also, you could opt for some consistency in the naming, so using "READ"
>>    rather than "GET", for example. On the other hand, both "READ" and "GET"
>>    are suboptimal names: this is really a test operation. So, maybe a
>>    clean break to a good name, PR_CAP_AMBIENT_IS_SET, is best?
> 
> I like IS_SET.

Okay.

>>    Thus:
>>
>>      prctl(PR_CAP_AMBIENT_READ, cap, 0, 0, 0);  // or PR_CAP_AMBIENT_IS_SET?
>>      prctl(PR_CAP_AMBIENT_RAISE, cap, 0, 0, 0);
>>      prctl(PR_CAP_AMBIENT_LOWER, cap, 0, 0, 0);
>>
>> 2. In terms of the API design, would it be useful to have a prctl() operation
>>    that clears the entire ambient set?
>>
>>      prctl(PR_CAP_AMBIENT_ZERO, 0, 0, 0, 0);    // or PR_CAP_AMBIENT_EMPTY?
> 
> Seems like a good idea.  How about _CLEAR?

Also good.

[...]

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
