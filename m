Return-Path: <SRS0=cjBL=4T=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF389C3F2DB
	for <linux-api@archiver.kernel.org>; Mon,  2 Mar 2020 19:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9DED2080C
	for <linux-api@archiver.kernel.org>; Mon,  2 Mar 2020 19:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583177814;
	bh=1eBQvH/3HF8KwpmzdPtqPqik1R+9KP4gzVHTx2vv0/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kbsnwStaxV9cDhiyAaDHDLWXr3pqf6YTwcbVNtOdhKMRGNNYkrFV5bwiaKXIeCqyq
	 A9Zd71U2cMEOYle2+I1VvuVeJYN6uOGQ4cLuQp1/erLlt+xbHsOPev349QloS5q8yl
	 JSNF5eSdqmmvwkq0ylcfaLmFXTEld2tH0sEC5s4Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgCBTgx (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 2 Mar 2020 14:36:53 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34795 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbgCBTgx (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 2 Mar 2020 14:36:53 -0500
Received: by mail-pf1-f195.google.com with SMTP id y21so216488pfp.1;
        Mon, 02 Mar 2020 11:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xPq4MnSfZ5jWfAsPssUVfjNY8ScP1mqw+MypBd7iP+U=;
        b=oVv7S+P/QEC4IU0JDW3R6+pH/HZQedvJgo/p6dLtJbajwRcJqo63ZjdjfP6Ha5zzeg
         Yek9HPH1rVrC7+TbFuveVjZTlryEeEiAPzr/4j7HtUFDgWG36Da9obumxjlnsZrMCWSK
         OFxnXBCRtKPcKIFR9QDy+A6XD9Q/V7rFLGekAwxJb0/JVc7zqPyrU3zJfpWHPEG7kN0o
         xkoLZz3J/qCLjy8ARct6biDDVe9Le9+F1G/M9RGeDd6MmxIoeZfGDLPRH+YFha0gFu9e
         A8zPcDCOEBZYuCZ58v4eoa1lTSg+/Q0nLNDXSKylf246Yv42793BURa8ErWOkeaq+ufh
         RvXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=xPq4MnSfZ5jWfAsPssUVfjNY8ScP1mqw+MypBd7iP+U=;
        b=eisYK+yE/21SjBkdKxawulYdob4q/qc6ojKClH2GNyyk/8gVKdaGTHi0yGWnELUWao
         ZE1ng5YZySXklFQpnUyt+GEZAm8RAZrtNHgmiKZB71lFj3PCaT4Ew7VM7cESFZETwkW5
         i5V/cksAwqUNE9JOyNZZ4z8DyhxYw3SF77DZETHPwyNYkUZPJ4n3eOBL5XF1DiqKAXbC
         JjLs/p2fn5WgbVUXX/EujV9xHdvyslWk0bd6yJjgyP07zUTzjTS/5cQgV+UROSi/dd6x
         pSHjnmApPkpdTOk0uJbgX2Ceyxa4nuE+hggRFNGISCdoZC04SNVooOZDoDUujD6V9X9K
         /dKA==
X-Gm-Message-State: ANhLgQ174m7RimzwpPgUpVkIG4acLnjesA1uo8rY9mpqHjc+OkBBSiYz
        6AgSfznndRjQd24X0hDNnFM=
X-Google-Smtp-Source: ADFU+vv9CLHD6sVa3fBRa6pzZ4SBhCdu9PYfQpsoPVh3OiiLUei4gNaaBkWGAAN2cXCdFxrDXM+9Yw==
X-Received: by 2002:aa7:9497:: with SMTP id z23mr526938pfk.229.1583177811915;
        Mon, 02 Mar 2020 11:36:51 -0800 (PST)
Received: from bbox-1.mtv.corp.google.com ([2620:15c:211:1:3e01:2939:5992:52da])
        by smtp.gmail.com with ESMTPSA id hg6sm35441pjb.22.2020.03.02.11.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 11:36:50 -0800 (PST)
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linux-api@vger.kernel.org, oleksandr@redhat.com,
        Suren Baghdasaryan <surenb@google.com>,
        Tim Murray <timmurray@google.com>,
        Daniel Colascione <dancol@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Sonny Rao <sonnyrao@google.com>,
        Brian Geffon <bgeffon@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        John Dias <joaodias@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Jann Horn <jannh@google.com>,
        alexander.h.duyck@linux.intel.com, sj38.park@gmail.com,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v7 6/7] mm/madvise: employ mmget_still_valid for write lock
Date:   Mon,  2 Mar 2020 11:36:29 -0800
Message-Id: <20200302193630.68771-7-minchan@kernel.org>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
In-Reply-To: <20200302193630.68771-1-minchan@kernel.org>
References: <20200302193630.68771-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Oleksandr Natalenko <oleksandr@redhat.com>

Do the very same trick as we already do since 04f5866e41fb. KSM hints
will require locking mmap_sem for write since they modify vm_flags, so
for remote KSM hinting this additional check is needed.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/madvise.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index e794367f681e..e77c6c1fad34 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1118,6 +1118,8 @@ int do_madvise(struct task_struct *target_task, struct mm_struct *mm,
 	if (write) {
 		if (down_write_killable(&mm->mmap_sem))
 			return -EINTR;
+		if (current->mm != mm && !mmget_still_valid(mm))
+			goto skip_mm;
 	} else {
 		down_read(&mm->mmap_sem);
 	}
@@ -1169,6 +1171,7 @@ int do_madvise(struct task_struct *target_task, struct mm_struct *mm,
 	}
 out:
 	blk_finish_plug(&plug);
+skip_mm:
 	if (write)
 		up_write(&mm->mmap_sem);
 	else
-- 
2.25.0.265.gbab2e86ba0-goog

