From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] kdbus: uapi: Fix kernel-doc for enum kdbus_send_flags
Date: Thu, 09 Apr 2015 12:22:48 +0200
Message-ID: <552652F8.1010407@zonque.org>
References: <1428574261-18624-1-git-send-email-sergei@s15v.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428574261-18624-1-git-send-email-sergei-E844GTqJAzo@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/09/2015 12:11 PM, Sergei Zviagintsev wrote:
> Signed-off-by: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>

Acked-by: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>

> ---
>  include/uapi/linux/kdbus.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/kdbus.h b/include/uapi/linux/kdbus.h
> index 2fe0a1c5056c..00a6e142c977 100644
> --- a/include/uapi/linux/kdbus.h
> +++ b/include/uapi/linux/kdbus.h
> @@ -544,7 +544,7 @@ struct kdbus_msg_info {
>   *				reply to this message. The
>   *				KDBUS_CMD_SEND ioctl() will block
>   *				until the reply is received, and
> - *				offset_reply in struct kdbus_msg will
> + *				reply in struct kdbus_cmd_send will
>   *				yield the offset in the sender's pool
>   *				where the reply can be found.
>   *				This flag is only valid if
> 
