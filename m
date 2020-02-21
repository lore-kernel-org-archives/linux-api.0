Return-Path: <SRS0=ftGk=4J=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5820CC35646
	for <linux-api@archiver.kernel.org>; Fri, 21 Feb 2020 15:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23059206EF
	for <linux-api@archiver.kernel.org>; Fri, 21 Feb 2020 15:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgBUPKD (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 21 Feb 2020 10:10:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55816 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgBUPKD (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 21 Feb 2020 10:10:03 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j59wC-0007rr-E0; Fri, 21 Feb 2020 15:09:56 +0000
Date:   Fri, 21 Feb 2020 16:09:52 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     David Howells <dhowells@redhat.com>
Cc:     viro@zeniv.linux.org.uk, raven@themaw.net, mszeredi@redhat.com,
        christian@brauner.io, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/19] vfs: Allow fsinfo() to look up a mount object by
 ID [ver #16]
Message-ID: <20200221150952.pcmlift3uapisdvz@wittgenstein>
References: <158204549488.3299825.3783690177353088425.stgit@warthog.procyon.org.uk>
 <158204554334.3299825.5795356452329641891.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <158204554334.3299825.5795356452329641891.stgit@warthog.procyon.org.uk>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Feb 18, 2020 at 05:05:43PM +0000, David Howells wrote:
> Allow the fsinfo() syscall to look up a mount object by ID rather than by
> pathname.  This is necessary as there can be multiple mounts stacked up at
> the same pathname and there's no way to look through them otherwise.
> 
> This is done by passing FSINFO_FLAGS_QUERY_MOUNT to fsinfo() in the
> parameters and then passing the mount ID as a string to fsinfo() in place
> of the filename:
> 
> 	struct fsinfo_params params = {
> 		.flags	 = FSINFO_FLAGS_QUERY_MOUNT,
> 		.request = FSINFO_ATTR_IDS,
> 	};
> 
> 	ret = fsinfo(AT_FDCWD, "21", &params, buffer, sizeof(buffer));
> 
> The caller is only permitted to query a mount object if the root directory
> of that mount connects directly to the current chroot if dfd == AT_FDCWD[*]
> or the directory specified by dfd otherwise.  Note that this is not
> available to the pathwalk of any other syscall.
> 
> [*] This needs to be something other than AT_FDCWD, perhaps AT_FDROOT.

Sounds like it should accept LOOKUP_BENEATH.
