From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH] y2038: fix socket.h header inclusion
Date: Thu, 14 Mar 2019 19:37:15 +0100
Message-ID: <87k1h1fgkk.fsf@mid.deneb.enyo.de>
References: <20190311153857.563743-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190311153857.563743-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 11 Mar 2019 16:38:17 +0100")
Sender: netdev-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David S . Miller" <davem@davemloft.net>, Deepa Dinamani <deepa.kernel@gmail.com>, Willem de Bruijn <willemb@google.com>, linux-alpha@vger.kernel.org, linux-arch@vger.kernel.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org, Laura Abbott <labbott@redhat.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Arnd Bergmann:

> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index 0d0fddb7e738..976e89b116e5 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -2,8 +2,8 @@
>  #ifndef _UAPI_ASM_SOCKET_H
>  #define _UAPI_ASM_SOCKET_H
>  
> +#include <linux/posix_types.h>
>  #include <asm/sockios.h>
> -#include <asm/bitsperlong.h>

This breaks POSIX conformance in glibc because the
<linux/posix_types.h> header is not namespace clean.  It contains the
identifiers fds_bits and val:

	unsigned long fds_bits[__FD_SETSIZE / (8 * sizeof(long))];

        int     val[2];

We could duplicate some of the SO_* constants for POSIX mode in glibc,
but it would be nice to avoid that.

Is there a different way of fixing this on the kernel side that avoids
including <linux/posix_types.h>?
