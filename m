From: Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [RFC PATCH v8 0/5] IPC: checkpoint/restore in userspace enhancements
Date: Mon, 14 Jan 2013 01:31:04 -0500
Message-ID: <CA+1xoqfDyEf7bxHYf2ZtuJ2ah-+H4+9XWRPs26FxqoJg7xF7kA@mail.gmail.com>
References: <20121024151555.5642.79086.stgit@localhost.localdomain>
 <20121218123601.113a29c0.akpm@linux-foundation.org> <50D28EC8.7000708@parallels.com>
 <20121220124751.d7ccbd8e.akpm@linux-foundation.org> <50D4CA90.60205@parallels.com>
 <50D4DB5D.9020309@oracle.com> <50D5D50B.8090309@oracle.com> <50ED293D.9050605@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50ED293D.9050605@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, serge.hallyn@canonical.com, ebiederm@xmission.com, linux-kernel@vger.kernel.org, xemul@parallels.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, cmetcalf@tilera.com, joe.korty@ccur.com, dhowells@redhat.com, dledford@redhat.com, viro@zeniv.linux.org.uk, kosaki.motohiro@jp.fujitsu.com, linux-api@vger.kernel.org, serue@us.ibm.com, tglx@linutronix.de, paulmck@linux.vnet.ibm.com, devel@openvz.org, mtk.manpages@gmail.com, Wu Fengguang <fengguang.wu@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 9, 2013 at 3:24 AM, Stanislav Kinsbursky
<skinsbursky@parallels.com> wrote:
> 22.12.2012 19:43, Sasha Levin =D0=C9=DB=C5=D4:
>
>> On 12/21/2012 04:57 PM, Sasha Levin wrote:
>>>
>>> On 12/21/2012 03:46 PM, Stanislav Kinsbursky wrote:
>>>>
>>>> 21.12.2012 00:47, Andrew Morton =D0=C9=DB=C5=D4:
>>>>>
>>>>> On Thu, 20 Dec 2012 08:06:32 +0400
>>>>> Stanislav Kinsbursky<skinsbursky@parallels.com>  wrote:
>>>>>
>>>>>> 19.12.2012 00:36, Andrew Morton __________:
>>>>>>>
>>>>>>> On Wed, 24 Oct 2012 19:34:51 +0400
>>>>>>> Stanislav Kinsbursky<skinsbursky@parallels.com>  wrote:
>>>>>>>
>>>>>>>> This respin of the patch set was significantly reworked. Most =
part
>>>>>>>> of new API
>>>>>>>> was replaced by sysctls (by one per messages, semaphores and s=
hared
>>>>>>>> memory),
>>>>>>>> allowing to preset desired id for next new IPC object.
>>>>>>>>
>>>>>>>> This patch set is aimed to provide additional functionality fo=
r all
>>>>>>>> IPC
>>>>>>>> objects, which is required for migration of these objects by
>>>>>>>> user-space
>>>>>>>> checkpoint/restore utils (CRIU).
>>>>>>>>
>>>>>>>> The main problem here was impossibility to set up object id. T=
his
>>>>>>>> patch set
>>>>>>>> solves the problem by adding new sysctls for preset of desired=
 id
>>>>>>>> for new IPC
>>>>>>>> object.
>>>>>>>>
>>>>>>>> Another problem was to peek messages from queues without delet=
ing
>>>>>>>> them.
>>>>>>>> This was achived by introducing of new MSG_COPY flag for
>>>>>>>> sys_msgrcv(). If
>>>>>>>> MSG_COPY flag is set, then msgtyp is interpreted as message nu=
mber.
>>>>>>>
>>>>>>> According to my extensive records, Sasha hit a bug in
>>>>>>> ipc-message-queue-copy-feature-introduced.patch and Fengguang f=
ound a
>>>>>>> bug in
>>>>>>>
>>>>>>> ipc-message-queue-copy-feature-introduced-cleanup-do_msgrcv-aro=
ung-msg_copy-feature.patch
>>>>>>>
>>>>>>> It's not obvious (to me) that these things have been identified=
 and
>>>>>>> fixed.  What's the status, please?
>>>>>>
>>>>>> Hello, Andrew.
>>>>>> Fengguang's issue was solved by "ipc: simplify message copying" =
I sent
>>>>>> you.
>>>>>> But I can't find Sasha's issue. As I remember, there was some pr=
oblem
>>>>>> in
>>>>>> early
>>>>>> version of the patch set. But I believe its fixed now.
>>>>>
>>>>> http://lkml.indiana.edu/hypermail/linux/kernel/1210.3/01710.html
>>>>>
>>>>> Subject: "ipc, msgqueue: NULL ptr deref in msgrcv"
>>>>
>>>>
>>>> Ah, yes. Thanks.
>>>> Hi found it in initial version of code, which was significantly ch=
anged
>>>> (or cleaned and simplified) by further patch series.
>>>> And I cant find out, how this can happen, because this patch he bi=
sect
>>>> to do not modify the queue itself, while he found the
>>>> problem in testmsg.
>>>
>>>
>>> I actually can't reproduce it on the latest -next.
>>>
>>> I was reverting the IPC changes in the past couple of weeks so that=
 I
>>> could test the
>>> rest of the IPC code with the fuzzer, and when I added them back in=
 again
>>> I can't
>>> reproduce the issue I've reported earlier.
>>>
>>> We can probably figure out where it got fixed by bisecting between =
-next
>>> trees if anyone
>>> is interested in that.
>>
>>
>> Ignore that. It just took more fuzzing to stumble on it again:
>>
>
> Hello, Sasha!
> Thanks!
> But I still can't understand, how this can happen... And I can't repr=
oduce.
> Could you specify your load? I.e. how do you stumble on this panic?
> Looks like you don't use new "copy" feature.

I just fuzz with trinity
(http://git.codemonkey.org.uk/?p=3Dtrinity.git;a=3Dtree) inside a prett=
y
basic KVM guest.


Thanks,
Sasha
