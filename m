Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6389C4338F
	for <linux-api@archiver.kernel.org>; Fri, 23 Jul 2021 02:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81E4E60EBF
	for <linux-api@archiver.kernel.org>; Fri, 23 Jul 2021 02:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhGWBXh (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 22 Jul 2021 21:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbhGWBXf (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 22 Jul 2021 21:23:35 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27827C061757
        for <linux-api@vger.kernel.org>; Thu, 22 Jul 2021 19:04:09 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id f30so11508052lfj.1
        for <linux-api@vger.kernel.org>; Thu, 22 Jul 2021 19:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uWU9VPUi87pNrXCcR4PCrzd/Kzrus891hORmT5PC+zM=;
        b=eGNdTCrx6valxUE5ycbThNR4R02XvSCraZrOHIJQ3+uqYxLGjXSsd22UWXr8N8UOPD
         pTfRBCs/s/EKxTP63S4eW3pg+ooV0Y0g5l6l2r6t0UIosBihxBzwuMctSG+1emfQCfSE
         px9lck/vGt9WgFrHHUB99tl86i/uxoPbCAIgVSVpr/+N6v6cSOq37fum8aRsrqO7ACZJ
         nTK2PdPZtydq9eYLRimByBEr+6baMS+91ckZZ/T+wduT5gQD9zre78+/Eu79TJsACHbw
         ct2HMQmLl83gfQCVoDTYqZOIgZfE8fsaRlcVKLmHNhSi+3LRiz9+fY4hm+TfpU8IS/Kw
         5qpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uWU9VPUi87pNrXCcR4PCrzd/Kzrus891hORmT5PC+zM=;
        b=P19Q8BAtehB6yrZLYg1lpuN2gvJDgmVNv74xBg3XlXbHUoKg6dP7vadBHzF/DsMJ8v
         3kkq1n6jWq3AQDXnA0lt8HOtV+yXs2SbDsQjdXNWYYgdRuI4nNbHVhh0UEKBz9V9tVje
         jV8fN51gVBNlIW8cs1+cpw78Yj1jZS1byF3aS1Dvj86IozGY3yQLDmgj/5Fguv9s/bsW
         59wISkNF/jdwnfSk0wFR9kkUAg2pJdjoVtSsh22Px+rBaHN5L7vDHM8F3UZZFS5dOGiB
         BYdKm6sGa5O4BmDLbS/Igg9TdzeJpSOvlwvhSlbgoiQvhposSpfvipQnnzlsI+7/svet
         P8Zg==
X-Gm-Message-State: AOAM530yOrN7dOGD+xom6sJr7eOSb9HR4nds40rL0GvOtaIGlJfjxmmf
        YXv6ic9g+r34GO42247cA5dp289/d76e/qJIowVd6Q==
X-Google-Smtp-Source: ABdhPJyBmT6ZL/CfKLSg3rGD/pmyxU4+PR/Rv/FDU5r/DAMR4iBuE7Qg4ScYmuWcXBXaW8hLAfCfxGHev47wUrR2oFI=
X-Received: by 2002:a19:e053:: with SMTP id g19mr1426820lfj.83.1627005847018;
 Thu, 22 Jul 2021 19:04:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210723011436.60960-1-surenb@google.com>
In-Reply-To: <20210723011436.60960-1-surenb@google.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 22 Jul 2021 19:03:56 -0700
Message-ID: <CALvZod7ehaHoWRD-Pzvet5c1LQ6DYDHjs=xbJWZYEdMsgTpRgA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm: introduce process_mrelease system call
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>, Rik van Riel <riel@surriel.com>,
        Minchan Kim <minchan@kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Christoph Hellwig <hch@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Florian Weimer <fweimer@redhat.com>, jengelh@inai.de,
        Tim Murray <timmurray@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Jul 22, 2021 at 6:14 PM Suren Baghdasaryan <surenb@google.com> wrote:
>
[...]
> +
> +       mmap_read_lock(mm);

How about mmap_read_trylock(mm) and return -EAGAIN on failure?


> +       if (!__oom_reap_task_mm(mm))
> +               ret = -EAGAIN;
> +       mmap_read_unlock(mm);
> +
