From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 29/31] media: track media device unregister in progress
Date: Thu, 28 Jan 2016 13:42:35 -0700
Message-ID: <56AA7D3B.6090603@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <151cfbe0e59b3d5396951bdcc29666614575f5bc.1452105878.git.shuahkh@osg.samsung.com>
 <20160128150105.06a9a18d@recife.lan> <56AA4A18.8030303@osg.samsung.com>
 <20160128152843.5ce581fa@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160128152843.5ce581fa@recife.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

On 01/28/2016 10:28 AM, Mauro Carvalho Chehab wrote:
> Em Thu, 28 Jan 2016 10:04:24 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> On 01/28/2016 10:01 AM, Mauro Carvalho Chehab wrote:
>>> Em Wed,  6 Jan 2016 13:27:18 -0700
>>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
>>>   
>>>> Add support to track media device unregister in progress
>>>> state to prevent more than one driver entering unregister.
>>>> This enables fixing the general protection faults while
>>>> snd-usb-audio was cleaning up media resources for pcm
>>>> streams and mixers. In this patch a new interface is added
>>>> to return the unregister in progress state. Subsequent
>>>> patches to snd-usb-audio and au0828-core use this interface
>>>> to avoid entering unregister and attempting to unregister
>>>> entities and remove devnodes while unregister is in progress.
>>>> Media device unregister removes entities and interface nodes.  
>>>
>>> Hmm... isn't the spinlock enough to serialize it? It seems weird the
>>> need of an extra bool here to warrant that this is really serialized.
>>>   
>>
>> The spinlock and check for media_devnode_is_registered(&mdev->devnode)
>> aren't enough to ensure only one driver enters the unregister. 
>>
>> Please
>> note that the devnode isn't marked unregistered until the end in
>> media_device_unregister().
> 
> I guess the call to:
> 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
> 
> IMO, This should be, instead, at media_devnode_unregister().
> 
> Then, we can change the logic at media_devnode_unregister() to:
> 
> void media_devnode_unregister(struct media_devnode *mdev)
> {
> 	mutex_lock(&media_devnode_lock);
> 
> 	/* Check if mdev was ever registered at all */
> 	if (!media_devnode_is_registered(mdev)) {
> 		mutex_unlock(&media_devnode_lock);
> 		return;
> 	}
> 
> 	clear_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
> 	mutex_unlock(&media_devnode_lock);
> 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
> 	device_unregister(&mdev->dev);
> }
> 
> This sounds enough to avoid device_unregister() or device_remove_file()
> to be called twice.
> 

I can give it a try. There might other problems that could
result from media device being a devres in this case. The
last put_device on the usbdev parent device (media device
is created as devres for this), all device resources get
released. That might have to be solved in a different way.

For now I will see if your solution works.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
