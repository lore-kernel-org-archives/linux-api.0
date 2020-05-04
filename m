Return-Path: <SRS0=k0wc=6S=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E98C3A5A9
	for <linux-api@archiver.kernel.org>; Mon,  4 May 2020 16:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B8D120705
	for <linux-api@archiver.kernel.org>; Mon,  4 May 2020 16:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgEDQ2n (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 4 May 2020 12:28:43 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:33518 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbgEDQ2n (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 4 May 2020 12:28:43 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jVdxR-0002Ya-MZ; Mon, 04 May 2020 10:28:41 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jVdxF-0002fk-2W; Mon, 04 May 2020 10:28:41 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge@hallyn.com>, Jann Horn <jannh@google.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Aleksa Sarai <cyphar@cyphar.com>, linux-api@vger.kernel.org
References: <20200504144141.3605533-1-christian.brauner@ubuntu.com>
        <20200504144141.3605533-3-christian.brauner@ubuntu.com>
Date:   Mon, 04 May 2020 11:25:07 -0500
In-Reply-To: <20200504144141.3605533-3-christian.brauner@ubuntu.com>
        (Christian Brauner's message of "Mon, 4 May 2020 16:41:40 +0200")
Message-ID: <87h7wvoefw.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jVdxF-0002fk-2W;;;mid=<87h7wvoefw.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19fC77YDZ/s6OgFRdJGwh3qJWiJoBgKLuI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v3 2/3] nsproxy: attach to namespaces via pidfds
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


I am not thrilled about treating nstype as a flags fields when it is not
currently.  It was my hope when I designed the interface that not
treating nstype as a flags field would save us from the problem of bits
running out.

That aside.  It would be very good if the default version of setting
everything from a pidfd would set the root directory from the process it
is copying everything else from.

Eric
