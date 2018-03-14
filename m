From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v4 09/24] fpga: dfl-pci: add enumeration for feature devices
Date: Wed, 14 Mar 2018 09:48:35 -0500
Message-ID: <CANk1AXS7vmdnZ1M3xLiF-8aLueFdYfvjfXb3hvFkBVoo+iF36g@mail.gmail.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-10-git-send-email-hao.wu@intel.com> <CANk1AXSfXBXj_NH4Qcj6EDXEzAD_+T1sVudJdMbbgKK7hk13Mg@mail.gmail.com>
 <20180314052121.GB32276@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180314052121.GB32276@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 14, 2018 at 12:21 AM, Wu Hao <hao.wu@intel.com> wrote:

>> > +
>> > +       drvdata->cdev = cdev;
>> > +
>> > +enum_info_free_exit:
>> > +       fpga_enum_info_free(info);
>>
>> This is the only place I saw fpga_enum_info_free being called.
>
> It doesn't need to keep the enumeration inforamtion data structure once
> the enumeration done, so in the driver, it always did fpga_enum_info_free
> once fpga_enumerate_feature_devs(info) returned in this function. so
> no need to consider it in other places per my understanding. : )
>
> Thanks
> Hao
>

Oh yes I see!  I was looking right at it and didn't see it!  Thanks
for the clarification.

Alan
