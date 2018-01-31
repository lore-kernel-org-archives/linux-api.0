From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/21] fpga: add device feature list support
Date: Wed, 31 Jan 2018 17:22:55 -0600
Message-ID: <CANk1AXTbNr5tem_313LXBeVAN91M9PQ2c8Q8rbyCs48B1b2mUg@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-5-git-send-email-hao.wu@intel.com> <CANk1AXQ_9+m-MvawwhaSpSfxO-Psg1F37vA9MfMcL4Q2t65dVA@mail.gmail.com>
 <CANk1AXR76T4x=BNcW=ukmcb45GadRPPcrtBDJEjxutCSHuNQNQ@mail.gmail.com>
 <20171221072242.GB4861@hao-dev> <20171222084501.GA10662@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222084501.GA10662@hao-dev>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 22, 2017 at 2:45 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> > >
>> > > I see that the port code is included as part of the enumeration code.
>> > > This is not very future-proofed, if a different port needs to be
>> > > supported.
>> > >
>> > > The port is a FPGA fabric based bridge with expanded functionality,
>> > > right?  So it is similar to the altera freeze bridge, but adds the
>> > > ability to reset the fabric and some other features are promised in
>> > > the future, IIUC.  I still think that the port could be implemented in
>> > > the bridge driver .c file instead of being here as part of the
>> > > enumeration code.   For that to happen, some APIs would need to be
>> > > added to the bridge framework and the FPGA region framework.  Then the
>> > > reset can be requested through a new FPGA region API function.
>> > >
>> > > The advantage of this is that if this patchset evolves and there is
>> > > some other v2 port driver needed, it can be a different driver if it
>> > > needs to be.
>> > >
>> > > If the port reset is really a fabric reset,
>> >
>> > Actually 'fabric reset' is probably not clear enough.  It's resetting
>> > the hardware in a partial reconfiguration region, not just resetting
>> > the bridge.  I'm trying to come up with a term that makes that clear
>> > what is getting reset is the contents of the region.
>> >
>> > > (correct me if I'm
>> > > remembering wrongly) then it would be helpful to call it a
>> > > fabric_reset.  This would be the first bridge driver supporting fabric
>> > > reset.  I think it won't be the last.
>> > >
>> > > So what I'm proposing would be added/changed would be:
>> > > * move all the bridge code to fpga-dfl-fme-br.c
>> > > * add .fabric_reset to bridge ops
>> > > * add fpga_bridges_reset to fpga-bridge.c (a new function that goes
>> > > through a list of bridges and calls the reset ops if it exists,
>> > > ignores the bridges where it doesn't exist)
>> > > * add fpga_region_fabric_reset to fpga-region.c.  This function gets
>> > > the region, gets the bridges, calls fpga_bridges_reset (can steal code
>> > > from fpga_region_program_fpga)
>> > > * the rest of the patchset can use fpga_region_fabric_reset instead of
>> > > fpga_port_reset
>>
>> Hi Alan
>>
>> Actually I think we can't move all the bridge code to fpga-dfl-fme-br.c as
>> this bridge (and region) is created by FME PR sub feature code, mainly for
>> PR function. But user may need the reset function when run some workload
>> on target Port/AFU, if consider virtualization case (SRIOV), there is only
>> Port/AFU in each VF, and no FME in VF (that means nobody creates the fpga
>> region/bridge/region). So it's need from port platform driver side as well.
>>
>> The orignal idea that creates fpga-mgr/bridges/regions under FME, is that
>> even we turned all Ports/AFUs into VFs (user can not see port platform
>> device and the user interfaces exposed by port driver on PF), but user
>> still can use FME to do PR to those Ports/AFUs in turned into VFs (assigned
>> in different virtual machines).
>>
>> I fully agree with you, that we should avoid feature specific code in the
>> common enumeration code and feature device framework if possible. I guess
>> I need some time to check and see if any other solutions (e.g export those
>> functions from port driver not DFL framework). Will back here once I have
>> some clear idea.:)
>
> Hi Alan
>
> I checked further on this, it seems no good method to avoid feature_dev
> specific code (e.g port/fme related code) in DFL framework, as it needs to
> manage feature devices for virtualization cases. I tried that, make some
> changes that the port reset code could be exported by the port platform
> device instead, and fpga-dfl-fme-br.c depends on port platform device to
> implement the bridge ops, but 1) it introduced more dependency between
> these driver modules which seems not good. (ideally it's better that PR
> could be done by FME module itself, no need to have some dependency on
> other modules, e.g Port). 2) still have other port code (e.g fpga_port_id
> which is useful for port management code in framework) can't be moved to
> port platform driver module in the same method. As hardware is designed
> this way, even we see separated device features in the DFL, but they have
> a lot of dependency internally in different use cases (e.g PR, SRIOV and
> etc).

Hi Hao,

OK, well sounds like it's not feasible then.  Thanks for looking into it.

Alan

>
> Thanks
> Hao
>
>>
>> Thanks
>> Hao
>>
>> > >
>> > > Alan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fpga" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
