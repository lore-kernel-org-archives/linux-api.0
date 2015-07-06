From: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Odd hang on suspend and shutdown
Date: Tue, 7 Jul 2015 00:33:14 +0200
Message-ID: <20150706223314.GD22015@zurbaran.home>
References: <CA+55aFy1x6iwbdV8WfR+wawj_1+PxJ+P-Js=EVqD9ZsQetSNJA@mail.gmail.com>
 <20150706160706.GA22015@zurbaran.home>
 <CA+55aFxfENpyWSDxgaQhB1mBHE6zs=w=Mc0VEQLgdwSaCMX5eQ@mail.gmail.com>
 <5B8DA87D05A7694D9FA63FD143655C1B3D3E3474@hasmsx108.ger.corp.intel.com>
 <CA+55aFxjuufbJpn+MngBzO3QyaYQm_ZNsgQY3VqPpguVpzOk6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxjuufbJpn+MngBzO3QyaYQm_ZNsgQY3VqPpguVpzOk6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 06, 2015 at 12:40:10PM -0700, Linus Torvalds wrote:
> > The question if the module get bound to the NFC me client?
> 
> .. and how would that show up?
If the pn544 probed correctly you will see a /sys/class/nfc/nfc0 entry.

Cheers,
Samuel.
