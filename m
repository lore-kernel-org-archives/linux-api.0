From: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v8 0/5] IPC: checkpoint/restore in userspace enhancements
Date: Fri, 21 Dec 2012 16:57:49 -0500
Message-ID: <50D4DB5D.9020309@oracle.com>
References: <20121024151555.5642.79086.stgit@localhost.localdomain> <20121218123601.113a29c0.akpm@linux-foundation.org> <50D28EC8.7000708@parallels.com> <20121220124751.d7ccbd8e.akpm@linux-foundation.org> <50D4CA90.60205@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50D4CA90.60205-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org, joe.korty-oXJCJecloQs@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/21/2012 03:46 PM, Stanislav Kinsbursky wrote:
> 21.12.2012 00:47, Andrew Morton =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> On Thu, 20 Dec 2012 08:06:32 +0400
>> Stanislav Kinsbursky<skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>>
>>> 19.12.2012 00:36, Andrew Morton __________:
>>>> On Wed, 24 Oct 2012 19:34:51 +0400
>>>> Stanislav Kinsbursky<skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>>>>
>>>>> This respin of the patch set was significantly reworked. Most par=
t of new API
>>>>> was replaced by sysctls (by one per messages, semaphores and shar=
ed memory),
>>>>> allowing to preset desired id for next new IPC object.
>>>>>
>>>>> This patch set is aimed to provide additional functionality for a=
ll IPC
>>>>> objects, which is required for migration of these objects by user=
-space
>>>>> checkpoint/restore utils (CRIU).
>>>>>
>>>>> The main problem here was impossibility to set up object id. This=
 patch set
>>>>> solves the problem by adding new sysctls for preset of desired id=
 for new IPC
>>>>> object.
>>>>>
>>>>> Another problem was to peek messages from queues without deleting=
 them.
>>>>> This was achived by introducing of new MSG_COPY flag for sys_msgr=
cv(). If
>>>>> MSG_COPY flag is set, then msgtyp is interpreted as message numbe=
r.
>>>> According to my extensive records, Sasha hit a bug in
>>>> ipc-message-queue-copy-feature-introduced.patch and Fengguang foun=
d a
>>>> bug in
>>>> ipc-message-queue-copy-feature-introduced-cleanup-do_msgrcv-aroung=
-msg_copy-feature.patch
>>>>
>>>> It's not obvious (to me) that these things have been identified an=
d
>>>> fixed.  What's the status, please?
>>> Hello, Andrew.
>>> Fengguang's issue was solved by "ipc: simplify message copying" I s=
ent you.
>>> But I can't find Sasha's issue. As I remember, there was some probl=
em in
>>> early
>>> version of the patch set. But I believe its fixed now.
>> http://lkml.indiana.edu/hypermail/linux/kernel/1210.3/01710.html
>>
>> Subject: "ipc, msgqueue: NULL ptr deref in msgrcv"
>=20
> Ah, yes. Thanks.
> Hi found it in initial version of code, which was significantly chang=
ed (or cleaned and simplified) by further patch series.
> And I cant find out, how this can happen, because this patch he bisec=
t to do not modify the queue itself, while he found the
> problem in testmsg.

I actually can't reproduce it on the latest -next.

I was reverting the IPC changes in the past couple of weeks so that I c=
ould test the
rest of the IPC code with the fuzzer, and when I added them back in aga=
in I can't
reproduce the issue I've reported earlier.

We can probably figure out where it got fixed by bisecting between -nex=
t trees if anyone
is interested in that.


Thanks,
Sasha
