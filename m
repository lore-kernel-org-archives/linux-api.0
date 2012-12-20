From: Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC PATCH v8 0/5] IPC: checkpoint/restore in userspace enhancements
Date: Thu, 20 Dec 2012 08:06:32 +0400
Message-ID: <50D28EC8.7000708@parallels.com>
References: <20121024151555.5642.79086.stgit@localhost.localdomain> <20121218123601.113a29c0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121218123601.113a29c0.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org, joe.korty-oXJCJecloQs@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

19.12.2012 00:36, Andrew Morton =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Wed, 24 Oct 2012 19:34:51 +0400
> Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>
>> This respin of the patch set was significantly reworked. Most part o=
f new API
>> was replaced by sysctls (by one per messages, semaphores and shared =
memory),
>> allowing to preset desired id for next new IPC object.
>>
>> This patch set is aimed to provide additional functionality for all =
IPC
>> objects, which is required for migration of these objects by user-sp=
ace
>> checkpoint/restore utils (CRIU).
>>
>> The main problem here was impossibility to set up object id. This pa=
tch set
>> solves the problem by adding new sysctls for preset of desired id fo=
r new IPC
>> object.
>>
>> Another problem was to peek messages from queues without deleting th=
em.
>> This was achived by introducing of new MSG_COPY flag for sys_msgrcv(=
). If
>> MSG_COPY flag is set, then msgtyp is interpreted as message number.
> According to my extensive records, Sasha hit a bug in
> ipc-message-queue-copy-feature-introduced.patch and Fengguang found a
> bug in
> ipc-message-queue-copy-feature-introduced-cleanup-do_msgrcv-aroung-ms=
g_copy-feature.patch
>
> It's not obvious (to me) that these things have been identified and
> fixed.  What's the status, please?

Hello, Andrew.
=46engguang's issue was solved by "ipc: simplify message copying" I sen=
t you.
But I can't find Sasha's issue. As I remember, there was some problem i=
n=20
early
version of the patch set. But I believe its fixed now.
