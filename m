From: Johan Hovold <johan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Thu, 5 Feb 2015 11:33:04 +0100
Message-ID: <20150205103304.GH13757@localhost>
References: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
 <20150116111108.GG30960@localhost>
 <a4610e13d0094d40b7e0574992509ec6@BN1AFFO11FD044.protection.gbl>
 <CAAVeFu+K0W96mi0=QR8JGSe9BpH2nC5WV_9qbSvm6LJGA8gc7Q@mail.gmail.com>
 <CACRpkdZ4CekD2xeJYM+UUtuGuwS2uB++XprSueWnshEVk=79Fw@mail.gmail.com>
 <bb967ff02726449ab6525d33bccde7e4@BL2FFO11FD014.protection.gbl>
 <CACRpkdYuHdbQ7aaeCQTwZO63LjWpKyZnPQRNCBmRybntXYJxFQ@mail.gmail.com>
 <ce91ced9e1f0481f8af03a168eda48b9@BN1AFFO11FD048.protection.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ce91ced9e1f0481f8af03a168eda48b9-reflc3kr++M/rzWiRNbYG+hlVc3/7hDbVaz/vdPVXQ4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>
Cc: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johan Hovold <johan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 04, 2015 at 10:27:15AM -0800, S=F6ren Brinkmann wrote:
> On Wed, 2015-02-04 at 10:19AM +0100, Linus Walleij wrote:

> > What needs to happen (IMHO) is to make gpio_chips properly obeying
> > the device model, and then add the attributes for fiddling around w=
ith
> > GPIOs to either the *real* device or create a new char device inter=
face.
> > Whatever works best. These mock devices are fragile and never
> > worked properly especially in the removal path as Johans recent
> > fixes has shown.
>=20
> Sure, that would be a nice long-term solution. But until then this pa=
tch
> would probably be welcomed by some people, without making the brokenn=
ess
> of this interface much worse.

We don't knowingly add broken functionality, and especially not when it
will become ABI that needs to be maintained forever.

And "this might be useful for someone at some point" is certainly not a
reason to break that rule.

Johan
