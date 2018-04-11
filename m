From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 01/24] Add the ability to lock down access to the running
 kernel image
Date: Wed, 11 Apr 2018 10:37:38 -0700
Message-ID: <6a37b428-d9fb-12d5-8d36-8a032984af8c@infradead.org>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346388583.4030.15146667041427303547.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <152346388583.4030.15146667041427303547.stgit@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 04/11/2018 09:24 AM, David Howells wrote:
> ---
> 
>  arch/x86/kernel/setup.c |    2 +
>  include/linux/kernel.h  |   32 +++++++++++++++++++++++
>  security/Kconfig        |   23 ++++++++++++++++-
>  security/Makefile       |    3 ++
>  security/lock_down.c    |   65 +++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 124 insertions(+), 1 deletion(-)
>  create mode 100644 security/lock_down.c

> diff --git a/security/Kconfig b/security/Kconfig
> index c4302067a3ad..a68e5bdebad5 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -231,6 +231,28 @@ config STATIC_USERMODEHELPER_PATH
>  	  If you wish for all usermode helper programs to be disabled,
>  	  specify an empty string here (i.e. "").
>  
> +config LOCK_DOWN_KERNEL
> +	bool "Allow the kernel to be 'locked down'"
> +	help
> +	  Allow the kernel to be locked down.  Locking down the kernel turns
> +	  off various features that might otherwise allow access to the kernel

	  s/turns off/disables/

> +	  image (eg. setting MSR registers).

	         e.g.

> +
> +	  Note, however, that locking down your kernel will prevent some

	                                   the kernel
	                                   a kernel

> +	  drivers from functioning because allowing manual configuration of
> +	  hardware parameters is forbidden, lest a device be used to access the
> +	  kernel by DMA.  This mostly applies to ISA devices.

	Is DMA from non-ISA devices OK, or did I miss seeing that patch?

> +	  The kernel lockdown can be triggered by adding lockdown=1 to the
> +	  kernel command line.


> diff --git a/security/lock_down.c b/security/lock_down.c
> new file mode 100644
> index 000000000000..f35ffdd096ad
> --- /dev/null
> +++ b/security/lock_down.c
> @@ -0,0 +1,65 @@
> +/* Lock down the kernel
> + *
> + * Copyright (C) 2016 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.

fsf.org spells that Licence word as License. :)

> + */


-- 
~Randy
