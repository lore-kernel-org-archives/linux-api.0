From: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Odd hang on suspend and shutdown
Date: Mon, 6 Jul 2015 18:07:06 +0200
Message-ID: <20150706160706.GA22015@zurbaran.home>
References: <CA+55aFy1x6iwbdV8WfR+wawj_1+PxJ+P-Js=EVqD9ZsQetSNJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFy1x6iwbdV8WfR+wawj_1+PxJ+P-Js=EVqD9ZsQetSNJA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jul 05, 2015 at 04:20:02PM -0700, Linus Torvalds wrote:
> On my Sony VAIO Pro 11 laptop, commit c93b76b34b4d ("mei: bus: report
> also uuid in module alias") seems to cause problems at suspend and
> shutdown.
> 
> In particular, reverting just the oneliner to drivers/nfc/pn544/mei.c
> seems to fix things for me. The bisection was a pain, because it took
> me forever to realize that it was that one-liner that caused it: I had
> initially undone that one line simply because it didn't compile with
> it in place (complaints about MEI_NFC_UUID not being constant). So I
> continued to bisect with the fix unintentionally in place.
> 
> So just removing the MEI_NFC_UUID entry from the pn544_mei_tbl[] array
> initialization makes things work for me again.
I suppose you were not seeing this issue on e.g. a 4.1 kernel (assuming
this is not a brand new laptop) ?
If that's the case, is any of the pn544* kernel modules loaded when
running on top of a good kernel ?

Cheers,
Samuel.
