Return-Path: <SRS0=k0wc=6S=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76856C47257
	for <linux-api@archiver.kernel.org>; Mon,  4 May 2020 17:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E1362073E
	for <linux-api@archiver.kernel.org>; Mon,  4 May 2020 17:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbgEDRNN (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 4 May 2020 13:13:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41248 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730179AbgEDRNM (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 4 May 2020 13:13:12 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jVeeT-000475-56; Mon, 04 May 2020 11:13:09 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jVeeS-0007Cd-8B; Mon, 04 May 2020 11:13:09 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge@hallyn.com>, Jann Horn <jannh@google.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Aleksa Sarai <cyphar@cyphar.com>, linux-api@vger.kernel.org
References: <20200504144141.3605533-1-christian.brauner@ubuntu.com>
        <20200504144141.3605533-3-christian.brauner@ubuntu.com>
        <87h7wvoefw.fsf@x220.int.ebiederm.org>
        <20200504163907.jjgqe7qnnjpw4uwo@wittgenstein>
Date:   Mon, 04 May 2020 12:09:46 -0500
In-Reply-To: <20200504163907.jjgqe7qnnjpw4uwo@wittgenstein> (Christian
        Brauner's message of "Mon, 4 May 2020 18:39:07 +0200")
Message-ID: <87ftcfmxt1.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jVeeS-0007Cd-8B;;;mid=<87ftcfmxt1.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19bqNapwp8vFn0s3C2ELzsRQSZ1zw8pn/A=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v3 2/3] nsproxy: attach to namespaces via pidfds
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Christian Brauner <christian.brauner@ubuntu.com> writes:

> On Mon, May 04, 2020 at 11:25:07AM -0500, Eric W. Biederman wrote:
>> 
>> I am not thrilled about treating nstype as a flags fields when it is not
>> currently.  It was my hope when I designed the interface that not
>> treating nstype as a flags field would save us from the problem of bits
>> running out.
>
> Hm, I researched the setns() syscall history before that and I didn't
> see that reasoning anywhere. The "nstype" arg was originally advertised
> on the list as "having a flags field is useful in general".

Take a look at the code.  At the end of the day nstype is not treated at
all like a flags field.

It isn't a very important point.  And it was certainly easier to use
the existing bits for essentially their existing meanings.  But it was
certainly something I was thinking at the time.

I think I left it as we can see either way, depending on how things
evolve.

I can imagine a use for a nstype being a single namespace from a pidfd.
Do you have any actual usecases for setting some but not all of the
namespaces from a pidfd?  If we don't have a compelling reason
I would like to kick that can down the road a ways farther.

I am also remembering that that setns freed the low 8 bits.  Which gave
some freedom beyond clone.

>> That aside.  It would be very good if the default version of setting
>> everything from a pidfd would set the root directory from the process it
>> is copying everything else from.
>
> I'm not sure I follow completely. If you specify CLONE_NEWNS then we do
> set the root directory with set_fs_root() in commit_nsset(). Or are you
> saying we should always do that independent of whether or not
> CLONE_NEWNS is specified? And if so could you explain why we'd want
> that? I'm sure I'm missing something!

I am suggesting that when we do:

"setns(pidfd, 0)" or "setns(pidfd, SETNS_PIDFD)"

That the result is not just the namespaces changing but also the root
directory changing to the pids root directory.  Something where the
whole is greater than the parts.

Eric

