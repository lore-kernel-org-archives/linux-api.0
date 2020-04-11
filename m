Return-Path: <SRS0=TTuq=53=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796D1C2BA2B
	for <linux-api@archiver.kernel.org>; Sat, 11 Apr 2020 10:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42FCC2137B
	for <linux-api@archiver.kernel.org>; Sat, 11 Apr 2020 10:36:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PCoEa7nE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgDKKgh (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 11 Apr 2020 06:36:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52696 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgDKKgg (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 11 Apr 2020 06:36:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id t203so4757243wmt.2;
        Sat, 11 Apr 2020 03:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7fQkBGJzHRie+HL6ShG4uaTcEJZekhWbXu7hP3oDE58=;
        b=PCoEa7nELhNbt6cFgYmcjTW+6GiQEqQJXNnDLxUFkYjNf48Xb1ndoyZHVA+DI2csW/
         mBTeinJE2QyID/9sx5qoQWxWq8y1rnxp/BlbKKCXwTvJXEAqMbKQcu5qJhpLetUFOlka
         XywhuyyPsjuAk0erKfB+YLfYJN4iF5y5rMdjPyPynfKLB5GZyQVCnglI4vQIoy5qYefv
         zNZhp9LezmltODr0IBoN0D6/g1QH9TMIVrrMFrvtL0Ju1Yfasf4q5/HOyiUPHUTdXF4c
         F2GU4AiTe3q+skJlHexxItxHmDsZMdnXOXTC8VPX4aqnTzxVTJ1vMgyQU61geVpUzhf6
         LAuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7fQkBGJzHRie+HL6ShG4uaTcEJZekhWbXu7hP3oDE58=;
        b=QEMv++pu44TGcWMFqO17733pKLo5mSNJKTDlcJwkGV8WDWdrZCAhk4KMspLXgkM3x6
         VbK1l0s+z2SNZSYDLngR/y3dD8Hcuoi4A8H6/7pbAzgmmRP33pUZviFL8pCKX3K5ABca
         5aaKxXgH/YPDXZDHeO/ghpktejX0nRaBZwGaH9kzH73kP8piD/flbCj+q8xsK1aqKV0b
         kW6VMbboHlKVviaXxJJMM7Qdeza4b1v/qKcvq0/+73oSQUwQUWPGMQiS1DW60YwXNTDi
         8+sWdbQzkqmYMRxC7Hvqo8pi3nn33n76KzmIM5WVYvU6ZWX6nyZikUm7Ia5ROcWB2s+F
         B/OQ==
X-Gm-Message-State: AGi0PuZrJD1SAWRt1Dyy5epNkDccGf0FDKKBvTxaravWyypEsT+DaHe/
        syGU2yysMKwyJ5LvcjZx/yk=
X-Google-Smtp-Source: APiQypJFXeVsgT776Lq9yrjrwIAE7fRwFsKS3JDZ1RbD9+8CxdvPbvplYWBxu6S9o/hFG7g5dz5ZJw==
X-Received: by 2002:a7b:ce0b:: with SMTP id m11mr9566956wmc.67.1586601393941;
        Sat, 11 Apr 2020 03:36:33 -0700 (PDT)
Received: from ?IPv6:2001:a61:2482:101:3351:6160:8173:cc31? ([2001:a61:2482:101:3351:6160:8173:cc31])
        by smtp.gmail.com with ESMTPSA id c11sm6615859wrt.24.2020.04.11.03.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Apr 2020 03:36:33 -0700 (PDT)
Cc:     mtk.manpages@gmail.com, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCH] timens: show clock symbolic names in
 /proc/pid/timens_offsets
To:     Andrei Vagin <avagin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200411065209.622679-1-avagin@gmail.com>
 <afd9a489-bea7-c34c-14c2-405b536deb0d@gmail.com>
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <96bedbaf-49ea-f24b-b7b1-fb9a57fb6c7d@gmail.com>
Date:   Sat, 11 Apr 2020 12:36:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <afd9a489-bea7-c34c-14c2-405b536deb0d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

> As things stand, there is to my eye an excessive amount of white space
> in the output produced by this line:
> 
>> +	seq_printf(m, "%s\t%10lld\t%10ld\n", clock, ts->tv_sec, ts->tv_nsec);
> 
> Can I suggest instead something like:
> 
> 	seq_printf(m, "%-16s %10lld %9ld\n", clock, ts->tv_sec, ts->tv_nsec);

Actually, how about even s/-16s/-10s/ for that first field.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
