From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v3 02/21] fpga: mgr: add region_id to fpga_image_info
Date: Mon, 4 Dec 2017 14:26:14 -0600
Message-ID: <CANk1AXTbrD3w=VEzXqTRfebgTYSRNGANthwN_PLVz8WWtxb7CA@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-3-git-send-email-hao.wu@intel.com> <20171129061107.w62q5tk5dplq2zmr@us-aus-ras-130-164-29-6.amer.corp.natinst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171129061107.w62q5tk5dplq2zmr@us-aus-ras-130-164-29-6.amer.corp.natinst.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Moritz Fischer <mdf@kernel.org>
Cc: Wu Hao <hao.wu@intel.com>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 29, 2017 at 12:11 AM, Moritz Fischer <mdf@kernel.org> wrote:
> Hi Hao,
>
> On Mon, Nov 27, 2017 at 02:42:09PM +0800, Wu Hao wrote:
>> This patch adds region_id to fpga_image_info data structure, it
>> allows driver to pass region id information to fpga-mgr via
>> fpga_image_info for fpga reconfiguration function.
>>
>> Signed-off-by: Wu Hao <hao.wu@intel.com>
> Acked-by: Moritz Fischer <mdf@kernel.org>

Acked-by: Alan Tull <atull@kernel.org>

>> ----
>> v3: add one line comment for region_id
>> ---
>>  include/linux/fpga/fpga-mgr.h | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/include/linux/fpga/fpga-mgr.h b/include/linux/fpga/fpga-mgr.h
>> index 1ad4822..6e98b66 100644
>> --- a/include/linux/fpga/fpga-mgr.h
>> +++ b/include/linux/fpga/fpga-mgr.h
>> @@ -88,6 +88,7 @@ enum fpga_mgr_states {
>>   * @sgt: scatter/gather table containing FPGA image
>>   * @buf: contiguous buffer containing FPGA image
>>   * @count: size of buf
>> + * @region_id: id of target region
>>   * @dev: device that owns this
>>   * @overlay: Device Tree overlay
>>   */
>> @@ -100,6 +101,7 @@ struct fpga_image_info {
>>       struct sg_table *sgt;
>>       const char *buf;
>>       size_t count;
>> +     int region_id;
>>       struct device *dev;
>>  #ifdef CONFIG_OF
>>       struct device_node *overlay;
>> --
>> 1.8.3.1
>>
>
> Moritz
