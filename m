Return-Path: <SRS0=y6mp=BY=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2F3C433E4
	for <linux-api@archiver.kernel.org>; Fri, 14 Aug 2020 08:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E38022068E
	for <linux-api@archiver.kernel.org>; Fri, 14 Aug 2020 08:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgHNIGO (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgHNIGO (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 14 Aug 2020 04:06:14 -0400
Received: from gardel.0pointer.net (gardel.0pointer.net [IPv6:2a01:238:43ed:c300:10c3:bcf3:3266:da74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B63C061383;
        Fri, 14 Aug 2020 01:06:14 -0700 (PDT)
Received: from gardel-login.0pointer.net (gardel.0pointer.net [85.214.157.71])
        by gardel.0pointer.net (Postfix) with ESMTP id AFD0EE81502;
        Fri, 14 Aug 2020 10:06:12 +0200 (CEST)
Received: by gardel-login.0pointer.net (Postfix, from userid 1000)
        id 5D7A616081D; Fri, 14 Aug 2020 10:06:12 +0200 (CEST)
Date:   Fri, 14 Aug 2020 10:06:12 +0200
From:   Lennart Poettering <mzxreary@0pointer.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Howells <dhowells@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Karel Zak <kzak@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Christian Brauner <christian@brauner.io>,
        Linux API <linux-api@vger.kernel.org>,
        Ian Kent <raven@themaw.net>,
        LSM <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: file metadata via fs API (was: [GIT PULL] Filesystem Information)
Message-ID: <20200814080612.GB230635@gardel-login>
References: <1842689.1596468469@warthog.procyon.org.uk>
 <1845353.1596469795@warthog.procyon.org.uk>
 <CAJfpegunY3fuxh486x9ysKtXbhTE0745ZCVHcaqs9Gww9RV2CQ@mail.gmail.com>
 <ac1f5e3406abc0af4cd08d818fe920a202a67586.camel@themaw.net>
 <CAJfpegu8omNZ613tLgUY7ukLV131tt7owR+JJ346Kombt79N0A@mail.gmail.com>
 <CAJfpegtNP8rQSS4Z14Ja4x-TOnejdhDRTsmmDD-Cccy2pkfVVw@mail.gmail.com>
 <20200811135419.GA1263716@miu.piliscsaba.redhat.com>
 <CAHk-=wjzLmMRf=QG-n+1HnxWCx4KTQn9+OhVvUSJ=ZCQd6Y1WA@mail.gmail.com>
 <52483.1597190733@warthog.procyon.org.uk>
 <CAHk-=wiPx0UJ6Q1X=azwz32xrSeKnTJcH8enySwuuwnGKkHoPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wiPx0UJ6Q1X=azwz32xrSeKnTJcH8enySwuuwnGKkHoPA@mail.gmail.com>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mi, 12.08.20 11:18, Linus Torvalds (torvalds@linux-foundation.org) wrote:

> On Tue, Aug 11, 2020 at 5:05 PM David Howells <dhowells@redhat.com> wrote:
> >
> > Well, the start of it was my proposal of an fsinfo() system call.
>
> Ugh. Ok, it's that thing.
>
> This all seems *WAY* over-designed - both your fsinfo and Miklos' version.
>
> What's wrong with fstatfs()? All the extra magic metadata seems to not
> really be anything people really care about.
>
> What people are actually asking for seems to be some unique mount ID,
> and we have 16 bytes of spare information in 'struct statfs64'.

statx() exposes a `stx_mnt_id` field nowadays. So that's easy and
quick to get nowadays. It's just so inefficient matching that up with
/proc/self/mountinfo then. And it still won't give you any of the fs
capability bits (time granularity, max file size, features, …),
because the kernel doesn't expose that at all right now.

OTOH I'd already be quite happy if struct statfs64 would expose
f_features, f_max_fsize, f_time_granularity, f_charset_case_handling
fields or so.

Lennart

--
Lennart Poettering, Berlin
