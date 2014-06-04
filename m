From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Wed, 04 Jun 2014 15:59:19 -0700
Message-ID: <538FA4C7.2050206@zytor.com>
References: <20140509191914.GA7286@jtriplet-mobl1> <20140510070742.GE6099@debjann.fritz.box> <20140510193246.GA12079@thin> <20140511125006.GA16197@debjann.fritz.box> <20140511210514.GB6056@thin> <alpine.LFD.2.11.1406011101400.30121@eddie.linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.11.1406011101400.30121@eddie.linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Maciej W. Rozycki" <macro@linux-mips.org>, Josh Triplett <josh@joshtriplett.org>
Cc: Jann Horn <jann@thejh.net>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 06/01/2014 03:35 AM, Maciej W. Rozycki wrote:
> Also IIRC PCI-PCI bridges only forward port I/O space accesses 
> within the low 64kB.

Not true.

	-hpa
