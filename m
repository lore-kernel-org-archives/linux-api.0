From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 0/4] SysFS driver for QEMU fw_cfg device
Date: Mon, 5 Oct 2015 13:56:47 +0100
Message-ID: <20151005125647.GL19064@leverpostej>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
 <20151005100035.GA19064@leverpostej>
 <561263A4.2020304@redhat.com>
 <20151005122332.GK19064@leverpostej>
 <20151005124346.GG1977@HEDWIG.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151005124346.GG1977-h65ZQ0r4j6KKUezXOiBB2eW1CriLhL8O@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Cc: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 05, 2015 at 08:43:46AM -0400, Gabriel L. Somlo wrote:
> On Mon, Oct 05, 2015 at 01:23:33PM +0100, Mark Rutland wrote:
> > On Mon, Oct 05, 2015 at 01:48:52PM +0200, Paolo Bonzini wrote:
> > > 
> > > 
> > > On 05/10/2015 12:00, Mark Rutland wrote:
> > > > Some of the keys in the example look like they'd come from other sources
> > > > (e.g. the *-tables entries), while others look like kernel/bootloader
> > > > configuration options (e.g. etc/boot-fail-wait, bootorder) -- I'm
> > > > concerned about redundancy here.
> > > 
> > > The redundancy is because the firmware and the bootloader actually
> > > _consume_ these fw_cfg strings to produce the others (the ACPI tables,
> > > the kernel configuration options).
> > > 
> > > On the other hand, hiding some strings just because they ought to have
> > > been consumed already makes little sense.
> > 
> > Sure. However, I'm concerned that providing redundant interfaces for
> > those could lead to people grabbing information from here (because it's
> > convenient) rather than the existing canonical locations, which means we
> > get more software that works on fewer systems for no good reason.
> > 
> > What I couldn't figure out was what _additional_ information this
> > provided; it looked like a mixed bag of details we could already get
> > from disparate sources. If that's all it does, then it seems to me like
> > it doesn't add any benefit and potentially makes things worse.
> > 
> > So what do we get from this interface that we cannot get elsewhere, and
> > why is this the best way of exposing it?
> 
> Starting with qemu 2.4, it is possible to insert arbitrary named
> blobs into fw_cfg from the qemu command line. *Those* entries
> might be interesting to userspace, which is why it might be handy
> to access to fw_cfg blobs in general.

So this is a mechanism to pass arbitrary key:value pairs to a guest
userspace? What would those be used for, and why would this be the
correct location for that?

How do we avoid clashes between user-selected names and those we need to
pass actual FW data?

Mark.
