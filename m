From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] selftests/kdbus: handle cap_get_proc() error properly
Date: Wed, 17 Jun 2015 07:37:20 -0700
Message-ID: <20150617143720.GA19114@kroah.com>
References: <1434550697-24785-1-git-send-email-sergei@s15v.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434550697-24785-1-git-send-email-sergei-E844GTqJAzo@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jun 17, 2015 at 05:18:13PM +0300, Sergei Zviagintsev wrote:
> Fix typo in checking error value of cap_get_proc(): cap -> caps
> 
> Signed-off-by: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
> ---
>  tools/testing/selftests/kdbus/kdbus-util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

You sent 5 patches, yet no hints as to what order they should be applied
in :(

Please resend in a patch series that is properly threaded so we can
handle this correctly.

thanks,

greg k-h
