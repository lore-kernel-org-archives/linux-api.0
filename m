From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit and 32-bit ports
Date: Tue, 22 Dec 2015 23:11:37 +0100
Message-ID: <201512222311.37683.arnd@arndb.de>
References: <20140509191914.GA7286@jtriplet-mobl1> <201512222256.20580.arnd@arndb.de> <1592CC7D-B2F2-4E8B-BB90-4A20682B1FEE@zytor.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1592CC7D-B2F2-4E8B-BB90-4A20682B1FEE-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Santosh Shukla <santosh.shukla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 22 December 2015, H. Peter Anvin wrote:
> On that subject, shouldn't we have common infrastructure to deal with memory
> mapped I/O ports in the kernel?  Or do we have that now?  I obviously don't
> pay too much attention...

We don't have it at the moment, though some of the code that we introduced
for arm64 is defined in common code, just not shared with anything else.

Changing other architectures over to use this is painful and gains the
architectures very little, so I doubt it is going to happen.

	Arnd
