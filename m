Return-Path: <SRS0=K6MG=4U=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABBC7C3F2D9
	for <linux-api@archiver.kernel.org>; Tue,  3 Mar 2020 15:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E01F20842
	for <linux-api@archiver.kernel.org>; Tue,  3 Mar 2020 15:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbgCCPVM (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 3 Mar 2020 10:21:12 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51874 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728787AbgCCPVL (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 3 Mar 2020 10:21:11 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j99Lt-0008Dj-DE; Tue, 03 Mar 2020 08:20:57 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j99Ls-00074l-Ha; Tue, 03 Mar 2020 08:20:57 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        <linux-api@vger.kernel.org>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87a74zmfc9.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87k142lpfz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <875zfmloir.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87v9nmjulm.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <202003021531.C77EF10@keescook>
        <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
        <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 03 Mar 2020 09:18:44 -0600
In-Reply-To: <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Tue, 3 Mar 2020 13:02:51 +0000")
Message-ID: <87v9nlii0b.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j99Ls-00074l-Ha;;;mid=<87v9nlii0b.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19rGY6nP+Gy6pmv+g93hLTd2evDLDDhunA=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCHv5] exec: Fix a deadlock in ptrace
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> This fixes a deadlock in the tracer when tracing a multi-threaded
> application that calls execve while more than one thread are running.
>
> I observed that when running strace on the gcc test suite, it always
> blocks after a while, when expect calls execve, because other threads
> have to be terminated.  They send ptrace events, but the strace is no
> longer able to respond, since it is blocked in vm_access.
>
> The deadlock is always happening when strace needs to access the
> tracees process mmap, while another thread in the tracee starts to
> execve a child process, but that cannot continue until the
> PTRACE_EVENT_EXIT is handled and the WIFEXITED event is received:

A couple of things.

Why do we think it is safe to change the behavior exposed to userspace?
Not the deadlock but all of the times the current code would not
deadlock?

Especially given that this is a small window it might be hard for people
to track down and report so we need a strong argument that this won't
break existing userspace before we just change things.

Usually surveying all of the users of a system call that we can find
and checking to see if they might be affected by the change in behavior
is difficult enough that we usually opt for not being lazy and
preserving the behavior.

This patch is up to two changes in behavior now, that could potentially
affect a whole array of programs.  Adding linux-api so that this change
in behavior can be documented if/when this change goes through.

If you can split the documentation and test fixes out into separate
patches that would help reviewing this code, or please make it explicit
that the your are changing documentation about behavior that is changing
with this patch.

Eric

> diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
> new file mode 100644
> index 0000000..6d8a048
> --- /dev/null
> +++ b/tools/testing/selftests/ptrace/vmaccess.c
> @@ -0,0 +1,66 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (c) 2020 Bernd Edlinger <bernd.edlinger@hotmail.de>
> + * All rights reserved.
> + *
> + * Check whether /proc/$pid/mem can be accessed without causing deadlocks
> + * when de_thread is blocked with ->cred_guard_mutex held.
> + */
> +
> +#include "../kselftest_harness.h"
> +#include <stdio.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <signal.h>
> +#include <unistd.h>
> +#include <sys/ptrace.h>
> +
> +static void *thread(void *arg)
> +{
> +	ptrace(PTRACE_TRACEME, 0, 0L, 0L);
> +	return NULL;
> +}
> +
> +TEST(vmaccess)
> +{
> +	int f, pid = fork();
> +	char mm[64];
> +
> +	if (!pid) {
> +		pthread_t pt;
> +
> +		pthread_create(&pt, NULL, thread, NULL);
> +		pthread_join(pt, NULL);
> +		execlp("true", "true", NULL);
> +	}
> +
> +	sleep(1);
> +	sprintf(mm, "/proc/%d/mem", pid);
> +	f = open(mm, O_RDONLY);
> +	ASSERT_LE(0, f);
> +	close(f);
> +	f = kill(pid, SIGCONT);
> +	ASSERT_EQ(0, f);
> +}
> +
> +TEST(attach)
> +{
> +	int f, pid = fork();
> +
> +	if (!pid) {
> +		pthread_t pt;
> +
> +		pthread_create(&pt, NULL, thread, NULL);
> +		pthread_join(pt, NULL);
> +		execlp("true", "true", NULL);
> +	}
> +
> +	sleep(1);
> +	f = ptrace(PTRACE_ATTACH, pid, 0L, 0L);

To be meaningful this code needs to learn to loop when
ptrace returns -EAGAIN.

Because that is pretty much what any self respecting user space
process will do.

At which point I am not certain we can say that the behavior has
sufficiently improved not to be a deadlock.

> +	ASSERT_EQ(EAGAIN, errno);
> +	ASSERT_EQ(f, -1);
> +	f = kill(pid, SIGCONT);
> +	ASSERT_EQ(0, f);
> +}
> +
> +TEST_HARNESS_MAIN

Eric
