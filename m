From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Documentatin for userspace DMA
 support
Date: Mon, 22 Dec 2008 11:14:02 -0800
Message-ID: <20081222111402.4e6f2b96.randy.dunlap@oracle.com>
References: <208aa0f00812032053w5efb99dbk94511b0f8c1f0925@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754683AbYLVTOq@vger.kernel.org>
In-Reply-To: <208aa0f00812032053w5efb99dbk94511b0f8c1f0925@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Edward Estabrook <edward.estabrook.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Greg KH <gregkh@suse.de>, hjk@linutronix.de, edward_estabrook@agilent.com
List-Id: linux-api@vger.kernel.org

On Wed, 3 Dec 2008 20:53:27 -0800 Edward Estabrook wrote:

> --- linux-2.6.28-rc6/Documentation/DocBook/uio-howto.tmpl.orig	2008-12-03
> 12:03:43.000000000 -0800
> +++ linux-2.6.28-rc6/Documentation/DocBook/uio-howto.tmpl	2008-12-03
> 13:11:53.000000000 -0800
> @@ -572,6 +602,50 @@ to set up sysfs files for this mapping.
>  	</para>
>  </sect1>
> 
> +<sect1 id="dma_region_mmap">
> +<title>Allocating DMA region with mmap()</title>

          Allocating a DMA region with mmap()

> +	<para>
> +	To allocate and map a DMA memory region you use

duplicate "use use".  Instead of dropping the second one, make it "the".

> +	use <function>mmap()</function>.  You may create as
> +	many regions as system resources allow by repeated use of
> +	<function>mmap()</function>.
> +	</para>


---
~Randy
