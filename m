Return-Path: <SRS0=YSuu=7B=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87081C433DF
	for <linux-api@archiver.kernel.org>; Tue, 19 May 2020 07:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6779F20709
	for <linux-api@archiver.kernel.org>; Tue, 19 May 2020 07:24:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="tRD/6LNm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgESHY6 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 19 May 2020 03:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbgESHY4 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 19 May 2020 03:24:56 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA687C061A0C
        for <linux-api@vger.kernel.org>; Tue, 19 May 2020 00:24:55 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id f4so13430394iov.11
        for <linux-api@vger.kernel.org>; Tue, 19 May 2020 00:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XTX48UHIYrdm7+oEjTcRQnC536L6yCH/aZ7dAWVWPyo=;
        b=tRD/6LNm+jP7lIRDrecYBHFdUUu/qddKNdZeQzkU81q6GlU1P2PqoHKmTQqBHRBS87
         6tBdY5IQAYWaIK9MiYAfd58PJzLM5DyAc+7Og/4J/Lge0QZr3IZRiAMU/YW9LgnvdXK9
         2N9nzV+8GZto3cOMvM1vFMUUxhdKyjt7xyUnY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XTX48UHIYrdm7+oEjTcRQnC536L6yCH/aZ7dAWVWPyo=;
        b=hP8FbSQkLNIupdaqkZfGn5dE2j1Ulc4hQAZVjhZmfMa2fxl5IMIAbqToPH9Ga6JiDV
         kjJEgdeR+oVUXfLMbApjY1M+afOD+llY/NOumaiL7ulryjUwkccPGzJ9QcMkY+yn+yhw
         H19JeTwevazvqX5adTQKOvfiYupp8voFAwkt5qkXnHPjNd5Pjdmi0LJSWaDozqZicSaT
         l/r7A/qYqLZjUk6hImeg/K8ci1TfGvwNuUawYDX+D20Iag3R/sW311uAEd4GcGqxhbec
         tFvv0asJJLarbBMLrcbh7awwkFl7Uu7GX66/B+y6R+jaWwWpua8YltXlUHWyGLHlfBZC
         6UaQ==
X-Gm-Message-State: AOAM530CKGeS3mg2YgYXJlYuuyvh3yC4yc9N9SsLX8hnGIsDRy4NjZbz
        kmpL2kzTXHUVxeDX1hbhgJxnCA==
X-Google-Smtp-Source: ABdhPJz2ZihNKVaQTcw8L30+QB9S0lcU2ayc1arLlc7WCpfR7gcfQURqStw7mlIv4UvxTdGz2s3z4Q==
X-Received: by 2002:a05:6602:2c45:: with SMTP id x5mr17431038iov.80.1589873094884;
        Tue, 19 May 2020 00:24:54 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id n25sm4689058ioa.29.2020.05.19.00.24.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 May 2020 00:24:54 -0700 (PDT)
Date:   Tue, 19 May 2020 07:24:52 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Jann Horn <jannh@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Tycho Andersen <tycho@tycho.ws>,
        Matt Denton <mpdenton@google.com>,
        Chris Palmer <palmer@google.com>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: seccomp feature development
Message-ID: <20200519072451.GA3128@ircssh-2.c.rugged-nimbus-611.internal>
References: <202005181120.971232B7B@keescook>
 <CAG48ez1LrQvR2RHD5-ZCEihL4YT1tVgoAJfGYo+M3QukumX=OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1LrQvR2RHD5-ZCEihL4YT1tVgoAJfGYo+M3QukumX=OQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, May 19, 2020 at 12:39:39AM +0200, Jann Horn wrote:
> > For user_notif, I think we need something in and around these options:
> >
> > - make a new API that explicitly follows EA struct design
> >   (and while read()/write() might be easier[4], I tend to agree with
> >   Jann and we need to stick to ioctl(): as Tycho noted, "read/write is
> >   for data". Though I wonder if read() could be used for the notifications,
> >   which ARE data, and use ioctl() for the responses?)
> 
> Just as a note: If we use read() there, we'll never be able to
> transfer things like FDs through that API.
> 
Although there is no good reason for read being able to receive FDs, there is
precedence for recvmsg being able to do this. Either way, I do not think
it's a good idea to recv file descriptors, and instead file descriptors
should be fetched via the pidfd_getfd syscall.

Injection is more complicated, and for now, I believe that "writes" should
be done via ioctl, or in the future, something like sendmsg might work.
