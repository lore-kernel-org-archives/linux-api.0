From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 24/31] media: au0828 fix null pointer reference in
 au0828_create_media_graph()
Date: Thu, 28 Jan 2016 13:15:28 -0700
Message-ID: <56AA76E0.2080208@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <33b9da8f01b1d94844ac677efd31a66c40c39ecb.1452105878.git.shuahkh@osg.samsung.com>
 <20160128144443.6a8b08a7@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <20160128144443.6a8b08a7@recife.lan>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

On 01/28/2016 09:44 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  6 Jan 2016 13:27:13 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Add a new wrapper function to au0828_create_media_graph()
>> to be called as an entity_notify function to fix null
>> pointer dereference. A rebasing mistake resulted in
>> registering au0828_create_media_graph() without the
>> correct parameters which lead to the following
>> null pointer dereference:
>>
>> [   69.006164] Call Trace:
>> [   69.006169]  [<ffffffff81a9a1b0>] dump_stack+0x44/0x64
>> [   69.006175]  [<ffffffff81503af9>] print_trailer+0xf9/0x150
>> [   69.006180]  [<ffffffff81509284>] object_err+0x34/0x40
>> [   69.006185]  [<ffffffff815063c4>] ? ___slab_alloc+0x4c4/0x4e0
>> [   69.006190]  [<ffffffff8150b732>] kasan_report_error+0x212/0x520
>> [   69.006196]  [<ffffffff815063c4>] ? ___slab_alloc+0x4c4/0x4e0
>> [   69.006201]  [<ffffffff8150ba83>] __asan_report_load1_noabort+0x43/0x50
>> [   69.006208]  [<ffffffffa0d30991>] ? au0828_create_media_graph+0x641/0x730 [au0828]
>> [   69.006215]  [<ffffffffa0d30991>] au0828_create_media_graph+0x641/0x730 [au0828]
>> [   69.006221]  [<ffffffff82245c3d>] media_device_register_entity+0x33d/0x4f0
>> [   69.006234]  [<ffffffffa0ebeb1c>] media_stream_init+0x2ac/0x610 [snd_usb_audio]
>> [   69.006247]  [<ffffffffa0ea9a70>] snd_usb_pcm_open+0xcd0/0x1280 [snd_usb_audio]
> 
> Please merge the fix with the patch that caused the regression.

ok will merge it.

thanks,
-- Shuah
> 
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/usb/au0828/au0828-core.c | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
>> index f8d2db3..9497ad1 100644
>> --- a/drivers/media/usb/au0828/au0828-core.c
>> +++ b/drivers/media/usb/au0828/au0828-core.c
>> @@ -370,6 +370,20 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>>  	return 0;
>>  }
>>  
>> +void au0828_create_media_graph_notify(struct media_entity *new,
>> +				      void *notify_data)
>> +{
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +	struct au0828_dev *dev = (struct au0828_dev *) notify_data;
>> +	int ret;
>> +
>> +	ret = au0828_create_media_graph(dev);
>> +	if (ret)
>> +		pr_err("%s() media graph create failed for new entity %s\n",
>> +		       __func__, new->name);
>> +#endif
>> +}
>> +
>>  static int au0828_enable_source(struct media_entity *entity,
>>  				struct media_pipeline *pipe)
>>  {
>> @@ -535,7 +549,7 @@ static int au0828_media_device_register(struct au0828_dev *dev,
>>  	}
>>  	/* register entity_notify callback */
>>  	dev->entity_notify.notify_data = (void *) dev;
>> -	dev->entity_notify.notify = (void *) au0828_create_media_graph;
>> +	dev->entity_notify.notify = au0828_create_media_graph_notify;
>>  	ret = media_device_register_entity_notify(dev->media_dev,
>>  						  &dev->entity_notify);
>>  	if (ret) {


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
