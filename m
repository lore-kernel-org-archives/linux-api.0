From: Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [RFC][PATCH] ipc: Remove IPCMNI
Date: Thu, 29 Mar 2018 10:47:45 +0200
Message-ID: <3e201de2-bed2-6f7d-0783-700d095142e0@colorfullife.com>
References: <1520885744-1546-1-git-send-email-longman@redhat.com>
 <1520885744-1546-5-git-send-email-longman@redhat.com>
 <87woyfyh57.fsf@xmission.com>
 <5d4a858a-3136-5ef4-76fe-a61e7f2aed56@redhat.com>
 <87o9jru3bf.fsf@xmission.com>
 <935a7c50-50cc-2dc0-33bb-92c000d039bc@redhat.com>
 <87woyego2u.fsf_-_@xmission.com>
 <047c6ed6-6581-b543-ba3d-cadc543d3d25@redhat.com>
 <87h8ph6u67.fsf@xmission.com>
 <7d3a1f93-f8e5-5325-f9a7-0079f7777b6f@redhat.com>
 <20180329021409.gcjjrmviw2lckbfk@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180329021409.gcjjrmviw2lckbfk@linux-n805>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>, Waiman Long <longman@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, Stanislav Kinsbursky <skinsbursky@parallels.com>, Linux Containers <containers@lists.linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello together,

On 03/29/2018 04:14 AM, Davidlohr Bueso wrote:
> Cc'ing mtk, Manfred and linux-api.
>
> See below.
>
> On Thu, 15 Mar 2018, Waiman Long wrote:
>
>> On 03/15/2018 03:00 PM, Eric W. Biederman wrote:
>>> Waiman Long <longman@redhat.com> writes:
>>>
>>>> On 03/14/2018 08:49 PM, Eric W. Biederman wrote:
>>>>> The define IPCMNI was originally the size of a statically sized 
>>>>> array in
>>>>> the kernel and that has long since been removed. Therefore there 
>>>>> is no
>>>>> fundamental reason for IPCMNI.
>>>>>
>>>>> The only remaining use IPCMNI serves is as a convoluted way to format
>>>>> the ipc id to userspace.  It does not appear that anything except for
>>>>> the CHECKPOINT_RESTORE code even cares about this variety of 
>>>>> assignment
>>>>> and the CHECKPOINT_RESTORE code only cares about this weirdness 
>>>>> because
>>>>> it has to restore these peculiar ids.
>>>>>
My assumption is that if an array is recreated, it should get a 
different id.
     a=semget(1234,,);
     semctl(a,,IPC_RMID);
     b=semget(1234,,);
now a!=b.

Rational: semop() calls only refer to the array by the id.
If there is a stale process in the system that tries to access the "old" 
array and the new array has the same id, then the locking gets corrupted.
>>>>> Therefore make the assignment of ipc ids match the description in
>>>>> Advanced Programming in the Unix Environment and assign the next id
>>>>> until INT_MAX is hit then loop around to the lower ids.
>>>>>
Ok, sounds good.
That way we really cycle through INT_MAX, right now a==b would happen 
after 128k RMID calls.
>>>>> This can be implemented trivially with the current code using 
>>>>> idr_alloc_cyclic.
>>>>>
Is there a performance impact?
Right now, the idr tree is only large if there are lots of objects.
What happens if we have only 1 object, with id=INT_MAX-1?

semop() that do not sleep are fairly fast.
The same applies for msgsnd/msgrcv, if the message is small enough.

@Davidlohr:
Do you know if there are application that frequently call semop() and it 
doesn't have to sleep?
 From the scalability that was pushed into the kernel, I assume that 
this exists.

I have myself only checked postgresql, and postgresql always sleeps.
(and this was long ago)
>>>>> To make it possible to keep checkpoint/restore working I have renamed
>>>>> the sysctls from xxx_next_id to xxx_nextid.  That is enough change 
>>>>> that
>>>>> a smart CRIU implementation can see that what is exported has 
>>>>> changed,
>>>>> and act accordingly.  New kernels will be able to restore the old 
>>>>> id's.
>>>>>
>>>>> This code still needs some real world testing to verify my 
>>>>> assumptions.
>>>>> And some work with the CRIU implementations to actually add the code
>>>>> that deals with the new for of id assignment.
>>>>>
It means that all existing checkpoint/restore application will not work 
with a new kernel.
Everyone must first update the checkpoint/restore application, then 
update the kernel.

Is this acceptable?

--
     Manfred
