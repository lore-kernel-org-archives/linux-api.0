Return-Path: <SRS0=QVgP=BA=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B379CC433E0
	for <linux-api@archiver.kernel.org>; Tue, 21 Jul 2020 16:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8955420684
	for <linux-api@archiver.kernel.org>; Tue, 21 Jul 2020 16:30:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="guiWR2T7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgGUQ2Y (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbgGUQ2Y (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 21 Jul 2020 12:28:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E194C061794;
        Tue, 21 Jul 2020 09:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=a+vDF8klKlLTFVbzGxgCmq6Vs3NgcEzh4gR2/6Zjx5g=; b=guiWR2T7PBVPkbvAVhOr60Kvui
        l2UXKw673ergZoSXKNmfQjKRjogJ/g01Lq893KzeYPeIXVw8vB8SaUgZdeHZgCR326mY81MveE68A
        muGTOv3y41ZQmAk57Zc7e1HqC6j/WVhTnLq8rGmnGk16dhl5tmUfid1+ZrsEENi5+wTa/Xb45qcfO
        9MaqUzoQK9tKcHjbdVKdiNUxSVSGM2DQFu8gJNrpnUdPm2727HsYJRov1ySZx1wo7D17J91XFhBZI
        wiBxwqywcetwumgrPiWWXNc4IRHPstS7KoNaOtYFovlhevHrGk9XTvtCOMr+urpmJoDBg8qQ1JMhm
        CTP8NzZQ==;
Received: from [2001:4bb8:18c:2acc:5b1c:6483:bd6d:e406] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxv7r-0007Qq-67; Tue, 21 Jul 2020 16:28:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Subject: add file system helpers that take kernel pointers for the init code v2
Date:   Tue, 21 Jul 2020 18:27:54 +0200
Message-Id: <20200721162818.197315-1-hch@lst.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi Al and Linus,

currently a lot of the file system calls in the early in code (and the
devtmpfs kthread) rely on the implicit set_fs(KERNEL_DS) during boot.
This is one of the few last remaining places we need to deal with to kill
off set_fs entirely, so this series adds new helpers that take kernel
pointers.  These helpers are in init/ and marked __init and thus will
be discarded after bootup.  A few also need to be duplicated in devtmpfs,
though unfortunately.

The series sits on top of my previous

  "decruft the early init / initrd / initramfs code v2"

series.


Git tree:

    git://git.infradead.org/users/hch/misc.git init_path

Gitweb:

    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/init_path


Changes since v1:
 - avoid most core VFS changes
 - renamed the functions and move them to init/ and devtmpfs
 - drop a bunch of cleanups that can be submitted independently now


Diffstat:
