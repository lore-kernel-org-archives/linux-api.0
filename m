From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH v2 2/8] pipe: move limit checking logic into
 pipe_set_size()
Date: Thu, 29 Sep 2016 13:26:18 +0200
Message-ID: <1e7bdfb3-0772-c152-8da1-3d22b56682b3@oracle.com>
References: <ef9ce203-6683-31b1-26dc-e0b823aba73e@gmail.com>
 <3701b2c5-2c52-2c3e-226d-29b9deb29b50@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3701b2c5-2c52-2c3e-226d-29b9deb29b50@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, socketpair@gmail.com, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
List-Id: linux-api@vger.kernel.org

On 08/29/2016 02:21 AM, Michael Kerrisk (man-pages) wrote:
> This is a preparatory patch for following work. Move the F_SETPIPE_SZ
> limit-checking logic from pipe_fcntl() into pipe_set_size().  This
> simplifies the code a little, and allows for reworking required in
> a later patch that fixes the limit checking in pipe_set_size()

> +	if ((too_many_pipe_buffers_hard(pipe->user) ||
> +			too_many_pipe_buffers_soft(pipe->user)) &&
> +			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
> +		return -EPERM;

Some might say the indentation is off here. Not sure why checkpatch
didn't care.

Otherwise looks fine to me.


Vegard
