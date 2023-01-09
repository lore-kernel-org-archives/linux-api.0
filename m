Return-Path: <linux-api-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB04C54EBD
	for <linux-api@archiver.kernel.org>; Mon,  9 Jan 2023 09:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbjAIJ1x (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 9 Jan 2023 04:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbjAIJ1H (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 9 Jan 2023 04:27:07 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31A610F5;
        Mon,  9 Jan 2023 01:26:56 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Nr7n55SP2z689JV;
        Mon,  9 Jan 2023 17:24:25 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 9 Jan 2023 09:26:53 +0000
Message-ID: <af0d7337-3a92-5eca-7d7c-cc09d5713589@huawei.com>
Date:   Mon, 9 Jan 2023 12:26:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 07/12] landlock: Add network rules support
Content-Language: ru
To:     Dan Carpenter <error27@gmail.com>
CC:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        <linux-sparse@vger.kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <artem.kuzin@huawei.com>, Linux API <linux-api@vger.kernel.org>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-8-konstantin.meskhidze@huawei.com>
 <49391484-7401-e7c7-d909-3bd6bd024731@digikod.net>
 <9a6ea6ac-525d-e058-5867-0794a99b19a3@huawei.com>
 <47fedda8-a13c-b62f-251f-b62508964bb0@digikod.net>
 <4aa29433-e7f9-f225-5bdf-c80638c936e8@huawei.com> <Y7vXSAGHf08p2Zbm@kadam>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <Y7vXSAGHf08p2Zbm@kadam>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org



1/9/2023 11:58 AM, Dan Carpenter пишет:
> These warnings seem like something I have seen before.  Maybe it was an
> issue with _Generic() support?
> 
> Are you really sure you're running the latest git version of Sparse?
> 
> I tested this patch with the latest version of Sparse on my system and
> it worked fine.

  Hi Dan,

  git is on the master branch now - hash ce1a6720 (dated 27 June 2022)

  Is this correct version?

  regards,
  Konstantin.
> 
> regards,
> dan carpenter
> 
> .
