From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v5 04/28] fpga: mgr: add compat_id support
Date: Tue, 22 May 2018 17:39:50 +0800
Message-ID: <20180522093950.GA27322@hao-dev>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
 <1525229431-3087-5-git-send-email-hao.wu@intel.com>
 <CANk1AXRsWsd++wjWH44CCWN+cmscy_WjLJhaGGgxmmNe-u1OLw@mail.gmail.com>
 <20180521030307.GA26500@hao-dev>
 <CANk1AXTDgVONiaECNOnwj26vCxJSi7ixvD_QcB4VmEo7P_cUMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXTDgVONiaECNOnwj26vCxJSi7ixvD_QcB4VmEo7P_cUMA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, "Liu, Song" <song.liu@intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, May 21, 2018 at 12:33:05PM -0500, Alan Tull wrote:
> On Sun, May 20, 2018 at 10:03 PM, Wu Hao <hao.wu@intel.com> wrote:
> > On Mon, May 07, 2018 at 04:09:06PM -0500, Alan Tull wrote:
> >> On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:
> >>
> >> Hi Hao,
> >>
> >> Looks good!
> >>
> >> > This patch introduces compat_id support to fpga manager, it adds
> >> > a fpga_compat_id pointer to fpga manager data structure to allow
> >> > fpga manager drivers to save the compatibility id. This compat_id
> >> > could be used for compatibility checking before doing partial
> >> > reconfiguration to associated fpga regions.
> >> >
> >> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> >> Acked-by: Alan Tull <atull@kernel.org>
> >
> > Hi Alan
> >
> > Thanks a lot for the acked-by.
> >
> > Did you get a chance to look into other patches?
> 
> What I'm looking for mostly is: is it clear that this code was written
> to be reused.  What do you think?  Was it?  Is there a way that intent
> could be made clear in the code? 

Hi Alan,

I am a little confused, so I guess I need to clarify several things here
to avoid misunderstanding.

Actualy we are submitting this patchset to enable Intel FPGA products
(e.g Intel Programmable Acceleration Card (PAC) with Intel Arria 10 GX
FPGA[1]). Once this device driver is accepted by upstream, then people
could use them with standard linux kernel. So the major purpose of the
patchset is just a device driver for Intel specific FPGA device enabling.

The Device Feature List (DFL) is one concept used in the Intel PAC A10
FPGA device, it's a linked list of device features with predefined data
structures. The DFL is defined in the FPGA device spec from Intel, but we
all think it would be great if more people coud reuse it in their devices
too, so some code could be reused. I think it may not be a problem for
some of other Intel FPGA products to reuse these driver code, because they
probably follow the same DFL spec to have Port and FME implemented. It's
the same for other developers/vendors to reuse DFL to create their own
products. They have to implement the Port and FME in device memory per
spec, otherwise it may not be able to reuse current patchset. Please note
that current DFL spec doesn't provide a method to customize the Port or
FME, or even have a totally new Port or FME, but it's possible in the
future version of DFL.

So to me, it's conditional reusable for current patchset. It requires the
FPGA device to follow the same DFL spec with Port and FME defined (and
their private features too).

> This patchset has a history of being
> a one-off solution for a single platform, doing things to work around
> the FPGA framework instead of doing what the framework was intended to
> do.  The FPGA framework was written so that any FPGA could be used
> with interface.  Currently in the upstream that means any of the
> supported FPGAs can be programmed with the same of-fpga-region code.
> It didn't have to get rewritten for each fpga.

Per your suggestion, we already have a separated layer for enumeration,
different platform devices/drivers for different functional blocks (e.g
Port and FME), it also creates fpga region, manager, bridge to keep aligned
with current FPGA framework. Thanks again for your valuable suggestions.

> 
> This patchset adds 5000 lines and I understand that another 4000 is
> coming to add to this.  

This is because there are a lot of features implemented by Intel FPGA
products (e.g Intel PAC Card). Most code after this patchset is to add
private features support to Port and FME.

> Has that been written so that the upper layer
> can be reused?  Or will the 'reusable' version be another huge
> patchset?  Do you see my point?  

I think current code is conditional reusable per explaination above, do
you agree? or you have other concerns on current driver architecture?

> Up to this point I've been trying to
> help figure out what changes could make this reusable.  If you could
> get with someone to take responsibility for architecting this patchset
> to be clearly reusable, that could speed things up.

Please let me know which part is unclear to you. I see you use "clear"
for several times in your response, I do feel you have some concerns
somewhere, may I know which part is not clear to you? If you're not clear
about how DFL could support the customization. e.g if someone introduced
a totally new Port, then how it's going to reuse our current driver. I
would like to say, the behavior is not defined by DFL spec at all, so
current code may not be able to reused at all. Actually there are a lot
of similar open questions which are also unclear to me (e.g if spec will
allow to introduce a totally new port, if yes, then how to handle the
reset code with existing FME) as spec says nothing about these cases, at
least for current version. As no related description in DFL spec, then
we don't have to consider these cases for now.

Thanks
Hao

> 
> If there are improvements to the current FPGA framework that can help
> this work, I'm interested and open to suggestions/code in that
> direction..
> 
> Alan
> 
> >
> > Thanks
> > Hao
