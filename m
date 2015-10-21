From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] TTY, devpts: document pty count limiting
Date: Wed, 21 Oct 2015 10:04:23 -0700
Message-ID: <20151021170423.GA29006@kroah.com>
References: <20151021100854.7888.90252.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151021100854.7888.90252.stgit@buzz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Oct 21, 2015 at 01:08:54PM +0300, Konstantin Khlebnikov wrote:
> Logic was changed in kernel 3.4 by commit e9aba5158a80 ("tty: rework pty
> count limiting") but still isn't documented. Better late than never.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
> ---
>  Documentation/filesystems/devpts.txt |    9 +++++++++
>  Documentation/sysctl/kernel.txt      |    7 +++++++
>  2 files changed, 16 insertions(+)

Any reason you didn't cc: the tty maintainer on this?
