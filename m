Return-Path: <SRS0=XSN6=4Q=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A9AC3F2D2
	for <linux-api@archiver.kernel.org>; Fri, 28 Feb 2020 14:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97980246A0
	for <linux-api@archiver.kernel.org>; Fri, 28 Feb 2020 14:53:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KVRYulOk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgB1Oxo (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 28 Feb 2020 09:53:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26656 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726899AbgB1Oxo (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 28 Feb 2020 09:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582901623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Me2iAT/yAJmgAK/C/Xnwh9cHR9F8E6hzn8OdATiSink=;
        b=KVRYulOkROYFYtViTRJ/1CQ/++LN3YarXx6SSeqzMOfI8WyJm0nKH7sofLqH5x5vDFEzou
        L6JFseCLFko/vJLyltMpKWftmUhWi2Z+BzT26mff6E0Dh8cHyUtyu4hTJxNmHoR88cOR25
        9LhYkZ9LAXUezRp4ebtGarWR/B1voVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-_ZDKfHEGNxaTGc1nay5_ZA-1; Fri, 28 Feb 2020 09:53:36 -0500
X-MC-Unique: _ZDKfHEGNxaTGc1nay5_ZA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3E8813E5;
        Fri, 28 Feb 2020 14:53:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-182.rdu2.redhat.com [10.10.120.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22CD590CC8;
        Fri, 28 Feb 2020 14:53:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     linux-api@vger.kernel.org
cc:     dhowells@redhat.com, viro@zeniv.linux.org.uk, metze@samba.org,
        torvalds@linux-foundation.org, cyphar@cyphar.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Have RESOLVE_* flags superseded AT_* flags for new syscalls?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <96562.1582901612.1@warthog.procyon.org.uk>
Date:   Fri, 28 Feb 2020 14:53:32 +0000
Message-ID: <96563.1582901612@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

	
I've been told that RESOLVE_* flags, which can be found in linux/openat2.h,
should be used instead of the equivalent AT_* flags for new system calls.  Is
this the case?

If so, should we comment them as being deprecated in the header file?  And
should they be in linux/fcntl.h rather than linux/openat2.h?

Also:

 (*) It should be noted that the RESOLVE_* flags are not a superset of the
     AT_* flags (there's no equivalent of AT_NO_AUTOMOUNT for example).

 (*) It has been suggested that AT_SYMLINK_NOFOLLOW should be the default, but
     only RESOLVE_NO_SYMLINKS exists.

David

