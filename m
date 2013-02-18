From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
Date: Mon, 18 Feb 2013 12:18:08 +0200 (EET)
Message-ID: <20130218101808.EA71CE0085@blue.fi.intel.com>
References: <20130215112911.68A98E0085@blue.fi.intel.com> <CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com> <20130215120022.GA23694@x220> <20130215135141.1EFCEE0085@blue.fi.intel.com> <20130215200526.GA15811@core.coreip.homeip.net>
Content-Transfer-Encoding: 7bit
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <20130215200526.GA15811@core.coreip.homeip.net>
Sender: linux-input-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Johan Hedberg <johan.hedberg@gmail.com>, David Herrmann <dh.herrmann@googlemail.com>, linux-api@vger.kernel.org, linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>, RavindranathX Doddi <ravindranathx.doddi@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
List-Id: linux-api@vger.kernel.org

Dmitry Torokhov wrote:
> On Fri, Feb 15, 2013 at 03:51:41PM +0200, Kirill A. Shutemov wrote:
> > Johan Hedberg wrote:
> > > Hi David,
> > > 
> > > On Fri, Feb 15, 2013, David Herrmann wrote:
> > > > On Fri, Feb 15, 2013 at 12:29 PM, Kirill A. Shutemov
> > > > <kirill.shutemov@linux.intel.com> wrote:
> > > > > Hi David and all,
> > > > >
> > > > > There's claim in uhid.h that the interface is "compatible even between
> > > > > architectures". But it obviously is not true: struct uhid_create_req
> > > > > contains pointer which breaks everything.
> > > > >
> > > > > The easy way to demonstrate the issue is compile uhid-example.c with -m32
> > > > > and try to run it on 64 bit kernel. Creating of the device will fail.
> > > > 
> > > > Indeed, we missed that. We should probably also notify the HIDP
> > > > developers as "struct hidp_connadd_req" suffers from the same
> > > > problems. (CC'ed)
> > > > 
> > > > > I don't see an easy way to fix this. Few options:
> > > > >
> > > > > 1. Replace the pointer with u64. It will fix the issue, but it breaks ABI
> > > > >    which is never a good idea. Not sure how many users interface already
> > > > >    has.
> > > > 
> > > > The only users I am aware of is an HID debugging tool and experimental
> > > > HoG Bluetooth support (bluez). Maybe Marcel or Johan can comment
> > > > whether this is already used by bluez-5? If it is, then we shouldn't
> > > > break ABI and go with #2+#3. Otherwise, I think changing to u64 should
> > > > be ok.
> > > > On the other hand, it would break any future build for older stable
> > > > kernels so not breaking ABI is probably the best idea. Any comments? I
> > > > can add a COMPAT fix and a comment to fix this in the next version of
> > > > UHID_CREATE.
> > > 
> > > The HoG code in BlueZ 5 does indeed use this API and it's also not
> > > anymore behind any kind of experimental flag (i.e. it is an officially
> > > supported feature).
> > > 
> > > Johan
> > 
> > Here's my attempt to fix the issue.
> > 
> > Not sure if tricks with padding in a good idea. We can  just use __u64
> > instead of pointer, but it will require update of userspace to silence
> > cast warning and will cause warning if you will try to use updated
> > userspace with old kernel headers.
> > 
> > Any comments?
> 
> This does not fix anything really, we simply have to deal with compat
> interface.
> 
> Compiled but not tested.

Works for me.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Comment in uhid.h about cross-arch compatibility should be
removed since it's false.

-- 
 Kirill A. Shutemov
