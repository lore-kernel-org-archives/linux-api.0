Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9973C4332F
	for <linux-api@archiver.kernel.org>; Mon, 25 Apr 2022 20:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiDYUf6 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245538AbiDYUf5 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 25 Apr 2022 16:35:57 -0400
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9ABE110F3A7;
        Mon, 25 Apr 2022 13:32:51 -0700 (PDT)
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 05C0172C8DC;
        Mon, 25 Apr 2022 23:32:50 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id E672E7CE7A3; Mon, 25 Apr 2022 23:32:49 +0300 (MSK)
Date:   Mon, 25 Apr 2022 23:32:49 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Charan Teja Reddy <charante@codeaurora.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Nadav Amit <namit@vmware.com>,
        Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        zhangyi <yi.zhang@huawei.com>, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 2/6] userfaultfd: add /dev/userfaultfd for fine
 grained access control
Message-ID: <20220425203249.GA5814@altlinux.org>
References: <20220422212945.2227722-1-axelrasmussen@google.com>
 <20220422212945.2227722-3-axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422212945.2227722-3-axelrasmussen@google.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Apr 22, 2022 at 02:29:41PM -0700, Axel Rasmussen wrote:
[...]
> --- a/include/uapi/linux/userfaultfd.h
> +++ b/include/uapi/linux/userfaultfd.h
> @@ -12,6 +12,10 @@
>  
>  #include <linux/types.h>
>  
> +/* ioctls for /dev/userfaultfd */
> +#define USERFAULTFD_IOC 0xAA
> +#define USERFAULTFD_IOC_NEW _IOWR(USERFAULTFD_IOC, 0x00, int)

Why this new ioctl is defined using _IOWR()?  Since it neither reads from
user memory nor writes into user memory, it should rather be defined using
_IO(), shouldn't it?


-- 
ldv
