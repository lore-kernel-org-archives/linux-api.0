Return-Path: <SRS0=znaD=7P=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEAAC433DF
	for <linux-api@archiver.kernel.org>; Tue,  2 Jun 2020 23:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7862620663
	for <linux-api@archiver.kernel.org>; Tue,  2 Jun 2020 23:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgFBXhy (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 2 Jun 2020 19:37:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54659 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbgFBXhx (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 2 Jun 2020 19:37:53 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jgGTe-000281-Ps; Tue, 02 Jun 2020 23:37:50 +0000
Date:   Wed, 3 Jun 2020 01:37:49 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Kyle Evans <self@kyle-evans.net>,
        Victor Stinner <victor.stinner@gmail.com>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, fweimer@redhat.com, jannh@google.com,
        oleg@redhat.com, arnd@arndb.de, shuah@kernel.org,
        dhowells@redhat.com, ldv@altlinux.org
Subject: Re: [PATCH v5 1/3] open: add close_range()
Message-ID: <20200602233749.mo65o2enokiypwiz@wittgenstein>
References: <20200602204219.186620-1-christian.brauner@ubuntu.com>
 <20200602204219.186620-2-christian.brauner@ubuntu.com>
 <87d06hdozy.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87d06hdozy.fsf@mid.deneb.enyo.de>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Jun 03, 2020 at 01:30:57AM +0200, Florian Weimer wrote:
> * Christian Brauner:
> 
> > The performance is striking. For good measure, comparing the following
> > simple close_all_fds() userspace implementation that is essentially just
> > glibc's version in [6]:
> >
> > static int close_all_fds(void)
> > {
> >         int dir_fd;
> >         DIR *dir;
> >         struct dirent *direntp;
> >
> >         dir = opendir("/proc/self/fd");
> >         if (!dir)
> >                 return -1;
> >         dir_fd = dirfd(dir);
> >         while ((direntp = readdir(dir))) {
> >                 int fd;
> >                 if (strcmp(direntp->d_name, ".") == 0)
> >                         continue;
> >                 if (strcmp(direntp->d_name, "..") == 0)
> >                         continue;
> >                 fd = atoi(direntp->d_name);
> >                 if (fd == dir_fd || fd == 0 || fd == 1 || fd == 2)
> >                         continue;
> >                 close(fd);
> >         }
> >         closedir(dir);
> >         return 0;
> > }
> >
> 
> > [6]: https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/grantpt.c;h=2030e07fa6e652aac32c775b8c6e005844c3c4eb;hb=HEAD#l17
> >      Note that this is an internal implementation that is not exported.
> >      Currently, libc seems to not provide an exported version of this
> >      because of missing kernel support to do this.
> 
> Just to be clear, this code is not compiled into glibc anymore in
> typical configurations.  I have posted a patch to turn grantpt into a
> no-op: <https://sourceware.org/pipermail/libc-alpha/2020-May/114379.html>

That's great! (I remember commenting on that thread.)
