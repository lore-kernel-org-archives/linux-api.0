Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A14C433EF
	for <linux-api@archiver.kernel.org>; Thu, 24 Mar 2022 16:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240690AbiCXQRZ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 24 Mar 2022 12:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238822AbiCXQRZ (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 24 Mar 2022 12:17:25 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55888A94DE;
        Thu, 24 Mar 2022 09:15:52 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:44942)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nXQ7o-00FoyY-PD; Thu, 24 Mar 2022 10:15:49 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:35326 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nXQ7n-007zWn-MU; Thu, 24 Mar 2022 10:15:48 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>, Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian@brauner.io>,
        Amir Goldstein <amir73il@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <20220322192712.709170-1-mszeredi@redhat.com>
        <20220323114215.pfrxy2b6vsvqig6a@wittgenstein>
        <CAJfpegsCKEx41KA1S2QJ9gX9BEBG4_d8igA0DT66GFH2ZanspA@mail.gmail.com>
        <YjudB7XARLlRtBiR@mit.edu>
        <CAJfpegtiRx6jRFUuPeXDxwJpBhYn0ekKkwYbGowUehGZkqVmAw@mail.gmail.com>
Date:   Thu, 24 Mar 2022 11:15:29 -0500
In-Reply-To: <CAJfpegtiRx6jRFUuPeXDxwJpBhYn0ekKkwYbGowUehGZkqVmAw@mail.gmail.com>
        (Miklos Szeredi's message of "Thu, 24 Mar 2022 09:44:38 +0100")
Message-ID: <87k0cje38e.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nXQ7n-007zWn-MU;;;mid=<87k0cje38e.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19vB1678/9LcB58fcqerljPtrf744I8h3E=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [RFC PATCH] getvalues(2) prototype
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Wed, 23 Mar 2022 at 23:20, Theodore Ts'o <tytso@mit.edu> wrote:
>>
>> On Wed, Mar 23, 2022 at 02:24:40PM +0100, Miklos Szeredi wrote:
>> > The reason I stated thinking about this is that Amir wanted a per-sb
>> > iostat interface and dumped it into /proc/PID/mountstats.  And that is
>> > definitely not the right way to go about this.
>> >
>> > So we could add a statfsx() and start filling in new stuff, and that's
>> > what Linus suggested.  But then we might need to add stuff that is not
>> > representable in a flat structure (like for example the stuff that
>> > nfs_show_stats does) and that again needs new infrastructure.
>> >
>> > Another example is task info in /proc.  Utilities are doing a crazy
>> > number of syscalls to get trivial information.  Why don't we have a
>> > procx(2) syscall?  I guess because lots of that is difficult to
>> > represent in a flat structure.  Just take the lsof example: tt's doing
>> > hundreds of thousands of syscalls on a desktop computer with just a
>> > few hundred processes.
>>
>> I'm still a bit puzzled about the reason for getvalues(2) beyond,
>> "reduce the number of system calls".  Is this a performance argument?
>
> One argument that can't be worked around without batchingis atomicity.
> Not sure how important that is, but IIRC it was one of the
> requirements relating to the proposed fsinfo syscall, which this API
> is meant to supersede.   Performance was also oft repeated regarding
> the fsinfo API, but I'm less bought into that.

A silly question.  Have you looked to see if you can perform this work
with io_uring?

I know io_uring does all of the batching already, so I think io_uring is
as ready as anything is to solve the performance issues, and the general
small file problem.  There is also the bpf information extractor (Sorry
I forget what it's proper name is) that also can solve many of the small
read problems.

I am very confused you mention atomicity but I don't see any new
filesystem hooks or anyway you could implement atomicity for reads
much less writes in the patch you posted.

If the real target is something like fsinfo that is returning
information that is not currently available except by possibly
processing /proc/self/mountinfo perhaps a more targeted name would
help.

I certainly did not get the impression when skimming your introduction
to this that you were trying to solve anything except reading a number
of small files.

Eric
