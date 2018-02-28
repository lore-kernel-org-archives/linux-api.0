From: Pavel Emelyanov <xemul@virtuozzo.com>
Subject: Re: [PATCH 3/3] userfaultfd: non-cooperative: allow synchronous
 EVENT_REMOVE
Date: Wed, 28 Feb 2018 11:21:02 +0300
Message-ID: <1a2ed216-74ac-5fe2-abff-21d670eeb96d@virtuozzo.com>
References: <1519719592-22668-1-git-send-email-rppt@linux.vnet.ibm.com>
 <1519719592-22668-4-git-send-email-rppt@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519719592-22668-4-git-send-email-rppt@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-api <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, crml <criu@openvz.org>
List-Id: linux-api@vger.kernel.org


> @@ -52,6 +53,7 @@
>  #define _UFFDIO_WAKE			(0x02)
>  #define _UFFDIO_COPY			(0x03)
>  #define _UFFDIO_ZEROPAGE		(0x04)
> +#define _UFFDIO_WAKE_SYNC_EVENT		(0x05)

Excuse my ignorance, but what's the difference between UFFDIO_WAKE and UFFDIO_WAKE_SYNC_EVENT?

-- Pavel
