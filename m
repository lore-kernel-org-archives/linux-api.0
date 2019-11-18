From: kernel test robot <rong.a.chen@intel.com>
Subject: Re: [LKP] Re: [pipe] d60337eff1:
 BUG:kernel_NULL_pointer_dereference,address
Date: Mon, 18 Nov 2019 15:53:22 +0800
Message-ID: <35daca93-ff2b-2c7d-b837-72396ca0677a@intel.com>
References: <9279.1573824532@warthog.procyon.org.uk>
 <20191110031348.GE29418@shao2-debian>
 <6853.1573834946@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6853.1573834946@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, kernel test robot <lkp@intel.com>
Cc: torvalds@linux-foundation.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, lkp@lists.01.org
List-Id: linux-api@vger.kernel.org

Hi David,

Yes, it can fix the problem.

Best Regards,
Rong Chen

On 11/16/2019 12:22 AM, David Howells wrote:
> Actually, no, this is the fix:
>
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 7006b5b2106d..be2fc5793ddd 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -537,7 +537,7 @@ static size_t push_pipe(struct iov_iter *i, size_t size,
>   		buf->ops = &default_pipe_buf_ops;
>   		buf->page = page;
>   		buf->offset = 0;
> -		buf->len = max_t(ssize_t, left, PAGE_SIZE);
> +		buf->len = min_t(ssize_t, left, PAGE_SIZE);
>   		left -= buf->len;
>   		iter_head++;
>   		pipe->head = iter_head;
>
> David
> _______________________________________________
> LKP mailing list -- lkp@lists.01.org
> To unsubscribe send an email to lkp-leave@lists.01.org
