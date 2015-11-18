From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [Qemu-devel] [PATCH v4 4/4] devicetree: update documentation for
 fw_cfg ARM bindings
Date: Tue, 17 Nov 2015 21:17:27 -0500
Message-ID: <20151118021727.GA14351@GLSMBP.INI.CMU.EDU>
References: <1447470235-13643-1-git-send-email-somlo@cmu.edu>
 <1447470235-13643-5-git-send-email-somlo@cmu.edu>
 <20151115020754.GA21323@rob-hp-laptop>
 <564995FA.40308@redhat.com>
 <CAL_JsqKEi9BozyLQ9sKM3VL-hSSRntDyET859N1qTTMT4jkDOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL_JsqKEi9BozyLQ9sKM3VL-hSSRntDyET859N1qTTMT4jkDOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Andy Gross <agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Maydell <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jordan.l.just
List-Id: linux-api@vger.kernel.org

On Tue, Nov 17, 2015 at 04:14:42PM -0600, Rob Herring wrote:
> On Mon, Nov 16, 2015 at 2:38 AM, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> >
> > On 15/11/2015 03:07, Rob Herring wrote:
> >> We generally don't want DT docs to depend on other kernel documentation.
> >
> > DT docs do not contain a copy of the data sheets, either.  There is no
> > reason to say how to use the device (and even then, only doing so
> > partially) in the DT docs.
> 
> The difference is datasheets apply to all OS's, kernel documentation
> does not. In theory at least this could be used for other OS's, right?
> 
> Perhaps QEMU is the right place to thoroughly describe this and DT and
> sysfs docs can refer to it.

So, leave only ARM/DT specifc details in 
Documentation/devicetree/bindings/arm/fw-cfg.txt,
and rework the fw_cfg sysfs patch (1/4) to only document
sysfs specific details in
Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg ?

The fw_cfg "datasheet" does exist in QEMU already, so there is
something to point at from either/both of the above.

Thanks,
--Gabriel
