From: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Subject: Re: kdbus: add documentation
Date: Sun, 30 Nov 2014 10:02:32 +0100
Message-ID: <871tolysbb.fsf@mid.deneb.enyo.de>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416546149-24799-2-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
	(Greg Kroah-Hartman's message of "Thu, 20 Nov 2014 21:02:17 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

* Greg Kroah-Hartman:

> +7.4 Receiving messages

> +Also, if the connection allowed for file descriptor to be passed
> +(KDBUS_HELLO_ACCEPT_FD), and if the message contained any, they will be
> +installed into the receiving process after the KDBUS_CMD_MSG_RECV ioctl
> +returns. The receiving task is obliged to close all of them appropriately.

What happens if this is not possible because the file descriptor limit
of the processes would be exceeded?  EMFILE, and the message will not
be received?
