From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 12/14] kdbus: add Makefile, Kconfig and MAINTAINERS entry
Date: Tue, 24 Mar 2015 16:15:43 +0100
Message-ID: <55117F9F.7000701@suse.cz>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org> <1425906560-13798-13-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425906560-13798-13-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
List-Id: linux-api@vger.kernel.org

On 03/09/2015, 02:09 PM, Greg Kroah-Hartman wrote:
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -261,6 +261,18 @@ config POSIX_MQUEUE_SYSCTL
>  	depends on SYSCTL
>  	default y
>  
> +config KDBUS
> +	tristate "kdbus interprocess communication"
> +	depends on TMPFS
> +	help
> +	  D-Bus is a system for low-latency, low-overhead, easy to use
> +	  interprocess communication (IPC).
> +
> +	  See Documentation/kdbus.txt

This one is missing from the series.

> +	  To compile this driver as a module, choose M here: the
> +	  module will be called kdbus.

It would be nice to also know who actually needs this... The old good
'if you have an ordinary machine, select m here'.

thanks,
-- 
js
suse labs
