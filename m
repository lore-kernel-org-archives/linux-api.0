From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 13/31] media: au0828 fix au0828_create_media_graph()
 entity checks
Date: Thu, 28 Jan 2016 11:57:11 -0700
Message-ID: <56AA6487.5040300@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <ab77ed92dafb05b262a33fcd827f35ad8be3d619.1452105878.git.shuahkh@osg.samsung.com>
 <20160128133728.5fa54fa3@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160128133728.5fa54fa3-+RedX5hVuTR+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

On 01/28/2016 08:37 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  6 Jan 2016 13:27:02 -0700
> Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:
> 
>> au0828_create_media_graph() doesn't do any checks to determine,
>> if vbi_dev, vdev, and input entities have been registered prior
>> to creating pad links. Checking graph_obj.mdev field works as
>> the graph_obj.mdev field gets initialized in the entity register
>> interface. Fix it to check graph_obj.mdev field before creating
>> pad links.
> 
>>
>> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> ---
>>  drivers/media/usb/au0828/au0828-core.c | 27 +++++++++++++++++----------
>>  1 file changed, 17 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
>> index f46fb43..8ef7c71 100644
>> --- a/drivers/media/usb/au0828/au0828-core.c
>> +++ b/drivers/media/usb/au0828/au0828-core.c
>> @@ -291,20 +291,27 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>>  		if (ret)
>>  			return ret;
>>  	}
>> -	ret = media_create_pad_link(decoder, AU8522_PAD_VID_OUT,
>> -				    &dev->vdev.entity, 0,
>> -				    MEDIA_LNK_FL_ENABLED);
>> -	if (ret)
>> -		return ret;
>> -	ret = media_create_pad_link(decoder, AU8522_PAD_VBI_OUT,
>> -				    &dev->vbi_dev.entity, 0,
>> -				    MEDIA_LNK_FL_ENABLED);
>> -	if (ret)
>> -		return ret;
>> +	if (dev->vdev.entity.graph_obj.mdev) {
>> +		ret = media_create_pad_link(decoder, AU8522_PAD_VID_OUT,
>> +					    &dev->vdev.entity, 0,
>> +					    MEDIA_LNK_FL_ENABLED);
>> +		if (ret)
>> +			return ret;
>> +	}
> 
> Those new if() doesn't look right. We can't continue if the entities
> weren't registered, as the graph would have troubles. The logic should
> ensure that the entities will always be created before running 
> au0828_create_media_graph(). If this is not the case, some async
> logic is needed to ensure that.

There have been some changes in au0828 media init and
register sequence in 4.5-rc1. wau0828 does its graph
creation before it registers media_device.

I needed these checks before this above. It looks
like I might have simply rebased my patch over
without taking this change into account. I will
try without these checks.

Async method is already in place for snd-usb-audio
part of the graph. Please see patch 20 in the series.

thanks,
-- Shuah

> 
>> +	if (dev->vbi_dev.entity.graph_obj.mdev) {
>> +		ret = media_create_pad_link(decoder, AU8522_PAD_VBI_OUT,
>> +					    &dev->vbi_dev.entity, 0,
>> +					    MEDIA_LNK_FL_ENABLED);
>> +		if (ret)
>> +			return ret;
>> +	}
>>  
>>  	for (i = 0; i < AU0828_MAX_INPUT; i++) {
>>  		struct media_entity *ent = &dev->input_ent[i];
>>  
>> +		if (!ent->graph_obj.mdev)
>> +			continue;
>> +
>>  		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
>>  			break;
>>  


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
