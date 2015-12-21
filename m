From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v2 4/5] firmware: actually return NULL on failed
 request_firmware_nowait()
Date: Mon, 21 Dec 2015 20:06:10 +0100
Message-ID: <20151221190609.GP20409@wotan.suse.de>
References: <1449701429-121423-1-git-send-email-computersforpeace@gmail.com>
 <1449701429-121423-4-git-send-email-computersforpeace@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449701429-121423-4-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian Norris <computersforpeace@gmail.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ming Lei <ming.lei@canonical.com>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 09, 2015 at 02:50:28PM -0800, Brian Norris wrote:
> The kerneldoc for request_firmware_nowait() says that it may call the
> provided cont() callback with @fw == NULL, if the firmware request
> fails. However, this is not the case when called with an empty string
> (""). This case is short-circuited by the 'name[0] == '\0'' check
> introduced in commit 471b095dfe0d ("firmware_class: make sure fw requests
> contain a name"), so _request_firmware() never gets to set the fw to
> NULL.
> 
> Noticed while using the new 'trigger_async_request' testing hook:

<-- snip -->

> 
>     # printf '\x00' > /sys/devices/virtual/misc/test_firmware/trigger_async_request
>     [   32.126322] test_firmware: loading ''
>     [   32.129995] test_firmware: failed to async load firmware
>     -bash: printf: write error: No such device
> 
> Fixes: 471b095dfe0d ("firmware_class: make sure fw requests contain a name")
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Acked-by: Ming Lei <ming.lei@canonical.com>
> Acked-by: Kees Cook <keescook@chromium.org>

Acked-by: Luis R. Rodriguez <mcgrof@suse.com>

  Luis
