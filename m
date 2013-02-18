From: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
Date: Mon, 18 Feb 2013 10:40:35 -0800
Message-ID: <20130218184035.GB15167@core.coreip.homeip.net>
References: <20130215112911.68A98E0085@blue.fi.intel.com>
 <CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com>
 <20130215120022.GA23694@x220>
 <20130215135141.1EFCEE0085@blue.fi.intel.com>
 <20130215200526.GA15811@core.coreip.homeip.net>
 <alpine.LNX.2.00.1302181121460.17024@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1302181121460.17024-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johan Hedberg <johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, RavindranathX Doddi <ravindranathx.doddi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 18, 2013 at 11:28:40AM +0100, Jiri Kosina wrote:
> On Fri, 15 Feb 2013, Dmitry Torokhov wrote:
> 
> > > Here's my attempt to fix the issue.
> > > 
> > > Not sure if tricks with padding in a good idea. We can  just use __u64
> > > instead of pointer, but it will require update of userspace to silence
> > > cast warning and will cause warning if you will try to use updated
> > > userspace with old kernel headers.
> > > 
> > > Any comments?
> > 
> > This does not fix anything really, we simply have to deal with compat
> > interface.
> > 
> > Compiled but not tested.
> > 
> > Thanks.
> 
> Sorry for late response, I have been extremely busy doing some skiing :-)

Sounds good. At least someone has the right priorities ;)

-- 
Dmitry
