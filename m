Return-Path: <SRS0=3WA1=AR=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A71C433E1
	for <linux-api@archiver.kernel.org>; Mon,  6 Jul 2020 20:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7239D206B6
	for <linux-api@archiver.kernel.org>; Mon,  6 Jul 2020 20:18:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IvslQ3GM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgGFUSC (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 6 Jul 2020 16:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgGFURc (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 6 Jul 2020 16:17:32 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B81C08C5FA
        for <linux-api@vger.kernel.org>; Mon,  6 Jul 2020 13:17:31 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mn17so3952706pjb.4
        for <linux-api@vger.kernel.org>; Mon, 06 Jul 2020 13:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0YvuOzcxzi1qx3Yg3gRUHTduA+Ml0/K1N0wS3w5e3M0=;
        b=IvslQ3GMETRVSlyR7uc2XGWdBRUDaHp8nLhukngoHUIUAlk+nolLb0psQdSMbbROgq
         nKWfK2kmOhnxZdKEiK6gu1Dt47URHz8L0MbxvTOaHrQljhqxSVKxn/Vw6P0YWh6AlO9B
         p31Jpeqxl9GTTzWyqJiyHW6Wuv5CjPr9a6uQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0YvuOzcxzi1qx3Yg3gRUHTduA+Ml0/K1N0wS3w5e3M0=;
        b=ujBJOwOVfCX2tC5psq5U1JmBRelkdHaPp3mDtghUIE8QB/L/JdNdmxKfITWT7R06ee
         VK+vpswJz9cySQ4Ayqt6Yuoku33hBaKw3G0l/PJa51JqlknVqqTmxd5Q8/O4dgrL8N+n
         zGCkCATTd3mxkucZdTwQGxZZtHfMzwMWlHmk4QYIpHWP+uFPOQ6HUW5o3/Okks0nXkfw
         S2uyrai4lNOomI2K9b1XamTXQZMU3hywYbkg6GyXHXBbMiTYWGxB5M1m3nN3Cq1+gUWi
         L6tDOy9cY9xUEwHbsYUVwyWpY1X1QrBXbXy+6bmKwLFpLQ9DNVaP7RMNgrm0ReDSJ9tD
         mcrg==
X-Gm-Message-State: AOAM531Mg8CEACHxjQ/irFiVa3BbYdvAIdguxDqbvshZ6IELvKi0D8pk
        cVtLZjdaM81Ka9Tw1jQBsLa4XA==
X-Google-Smtp-Source: ABdhPJxcSeJ1fTMDQCDnUvgThUlNKIXnFBIxsUbi4LO/x7QgRdeVuEatuUoL/8p2qQmbyllSb6Lydw==
X-Received: by 2002:a17:90b:3612:: with SMTP id ml18mr801484pjb.193.1594066651340;
        Mon, 06 Jul 2020 13:17:31 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i21sm4498542pfa.18.2020.07.06.13.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 13:17:27 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v6 4/7] pidfd: Replace open-coded partial receive_fd()
Date:   Mon,  6 Jul 2020 13:17:17 -0700
Message-Id: <20200706201720.3482959-5-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706201720.3482959-1-keescook@chromium.org>
References: <20200706201720.3482959-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

The sock counting (sock_update_netprioidx() and sock_update_classid()) was
missing from pidfd's implementation of received fd installation. Replace
the open-coded version with a call to the new receive_fd()
helper.

Thanks to Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com> for
catching a missed fput() in an earlier version of this patch.

Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
Reviewed-by: Sargun Dhillon <sargun@sargun.me>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/pid.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index f1496b757162..a31c102f4c87 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -635,17 +635,8 @@ static int pidfd_getfd(struct pid *pid, int fd)
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-	ret = security_file_receive(file);
-	if (ret) {
-		fput(file);
-		return ret;
-	}
-
-	ret = get_unused_fd_flags(O_CLOEXEC);
-	if (ret < 0)
-		fput(file);
-	else
-		fd_install(ret, file);
+	ret = receive_fd(file, O_CLOEXEC);
+	fput(file);
 
 	return ret;
 }
-- 
2.25.1

