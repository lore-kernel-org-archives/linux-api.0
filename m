From: Laurent Vivier <laurent@vivier.eu>
Subject: Re: [PATCH v6 0/1] ns: introduce binfmt_misc namespace
Date: Sat, 29 Dec 2018 16:41:27 +0100
Message-ID: <a1003659-3c16-5921-b221-befd078dfa42@vivier.eu>
References: <20181010161430.11633-1-laurent@vivier.eu>
 <7ed6f823-547b-922d-59ff-aba9c4c3ab39@vivier.eu>
 <1541041159.4632.6.camel@HansenPartnership.com>
 <CAG48ez3HnkRM6bUZMNjuTy5DgujgamEKhZOEWDfCjqW7fTJSzQ@mail.gmail.com>
 <fcebfa0c-b389-5c4d-19b8-2f08b487ec25@vivier.eu>
 <87zhusq3x7.fsf@xmission.com>
 <36933e07-d7b3-49be-4ad9-2028fa1977f7@vivier.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <36933e07-d7b3-49be-4ad9-2028fa1977f7@vivier.eu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jann Horn <jannh@google.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, dima@arista.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Ping

Thanks,
Laurent

Le 29/11/2018 à 14:05, Laurent Vivier a écrit :
> Le 01/11/2018 à 15:16, Eric W. Biederman a écrit :
>> Laurent Vivier <laurent@vivier.eu> writes:
>>
>>> On 01/11/2018 04:51, Jann Horn wrote:
>>>> On Thu, Nov 1, 2018 at 3:59 AM James Bottomley
>>>> <James.Bottomley@hansenpartnership.com> wrote:
>>>>>
>>>>> On Tue, 2018-10-16 at 11:52 +0200, Laurent Vivier wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Any comment on this last version?
>>>>>>
>>>>>> Any chance to be merged?
>>>>>
>>>>> I've got a use case for this:  I went to one of the Graphene talks in
>>>>> Edinburgh and it struck me that we seem to keep reinventing the type of
>>>>> sandboxing that qemu-user already does.  However if you want to do an
>>>>> x86 on x86 sandbox, you can't currently use the binfmt_misc mechanism
>>>>> because that has you running *every* binary on the system emulated.
>>>>> Doing it per user namespace fixes this problem and allows us to at
>>>>> least cut down on all the pointless duplication.
>>>>
>>>> Waaaaaait. What? qemu-user does not do "sandboxing". qemu-user makes
>>>> your code slower and *LESS* secure. As far as I know, qemu-user is
>>>> only intended for purposes like development and testing.
>>>>
>>>
>>> I think the idea here is not to run qemu, but to use an interpreter
>>> (something like gVisor) into a container to control the binaries
>>> execution inside the container without using this interpreter on the
>>> host itself (container and host shares the same binfmt_misc
>>> magic/mask).
>>
>> Please remind me of this patchset after the merge window is over, and if
>> there are no issues I will take it via my user namespace branch.
>>
>> Last I looked I had a concern that some of the permission check issues
>> were being papered over by using override cred instead of fixing the
>> deaper code.  Sometimes they are necessary but seeing work-arounds
>> instead of fixes for problems tends to be a maintenance issue, possibly
>> with security consequences.  Best is if the everyone agrees on how all
>> of the interfaces work so their are no surprises.
> 
> I don't know where we are in the merge window, but is there something I
> can do to have this merged?
> 
> Thanks,
> Laurent
> 
