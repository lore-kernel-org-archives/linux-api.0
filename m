From: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
Date: Mon, 18 Feb 2013 10:39:25 -0800
Message-ID: <20130218183925.GA15167@core.coreip.homeip.net>
References: <20130215112911.68A98E0085@blue.fi.intel.com>
 <CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, RavindranathX Doddi <ravindranathx.doddi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Johan Hedberg <johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi David,

On Fri, Feb 15, 2013 at 12:46:55PM +0100, David Herrmann wrote:
> Hi Kirill
> 
> On Fri, Feb 15, 2013 at 12:29 PM, Kirill A. Shutemov
> <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > Hi David and all,
> >
> > There's claim in uhid.h that the interface is "compatible even between
> > architectures". But it obviously is not true: struct uhid_create_req
> > contains pointer which breaks everything.
> >
> > The easy way to demonstrate the issue is compile uhid-example.c with -m32
> > and try to run it on 64 bit kernel. Creating of the device will fail.
> 
> Indeed, we missed that. We should probably also notify the HIDP
> developers as "struct hidp_connadd_req" suffers from the same
> problems. (CC'ed)

I believe this issue has already been taken care of (see
compat_hidp_connadd_req and hidp_sock_compat_ioctl).

Thanks.

-- 
Dmitry
