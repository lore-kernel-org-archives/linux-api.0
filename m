Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA52C4338F
	for <linux-api@archiver.kernel.org>; Thu,  5 Aug 2021 15:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46D4460F35
	for <linux-api@archiver.kernel.org>; Thu,  5 Aug 2021 15:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241237AbhHEPcV (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:32:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237114AbhHEPcM (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 5 Aug 2021 11:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628177517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XV4AF0UpnLmBc+Fh+YmTYjMPTRS2XET0QYrYDq9QVQ4=;
        b=RFpcSCcAThZSTA3NuSmPdl5Lo2EwzqDhlWQ70D8c+d9raFR1rbnsc1GNb0sPqjqT7V/jmO
        WRJCcJJOh3lAkZJ3HnaYZnbYVCpp4bKwhO6zvlW9KZnPYFjTT0a3h3B8Dy4ch2KTR7C4KB
        WIBdwObzufb5PZx5VAl1scnJLTCOKTY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-Y5Uj87ORN-aNLpueTvx6Ug-1; Thu, 05 Aug 2021 11:31:56 -0400
X-MC-Unique: Y5Uj87ORN-aNLpueTvx6Ug-1
Received: by mail-wm1-f72.google.com with SMTP id f142-20020a1c1f940000b029025093cddc1eso3044642wmf.3
        for <linux-api@vger.kernel.org>; Thu, 05 Aug 2021 08:31:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XV4AF0UpnLmBc+Fh+YmTYjMPTRS2XET0QYrYDq9QVQ4=;
        b=Il30aOnKfJBBbkM5qPXsGb/Lw7ZEs+i/2bxFIsQf9x8tMBb/A4PEDmuE8dt2OrM83L
         WBfwr8gPMNio8luELs0z9F7aQ3EDR+EoxNd+NoZ0s2tS6cr2ebEfK5oMqySJVyx1T3Q/
         LqQObyC3d3fqfDvM9oMNdjJEXO8r9+Zc3R9ygy+Okwvx+aa+lWPpiDQqYJ5RB2dBusvH
         4D71SGXVU2hXFtkcPlaLToaiG29SiK8A2BEUhRgEVs/gZuZbAlFWt5A5r5VVBRI5fZAP
         sYzYDN/AhG8oHQ1427n3UunuH+sCwzlid0GM5F3LC8Gfljs7oXrZPaS1ySGNCHuChvVV
         YzRg==
X-Gm-Message-State: AOAM533uLij7fdVfmWLOsl++xY6IGtwGT9d0khfB+RWLzaRWad1YKFtH
        823qF7PqSOh6/x+VbvZ7z6TqqFrxPfKPOgp25AQ8KYfHoMikQOJJizRiP+trRKeB65FABHKSJBf
        sxC1zYgTwbYEO8eEi2a2Y
X-Received: by 2002:a5d:6b8f:: with SMTP id n15mr5843736wrx.103.1628177514817;
        Thu, 05 Aug 2021 08:31:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzL+c7DSbQHjkb0FtmxNUduwf5gjcrc+ZMVTSumUYHvO7/lb4YldM6LsmAOL1KmYiFk9LQcfA==
X-Received: by 2002:a5d:6b8f:: with SMTP id n15mr5843709wrx.103.1628177514670;
        Thu, 05 Aug 2021 08:31:54 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c630b.dip0.t-ipconnect.de. [91.12.99.11])
        by smtp.gmail.com with ESMTPSA id h4sm6824700wru.2.2021.08.05.08.31.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 08:31:54 -0700 (PDT)
Subject: Re: [PATCH v6 1/2] mm: introduce process_mrelease system call
To:     Suren Baghdasaryan <surenb@google.com>,
        Michal Hocko <mhocko@suse.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>, Rik van Riel <riel@surriel.com>,
        Minchan Kim <minchan@kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Christoph Hellwig <hch@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Florian Weimer <fweimer@redhat.com>,
        Jan Engelhardt <jengelh@inai.de>,
        Tim Murray <timmurray@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>
References: <20210804185004.1304692-1-surenb@google.com>
 <YQuO36AeQUwsAyU1@dhcp22.suse.cz>
 <CAJuCfpF1JSTSRu5v8s9wG0J-S+-p57tMO+0dUF+P16_6yYV7Mg@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <c67c89a2-02b3-a226-97ae-897f704b337e@redhat.com>
Date:   Thu, 5 Aug 2021 17:31:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAJuCfpF1JSTSRu5v8s9wG0J-S+-p57tMO+0dUF+P16_6yYV7Mg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

> 
> I see. Let me update the patch and will ask Andrew to remove the
> previous version from mm tree.

No need to ask. Just resend and Andrew will (usually) replace the old 
version automatically :)


-- 
Thanks,

David / dhildenb

