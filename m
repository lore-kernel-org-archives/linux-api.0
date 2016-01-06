From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2 10/14] serial: pic32_uart: Add PIC32 UART driver
Date: Wed, 6 Jan 2016 22:32:47 +0000
Message-ID: <20160106223247.409a1d2b@lxorguk.ukuu.org.uk>
References: <1450133093-7053-1-git-send-email-joshua.henderson@microchip.com>
        <1450133093-7053-11-git-send-email-joshua.henderson@microchip.com>
        <20160105204322.2dc5ab3f@lxorguk.ukuu.org.uk>
        <F2D704DDA6AE8B4A87FF87509480F4A449E46187@CHN-SV-EXMX01.mchp-main.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <F2D704DDA6AE8B4A87FF87509480F4A449E46187@CHN-SV-EXMX01.mchp-main.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Paul.Thacker@microchip.com
Cc: Joshua.Henderson@microchip.com, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, ralf@linux-mips.org, Andrei.Pistirica@microchip.com, gregkh@linuxfoundation.org, jslaby@suse.com, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 6 Jan 2016 22:00:43 +0000
<Paul.Thacker@microchip.com> wrote:

> On 01/05/2016 03:50 PM, One Thousand Gnomes wrote:
> >
> >> +#define PIC32_SDEV_NAME		"ttyS"
> >> +#define PIC32_SDEV_MAJOR	TTY_MAJOR
> >> +#define PIC32_SDEV_MINOR	64
> >
> > No. Same goes for you as every one of the forty other people a year who
> > try and claim their console is ttyS. If it's not an 8250 it isn't.
> >
> > ttyS is the 8250, use dynamic major and minor and a different name.
> 
> Ok. Is there a naming convention documented anywhere? How about ttyPIC?

We used to document it but the document was always stale. ttyPIC sounds
fine providing nobody else is using it (and I don't think they are but
grep is your friend). We enforce the rule because in the early days lots
of people re-used ttyS for their chip. Then their chip grew an external
bus or turned into a SoC and a 16x50 got added and it all broke.

ttyPIC ought to be fine because even if you get new PIC devices with a
different uart you aren't likely to have both of the PIC cores on the
same device.

Alan
