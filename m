From: Jean-Michel Hautbois <jean-michel.hautbois-JiVWUdsMzBtWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] [media] media.h: let be clear that tuners need to use connectors
Date: Sun, 10 Jan 2016 19:01:27 +0100
Message-ID: <CAH-u=83N53gzxGgXZbRAF0aJb_j8Bv0gRLCp6dQwxDuBO90yPA@mail.gmail.com>
References: <16cd172bc9cec7ce438df95c142d2219998e32fe.1449867690.git.mchehab@osg.samsung.com>
 <1667088.5VvxRK5I9C@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1667088.5VvxRK5I9C@avalon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

2016-01-10 16:30 GMT+01:00 Laurent Pinchart <laurent.pinchart@ideasonbo=
ard.com>:
> Hi Mauro,
>
> Thank you for the patch.
>
> On Friday 11 December 2015 19:01:31 Mauro Carvalho Chehab wrote:
>> The V4L2 core won't be adding connectors to the tuners and other
>> entities that need them. Let it be clear.
>>
>> Suggested-by: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> ---
>>  include/uapi/linux/media.h | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>> index 86f9753e5c03..cacfceb0d81d 100644
>> --- a/include/uapi/linux/media.h
>> +++ b/include/uapi/linux/media.h
>> @@ -74,10 +74,11 @@ struct media_device_info {
>>  /*
>>   * Connectors
>>   */
>> +/* It is a responsibility of the entity drivers to add connectors a=
nd links
>
> Do you mean entity drivers or "master/bridge" (for lack of a better w=
ord)
> drivers ?

Is is the responsability of the media device I think...

> I don't think it should be the responsibility of the tuner driver to
> create connectors, as the tuner driver shouldn't know about the entit=
ies
> surrounding it.
>
>> */ #define MEDIA_ENT_F_CONN_RF                (MEDIA_ENT_F_BASE + 21=
)
>>  #define MEDIA_ENT_F_CONN_SVIDEO              (MEDIA_ENT_F_BASE + 22=
)
>>  #define MEDIA_ENT_F_CONN_COMPOSITE   (MEDIA_ENT_F_BASE + 23)
>> -     /* For internal test signal generators and other debug connect=
ors */
>> +/* For internal test signal generators and other debug connectors *=
/
>>  #define MEDIA_ENT_F_CONN_TEST                (MEDIA_ENT_F_BASE + 24=
)
>>
>>  /*
>> @@ -105,6 +106,10 @@ struct media_device_info {
>>  #define MEDIA_ENT_F_FLASH            (MEDIA_ENT_F_OLD_SUBDEV_BASE +=
 2)
>>  #define MEDIA_ENT_F_LENS             (MEDIA_ENT_F_OLD_SUBDEV_BASE +=
 3)
>>  #define MEDIA_ENT_F_ATV_DECODER              (MEDIA_ENT_F_OLD_SUBDE=
V_BASE + 4)
>> +/*
>> + * It is a responsibility of the entity drivers to add connectors a=
nd links
>> + *   for the tuner entities.
>> + */
>>  #define MEDIA_ENT_F_TUNER            (MEDIA_ENT_F_OLD_SUBDEV_BASE +=
 5)
>>
>>  #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN      MEDIA_ENT_F_OLD_SUBDEV=
_BASE
>
> --
> Regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
<div id=3D"DDB4FAA8-2DD7-40BB-A1B8-4E2AA1F9FDF2"><table
style=3D"border-top: 1px solid #aaabb6; margin-top: 30px;">
	<tr>
		<td style=3D"width: 105px; padding-top: 15px;">
			<a href=3D"https://www.avast.com/sig-email?utm_medium=3Demail&utm_so=
urce=3Dlink&utm_campaign=3Dsig-email&utm_content=3Dwebmail"
target=3D"_blank"><img
src=3D"https://ipmcdn.avast.com/images/logo-avast-v1.png" style=3D"widt=
h:
90px; height:33px;"/></a>
		</td>
		<td style=3D"width: 470px; padding-top: 20px; color: #41424e;
font-size: 13px; font-family: Arial, Helvetica, sans-serif;
line-height: 18px;">Cet e-mail a =C3=A9t=C3=A9 envoy=C3=A9 depuis un or=
dinateur
prot=C3=A9g=C3=A9 par Avast. <br /><a
href=3D"https://www.avast.com/sig-email?utm_medium=3Demail&utm_source=3D=
link&utm_campaign=3Dsig-email&utm_content=3Dwebmail"
target=3D"_blank" style=3D"color: #4453ea;">www.avast.com</a> 		</td>
	</tr>
</table>
<a href=3D"#DDB4FAA8-2DD7-40BB-A1B8-4E2AA1F9FDF2" width=3D"1" height=3D=
"1"></a></div>
