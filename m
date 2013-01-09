From: Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC PATCH v8 0/5] IPC: checkpoint/restore in userspace enhancements
Date: Wed, 9 Jan 2013 12:24:29 +0400
Message-ID: <50ED293D.9050605@parallels.com>
References: <20121024151555.5642.79086.stgit@localhost.localdomain> <20121218123601.113a29c0.akpm@linux-foundation.org> <50D28EC8.7000708@parallels.com> <20121220124751.d7ccbd8e.akpm@linux-foundation.org> <50D4CA90.60205@parallels.com> <50D4DB5D.9020309@oracle.com> <50D5D50B.8090309@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50D5D50B.8090309-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org, joe.korty-oXJCJecloQs@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

22.12.2012 19:43, Sasha Levin =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On 12/21/2012 04:57 PM, Sasha Levin wrote:
>> On 12/21/2012 03:46 PM, Stanislav Kinsbursky wrote:
>>> 21.12.2012 00:47, Andrew Morton =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>> On Thu, 20 Dec 2012 08:06:32 +0400
>>>> Stanislav Kinsbursky<skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>>>>
>>>>> 19.12.2012 00:36, Andrew Morton __________:
>>>>>> On Wed, 24 Oct 2012 19:34:51 +0400
>>>>>> Stanislav Kinsbursky<skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>>>>>>
>>>>>>> This respin of the patch set was significantly reworked. Most p=
art of new API
>>>>>>> was replaced by sysctls (by one per messages, semaphores and sh=
ared memory),
>>>>>>> allowing to preset desired id for next new IPC object.
>>>>>>>
>>>>>>> This patch set is aimed to provide additional functionality for=
 all IPC
>>>>>>> objects, which is required for migration of these objects by us=
er-space
>>>>>>> checkpoint/restore utils (CRIU).
>>>>>>>
>>>>>>> The main problem here was impossibility to set up object id. Th=
is patch set
>>>>>>> solves the problem by adding new sysctls for preset of desired =
id for new IPC
>>>>>>> object.
>>>>>>>
>>>>>>> Another problem was to peek messages from queues without deleti=
ng them.
>>>>>>> This was achived by introducing of new MSG_COPY flag for sys_ms=
grcv(). If
>>>>>>> MSG_COPY flag is set, then msgtyp is interpreted as message num=
ber.
>>>>>> According to my extensive records, Sasha hit a bug in
>>>>>> ipc-message-queue-copy-feature-introduced.patch and Fengguang fo=
und a
>>>>>> bug in
>>>>>> ipc-message-queue-copy-feature-introduced-cleanup-do_msgrcv-arou=
ng-msg_copy-feature.patch
>>>>>>
>>>>>> It's not obvious (to me) that these things have been identified =
and
>>>>>> fixed.  What's the status, please?
>>>>> Hello, Andrew.
>>>>> Fengguang's issue was solved by "ipc: simplify message copying" I=
 sent you.
>>>>> But I can't find Sasha's issue. As I remember, there was some pro=
blem in
>>>>> early
>>>>> version of the patch set. But I believe its fixed now.
>>>> http://lkml.indiana.edu/hypermail/linux/kernel/1210.3/01710.html
>>>>
>>>> Subject: "ipc, msgqueue: NULL ptr deref in msgrcv"
>>>
>>> Ah, yes. Thanks.
>>> Hi found it in initial version of code, which was significantly cha=
nged (or cleaned and simplified) by further patch series.
>>> And I cant find out, how this can happen, because this patch he bis=
ect to do not modify the queue itself, while he found the
>>> problem in testmsg.
>>
>> I actually can't reproduce it on the latest -next.
>>
>> I was reverting the IPC changes in the past couple of weeks so that =
I could test the
>> rest of the IPC code with the fuzzer, and when I added them back in =
again I can't
>> reproduce the issue I've reported earlier.
>>
>> We can probably figure out where it got fixed by bisecting between -=
next trees if anyone
>> is interested in that.
>
> Ignore that. It just took more fuzzing to stumble on it again:
>

Hello, Sasha!
Thanks!
But I still can't understand, how this can happen... And I can't reprod=
uce.
Could you specify your load? I.e. how do you stumble on this panic?
Looks like you don't use new "copy" feature.

> [  103.164594] BUG: unable to handle kernel NULL pointer dereference =
at 0000000000000010
> [  103.168159] IP: [<ffffffff81937155>] do_msgrcv+0x205/0x540
> [  103.170031] PGD c7cd067 PUD d274067 PMD 0
> [  103.170031] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  103.170031] Dumping ftrace buffer:
> [  103.170031]    (ftrace buffer empty)
> [  103.170031] CPU 4
> [  103.170031] Pid: 7056, comm: trinity Tainted: G        W    3.7.0-=
next-20121221-sasha-00014-g339890c #229
> [  103.170031] RIP: 0010:[<ffffffff81937155>]  [<ffffffff81937155>] d=
o_msgrcv+0x205/0x540
> [  103.170031] RSP: 0018:ffff88000c7cfe88  EFLAGS: 00010246
> [  103.170031] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000=
00000000000
> [  103.170031] RDX: ffff880013681f00 RSI: 0000000000000124 RDI: ffff8=
800075a7810
> [  103.170031] RBP: ffff88000c7cff68 R08: 0000000000000000 R09: 00000=
00000000000
> [  103.170031] R10: 0000000000000001 R11: 0000000000000001 R12: 00000=
00000000002
> [  103.170031] R13: ffff8800075a78c0 R14: 7fffffff00000000 R15: ffff8=
800075a7810
> [  103.170031] FS:  00007ffa529ae700(0000) GS:ffff880013c00000(0000) =
knlGS:0000000000000000
> [  103.170031] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  103.170031] CR2: 0000000000000010 CR3: 000000000c7cc000 CR4: 00000=
000000406e0
> [  103.170031] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [  103.170031] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [  103.170031] Process trinity (pid: 7056, threadinfo ffff88000c7ce00=
0, task ffff88000c020000)
> [  103.170031] Stack:
> [  103.170031]  ffff88000c7cfea8 ffff88000c020000 ffff88000c020000 ff=
ff88000c020000
> [  103.170031]  0000000000000000 ffffffff81935e50 0000000000000008 00=
00000000000000
> [  103.170031]  ffffffff858e91e0 0000000000000000 0000000000001001 ff=
ff88000c020000
> [  103.170031] Call Trace:
> [  103.170031]  [<ffffffff81935e50>] ? load_msg+0x170/0x170
> [  103.170031]  [<ffffffff8107e8c4>] ? syscall_trace_enter+0x24/0x2e0
> [  103.170031]  [<ffffffff81184678>] ? trace_hardirqs_on_caller+0x118=
/0x140
> [  103.170031]  [<ffffffff819374a0>] sys_msgrcv+0x10/0x20
> [  103.170031]  [<ffffffff83cdf798>] tracesys+0xe1/0xe6
> [  103.170031] Code: 80 f5 ff ff ff 90 41 83 fc 03 74 32 41 83 fc 04 =
74 0c 41 83 fc 02 75 2c eb 11 0f 1f 40 00 4c 3b 73 10 7d 20
> 66 90 e9 94 00 00 00 <4c> 39 73 10 0f 85 8a 00 00 00 90 eb 0c 66 0f 1=
f 44 00 00 4c 39
> [  103.170031] RIP  [<ffffffff81937155>] do_msgrcv+0x205/0x540
> [  103.170031]  RSP <ffff88000c7cfe88>
> [  103.170031] CR2: 0000000000000010
> [  103.228270] ---[ end trace ddc37199fdad82b0 ]---
>
>
> Thanks,
> Sasha
>


--=20
Best regards,
Stanislav Kinsbursky
