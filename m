From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 1/9] fs: add fcntl() interface for setting/getting write
 life time hints
Date: Mon, 26 Jun 2017 07:55:27 -0600
Message-ID: <91b3fd3b-18f5-cf8c-a1d7-c0637283ce14@kernel.dk>
References: <1498004526-4543-1-git-send-email-axboe@kernel.dk>
 <1498004526-4543-2-git-send-email-axboe@kernel.dk>
 <20170626095148.GB14057@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170626095148.GB14057-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/26/2017 03:51 AM, Christoph Hellwig wrote:
> Please document the userspace API (added linux-api and linux-man
> to CC for sugestions), especially including the odd effects of the
> per-inode settings.

Of course, I'll send in a diff for the fcntl(2) man page.

> Also I would highly recommend to use different fcntl commands
> for the file vs inode hints to avoid any strange behavior.

OK, used to have that too... I can add specific _FILE versions.

-- 
Jens Axboe
