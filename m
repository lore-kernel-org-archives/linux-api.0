From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: Why not make kdbus use CUSE?
Date: Mon, 1 Dec 2014 14:23:11 +0000
Message-ID: <20141201142311.37c81ff1@lxorguk.ukuu.org.uk>
References: <20141129063416.GE32286@woodpecker.gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141129063416.GE32286-WkJ4KB730YtOk+SH+krGketnjj8NnB7F@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Yao <ryao-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

> told quite plainly that such distributions are not worth consideration. If kdbus
> is merged despite concerns about security and backward compatibility, could we
> at least have the shim moved to libc netural place, like Linus' tree?

I would expect any other libc would fork the shim anyway (or just not
bother with systemd in most cases).

Alan
