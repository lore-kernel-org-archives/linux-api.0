Return-Path: <SRS0=wisl=44=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C88D6C10DCE
	for <linux-api@archiver.kernel.org>; Wed, 11 Mar 2020 00:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8661F215A4
	for <linux-api@archiver.kernel.org>; Wed, 11 Mar 2020 00:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583887376;
	bh=p6sORrfT1V0PaoGW/6AwSQMJqP8nSuPuvQgcEOAt+n0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=JaBOcsTI9gxi/yajSjKgd5ia3Uqo8N0IOfc9WZrUV43IrCwipGoRtp2ZEkEr/1vjf
	 QUeEG+d9zdjTEHu+nxXQjVMPIaoXBkKG1Ow0BQrSA8PVnUCetk+ljbiv4sMv9awIdW
	 Xm/IEPFGEMwyT0nLnh+k2GcKhOdG1lhwrfPcJMbE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgCKAm4 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:42:56 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37821 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgCKAmz (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 10 Mar 2020 20:42:55 -0400
Received: by mail-pj1-f66.google.com with SMTP id ca13so86065pjb.2;
        Tue, 10 Mar 2020 17:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gHHd1XziN8r2/wEQeuyvT+MVwzlvctKNbvynCtX7SU4=;
        b=ilfxLzPMly8T61Cp2sCcvvVUuTptmdD9og/HClPYWlqrJKAVePF962agnyALlTmHTi
         +VDTAn03M2plBXxTMGd0eqr3c+MDYEgIABqfisrJGsmUo9mgpn4/yvMWA4ENpk2XbjUV
         ObIgwgnJfYdBOaFVztTIwvbd7rJLfMx8wBnUgX1q7AtgcePddjcslyG31+Xngh8Uw6iA
         GwB6zT+0ZwYzbglEm3MdWfioBxkS/fSnVQbnUlqboo8TQsOjAmRsaFhxdNjR5LJR5ArI
         tT1KL62/OzUAXjy1VqMLMkdVf2cLvkUZqhUt0GcwU3JsgR7QEJgNvVW2e8BkUkFh6DwP
         ktOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=gHHd1XziN8r2/wEQeuyvT+MVwzlvctKNbvynCtX7SU4=;
        b=X7Frxpy7sGh6/e/vzRUa4y1LKonC2xvPSVwg0tIRw+5Zrswa47pedJVns+4tdq3wa7
         cNMqEJLqJEQApNgVT/EgOPUHmj0zjwkz0Q9M30fQy24QaEHH5AboEuRbodVwswlBhsDo
         njKrI3dWmPFKd2SaIJBl82VDaG7cMtIFY2Ey1jc/Q/5vqpDA2hcihPR+6jtCWPjcSx4X
         FEIKn2fxqoshpR4F+8LVvlCU3Mc42lrNRt9REiAKdpGzftHeTrv0jRAcdhXnAQckM7p3
         hxlluVeP1fSlgSpAGjC7UmJ/ylqKyT/XqSHIXJBctv3amU/3gftPrQ22pu5gq7OvfxOd
         dKUQ==
X-Gm-Message-State: ANhLgQ2Ap91Rul5Q/YIsKBzBmYodqHqs1RFbd22lvZ892hFa5Ats5Zj8
        pvnht/6OtCy1phpVEb3GKeM=
X-Google-Smtp-Source: ADFU+vtkqg5VizyxXJML/iGAsxbuKOdG2Pz7RWPAabfqCEVfSKSq8AotbODi3m8GStFforD7SxWgAg==
X-Received: by 2002:a17:90a:c482:: with SMTP id j2mr609701pjt.71.1583887374578;
        Tue, 10 Mar 2020 17:42:54 -0700 (PDT)
Received: from google.com ([2620:15c:211:1:3e01:2939:5992:52da])
        by smtp.gmail.com with ESMTPSA id i2sm12018641pfr.151.2020.03.10.17.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 17:42:53 -0700 (PDT)
Date:   Tue, 10 Mar 2020 17:42:51 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org,
        oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>,
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
        Christian Brauner <christian@brauner.io>,
        Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: Re: [PATCH v7 5/7] mm: support both pid and pidfd for process_madvise
Message-ID: <20200311004251.GB87930@google.com>
References: <20200302193630.68771-1-minchan@kernel.org>
 <20200302193630.68771-6-minchan@kernel.org>
 <14089609-5fb1-b082-716f-c2e129d27c48@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14089609-5fb1-b082-716f-c2e129d27c48@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Mar 06, 2020 at 12:14:19PM +0100, Vlastimil Babka wrote:
> On 3/2/20 8:36 PM, Minchan Kim wrote:
> > There is a demand[1] to support pid as well pidfd for process_madvise
> > to reduce unnecessary syscall to get pidfd if the user has control of
> > the target process(ie, they could guarantee the process is not gone
> > or pid is not reused).
> > 
> > This patch aims for supporting both options like waitid(2). So, the
> > syscall is currently,
> > 
> > 	int process_madvise(int which, pid_t pid, void *addr,
> > 		size_t length, int advise, unsigned long flag);
> 
> This is again halfway between kernel and userspace description, so if we stick
> to userspace then it's:
> 
>  	int process_madvise(idtype_t idtype, id_t id, void *addr,
>  		size_t length, int advice, unsigned long flags);

Yub.

> 
> 
> > @which is actually idtype_t for userspace libray and currently,
> > it supports P_PID and P_PIDFD.
> > 
> > [1]  https://lore.kernel.org/linux-mm/9d849087-3359-c4ab-fbec-859e8186c509@virtuozzo.com/
> > 
> > Cc: Christian Brauner <christian@brauner.io>
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > Suggested-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!
