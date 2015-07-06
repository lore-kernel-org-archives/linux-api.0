From: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Odd hang on suspend and shutdown
Date: Tue, 7 Jul 2015 00:38:45 +0200
Message-ID: <20150706223845.GF22015@zurbaran.home>
References: <CA+55aFy1x6iwbdV8WfR+wawj_1+PxJ+P-Js=EVqD9ZsQetSNJA@mail.gmail.com>
 <20150706160706.GA22015@zurbaran.home>
 <CA+55aFxfENpyWSDxgaQhB1mBHE6zs=w=Mc0VEQLgdwSaCMX5eQ@mail.gmail.com>
 <20150706165959.GB22015@zurbaran.home>
 <CA+55aFwM8c3Zm0t0cEnbGS0d0rinzGwnX9uSxqKjff8K=ATaRA@mail.gmail.com>
 <5B8DA87D05A7694D9FA63FD143655C1B3D3E34A6@hasmsx108.ger.corp.intel.com>
 <20150706221736.GA3135@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150706221736.GA3135-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 06, 2015 at 03:17:36PM -0700, Greg Kroah-Hartman wrote:
> > The major part of the bus was rejected by Greg and I'm still waiting
> > for him to like be me back and review the resend. 
> 
> That's 4.3-rc1 work, not for 4.2, so if this is breaking boxes, I'm with
> Linus, it should just be reverted for now.
> 
> I can't duplicate this here with my laptop, it's a few years old as
> well, but no problems, so this must be device specific somehow.
It's very much device specific as only few HSW based SKUs have NFC
enabled through the ME.

Cheers,
Samuel.
