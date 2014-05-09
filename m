From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Fri, 09 May 2014 14:20:45 -0700
Message-ID: <536D46AD.3070608@zytor.com>
References: <20140509191914.GA7286@jtriplet-mobl1> <9233735.5FfZoZovqP@wuerfel> <536D406D.2080508@zytor.com> <4366326.1D6xUnlac7@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4366326.1D6xUnlac7@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/09/2014 02:12 PM, Arnd Bergmann wrote:
> 
>> However, if we're going to have these devices I'm wondering if having
>> /dev/portw and /dev/portl (or something like that) might not make sense,
>> rather than requiring a system call per transaction.
> 
> Actually the behavior of /dev/port for >1 byte writes seems questionable
> already: There are very few devices on which writing to consecutive
> port numbers makes sense. Normally you just want to write a series
> of bytes (or 16/32 bit words) into the same port number instead,
> as the outsb()/outsw()/outsl() functions do.
> 

Indeed.  I missed the detail that it increments the port index; it is
virtually guaranteed to be bogus.

	-hpa
