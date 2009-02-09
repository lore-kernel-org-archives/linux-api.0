From: "Hans J. Koch" <hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 1/2] User access to internal clocks
Date: Mon, 9 Feb 2009 18:12:24 +0100
Message-ID: <20090209171224.GD3167@local>
References: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8447d6730902090904y138af9c6r3d64278bc7a30811-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davide Rizzo <elpa.rizzo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-xIg/pKzrS19vn6HldHNs0ANdhmdF6hFW@public.gmane.org, ben-linux-elnMNo+KYs3YtjvyW6yDsg@public.gmane.org, "Hans J. Koch" <hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 09, 2009 at 06:04:29PM +0100, Davide Rizzo wrote:
> To: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
> Cc: "Hans J. Koch" <hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
> ben-linux-elnMNo+KYs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Davide,
please remove me from CC:, I'm not one of the clock gurus (which you might
want to CC instead).

Thanks,
Hans


> 
> This driver is for user level programs to interact with system clocks.
> It allows to read and modify rates and parents, using virtual files.
> It requires the implementation of 2 additional functions in the clk interface:
>  clk_for_each() and clk_name().
> Actually I implemented that functions only for Samsung S3C24xx platform.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
