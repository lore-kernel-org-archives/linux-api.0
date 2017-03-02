From: Sean Young <sean-hENCXIMQXOg@public.gmane.org>
Subject: Re: [PATCH v3 17/19] [media] lirc: implement reading scancode
Date: Thu, 2 Mar 2017 13:31:16 +0000
Message-ID: <20170302133116.GA29616@gofer.mess.org>
References: <cover.1488023302.git.sean@mess.org>
 <b9722d41efc7dd75ddbab78a62f654aa56d9a0a3.1488023302.git.sean@mess.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b9722d41efc7dd75ddbab78a62f654aa56d9a0a3.1488023302.git.sean-hENCXIMQXOg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Feb 25, 2017 at 11:51:32AM +0000, Sean Young wrote:
> @@ -362,10 +394,15 @@ static unsigned int ir_lirc_poll(struct file *filep,
>  
>  	poll_wait(filep, &lirc->wait_poll, wait);
>  
> -	if (!lirc->drv.attached)
> +	if (!lirc->drv.attached) {
>  		events = POLLHUP;
> -	else if (!kfifo_is_empty(&lirc->rawir))
> -		events = POLLIN | POLLRDNORM;
> +	} else if (lirc->rec_mode == LIRC_MODE_SCANCODE) {
> +		if (!kfifo_is_empty(&lirc->rawir))
> +			events = POLLIN | POLLRDNORM;
> +	} else if (lirc->rec_mode == LIRC_MODE_MODE2) {
> +		if (!kfifo_is_empty(&lirc->scancodes))
> +			events = POLLIN | POLLRDNORM;
> +	}
>  
>  	return events;
>  }

So one issue with with this API change is if you want to poll for both
raw IR and decoded scancodes. If poll were to return ready on raw IR and 
scancodes, existing code would not read the scancodes and end up in an
infinite loop.

So poll only returns ready for the current mode (either raw IR or scancodes).

If you want to read for both scancodes and raw IR, either:

1) Poll in scancode mode for 200ms, Poll in rawir for 200ms. Repeat.

2) Allow multiple fds to be opened on /dev/lircN device and open two
   file descriptors, one in each mode (I want to add this to rc-core anyway).

3) Add an ioctl in which you can set the "poll" mask, e.g.:

   unsigned mask = LIRC_MODE_MODE2 | LIRC_MODE_SCANCODE;
   ioctl(fd, LIRC_SET_POLL_MASK, &mask);
   

Sean
