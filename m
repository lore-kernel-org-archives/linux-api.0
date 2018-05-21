From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v5 04/28] fpga: mgr: add compat_id support
Date: Mon, 21 May 2018 12:33:05 -0500
Message-ID: <CANk1AXTDgVONiaECNOnwj26vCxJSi7ixvD_QcB4VmEo7P_cUMA@mail.gmail.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
 <1525229431-3087-5-git-send-email-hao.wu@intel.com> <CANk1AXRsWsd++wjWH44CCWN+cmscy_WjLJhaGGgxmmNe-u1OLw@mail.gmail.com>
 <20180521030307.GA26500@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180521030307.GA26500@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, "Liu, Song" <song.liu@intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, May 20, 2018 at 10:03 PM, Wu Hao <hao.wu@intel.com> wrote:
> On Mon, May 07, 2018 at 04:09:06PM -0500, Alan Tull wrote:
>> On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:
>>
>> Hi Hao,
>>
>> Looks good!
>>
>> > This patch introduces compat_id support to fpga manager, it adds
>> > a fpga_compat_id pointer to fpga manager data structure to allow
>> > fpga manager drivers to save the compatibility id. This compat_id
>> > could be used for compatibility checking before doing partial
>> > reconfiguration to associated fpga regions.
>> >
>> > Signed-off-by: Wu Hao <hao.wu@intel.com>
>> Acked-by: Alan Tull <atull@kernel.org>
>
> Hi Alan
>
> Thanks a lot for the acked-by.
>
> Did you get a chance to look into other patches?

What I'm looking for mostly is: is it clear that this code was written
to be reused.  What do you think?  Was it?  Is there a way that intent
could be made clear in the code?  This patchset has a history of being
a one-off solution for a single platform, doing things to work around
the FPGA framework instead of doing what the framework was intended to
do.  The FPGA framework was written so that any FPGA could be used
with interface.  Currently in the upstream that means any of the
supported FPGAs can be programmed with the same of-fpga-region code.
It didn't have to get rewritten for each fpga.

This patchset adds 5000 lines and I understand that another 4000 is
coming to add to this.  Has that been written so that the upper layer
can be reused?  Or will the 'reusable' version be another huge
patchset?  Do you see my point?  Up to this point I've been trying to
help figure out what changes could make this reusable.  If you could
get with someone to take responsibility for architecting this patchset
to be clearly reusable, that could speed things up.

If there are improvements to the current FPGA framework that can help
this work, I'm interested and open to suggestions/code in that
direction..

Alan

>
> Thanks
> Hao
