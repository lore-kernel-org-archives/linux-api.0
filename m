From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Odd hang on suspend and shutdown
Date: Tue, 7 Jul 2015 16:32:24 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B3D3E48DB@hasmsx108.ger.corp.intel.com>
References: <CA+55aFy1x6iwbdV8WfR+wawj_1+PxJ+P-Js=EVqD9ZsQetSNJA@mail.gmail.com>
 <20150706160706.GA22015@zurbaran.home>
 <CA+55aFxfENpyWSDxgaQhB1mBHE6zs=w=Mc0VEQLgdwSaCMX5eQ@mail.gmail.com>
 <20150706223133.GC22015@zurbaran.home>
 <CA+55aFwsrywW4fEt33BZFPSu5F0eAFB5YAY-zHUZ8-BLv1VcDg@mail.gmail.com>
 <CA+55aFxo064xa5m3KPjSJxQCrDL3H1QwuEcpCKMg0TL8C0aedQ@mail.gmail.com>
 <20150707040630.GB25900@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



> -----Original Message-----
> From: Winkler, Tomas
> Sent: Tuesday, July 07, 2015 17:39
> To: 'Greg Kroah-Hartman'; Linus Torvalds
> Cc: Samuel Ortiz; Linux API
> Subject: RE: Odd hang on suspend and shutdown
> 
> 
> 
> > Subject: Re: Odd hang on suspend and shutdown
> >
> > On Mon, Jul 06, 2015 at 05:04:18PM -0700, Linus Torvalds wrote:
> > > On Mon, Jul 6, 2015 at 4:06 PM, Linus Torvalds
> > > <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > > >
> > > > I'll go and test the plain revert case.
> > >
> > > So the "plain" revert ended up being more than a single revert, just
> > > because there were multiple changes in that area. But after doing
> > > this:
> > >
> > >     git revert b144ce2d3761
> > >     git revert 1d3ff76721fb
> > >     git revert be9b720a0ccb
> > >     git revert 007d64eb2232
> > >     git revert dbac993f6a6d
> > >     git revert d4b78c7290dd
> > >     git revert c93b76b34b4d
> > >
> > > I have a working kernel that loads the pn544 thing automatically, and
> > > shows it in /sys/class/nfc/, and suspend works.
> > >
> > > So I'm back to the pre-merge-window behavior.
> >
> > I have no objection to just reverting all of these to get back to a
> > working system.
> I was able to reproduce the issue
> The bug was introduced in here be9b720a0ccba096d669bc86634f900b82b9bf71
> Hope to localize the actual root cause soon so we don't have  to revert the all the
> patches.

There is a device lock taken twice  when calling mei_cl_disable_device()... 
Thanks
Tomas
 
