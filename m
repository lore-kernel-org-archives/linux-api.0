Return-Path: <SRS0=wpUv=BN=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CDCC433E0
	for <linux-api@archiver.kernel.org>; Mon,  3 Aug 2020 12:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12DCA2076B
	for <linux-api@archiver.kernel.org>; Mon,  3 Aug 2020 12:32:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ef+XjQPs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgHCMcB (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 Aug 2020 08:32:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47192 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729259AbgHCMcB (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 Aug 2020 08:32:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596457920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+FTqyOz+KM8b1l5RbH2zS34D2EqLt9IQI9azf1e1ydg=;
        b=Ef+XjQPsux6IyzMUGQ5kDNPTWaC2If6GYzukTnXE+Ak+eoi6GIcUkm0aGbSYHQ6hTzzd+G
        3zYjIjSIoM6K4TU/kqa95NPYTxQ+rHa6AvWm60tfzuux15pmYoeoLWW2/SrUtNPHmCy5s1
        ZI6C6whezzxVz69w7AuORtRV0fsw/hQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-YLQh1wy0P0eZHtUDK-Mg4w-1; Mon, 03 Aug 2020 08:31:58 -0400
X-MC-Unique: YLQh1wy0P0eZHtUDK-Mg4w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7D55101C8A8;
        Mon,  3 Aug 2020 12:31:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-32.rdu2.redhat.com [10.10.112.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8724E7176A;
        Mon,  3 Aug 2020 12:31:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <303106be4785135446e56cb606138a6e94885887.camel@themaw.net>
References: <303106be4785135446e56cb606138a6e94885887.camel@themaw.net> <CAJfpeguO8Qwkzx9zfGVT7W+pT5p6fgj-_8oJqJbXX_KQBpLLEQ@mail.gmail.com> <1293241.1595501326@warthog.procyon.org.uk> <CAJfpegspWA6oUtdcYvYF=3fij=Bnq03b8VMbU9RNMKc+zzjbag@mail.gmail.com> <158454378820.2863966.10496767254293183123.stgit@warthog.procyon.org.uk> <158454391302.2863966.1884682840541676280.stgit@warthog.procyon.org.uk> <2003787.1595585999@warthog.procyon.org.uk> <865566fb800a014868a9a7e36a00a14430efb11e.camel@themaw.net> <2023286.1595590563@warthog.procyon.org.uk> <CAJfpegsT_3YqHPWCZGX7Lr+sE0NVmczWz5L6cN8CzsVz4YKLCQ@mail.gmail.com> <1283475.1596449889@warthog.procyon.org.uk> <1576646.1596455376@warthog.procyon.org.uk>
To:     Ian Kent <raven@themaw.net>
Cc:     dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Christian Brauner <christian@brauner.io>, andres@anarazel.de,
        Jeff Layton <jlayton@redhat.com>, dray@redhat.com,
        Karel Zak <kzak@redhat.com>, keyrings@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        LSM <linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/17] watch_queue: Implement mount topology and attribute change notifications [ver #5]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1692825.1596457912.1@warthog.procyon.org.uk>
Date:   Mon, 03 Aug 2020 13:31:52 +0100
Message-ID: <1692826.1596457912@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Ian Kent <raven@themaw.net> wrote:

> > I'm changing it so that the fields are 64-bit, but initialised with the
> > existing mount ID in the notifications set.  The fsinfo set changes that
> > to a unique ID.  I'm tempted to make the unique IDs start at UINT_MAX+1 to
> > disambiguate them.
> 
> Mmm ... so what would I use as a mount id that's not used, like NULL
> for strings?

Zero is skipped, so you could use that.

> I'm using -1 now but changing this will mean I need something
> different.

It's 64-bits, so you're not likely to see it reach -1, even if it does start
at UINT_MAX+1.

David

