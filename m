From: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: Re: [PATCH v8 2/3] dt-bindings: video: Add for rockchip display subsytem
Date: Tue, 30 Sep 2014 16:19:03 +0800
Message-ID: <542A6777.5070105@rock-chips.com>
References: <1412057386-19375-1-git-send-email-mark.yao@rock-chips.com> <1412057659-19483-1-git-send-email-mark.yao@rock-chips.com> <20140930081020.GE24667@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140930081020.GE24667-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cf@rock-c
List-Id: linux-api@vger.kernel.org

On 2014=E5=B9=B409=E6=9C=8830=E6=97=A5 16:10, Daniel Vetter wrote:
> On Tue, Sep 30, 2014 at 02:14:19PM +0800, Mark Yao wrote:
>> From: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>>
>> This add a display subsystem comprise the all display interface node=
s.
>>
>> Signed-off-by: Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> Signed-off-by: Daniel Kurtz <djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> Acked-by: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
>> Reviewed-by: Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Just a quick clarification: My ack was only about the drm driver itse=
lf, I
> try really hard to stay away from DT insanity ;-) So please drop my a=
ck
> from these two patches.
>
> Aside: DT patches need to go through a special process and you must c=
c dt
> maintainers and mailing lists. Your patch seems to lack this, which a=
faiui
> is a blocker for merging the driver.
>
> Thanks, Daniel
Oh, I'm sorry, I will drop it soon.
>> ---
>> Changes in v2:
>> - add DRM master device node to list all display nodes that comprise
>>    the graphics subsystem.
>>
>> Changes in v3: None
>>
>> Changes in v4: None
>>
>> Changes in v5: None
>>
>> Changes in v6: None
>>
>> Changes in v7: None
>>
>> Changes in v8: None
>>
>>   .../devicetree/bindings/video/rockchip-drm.txt     |   19 ++++++++=
+++++++++++
>>   1 file changed, 19 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/video/rockchi=
p-drm.txt
>>
>> diff --git a/Documentation/devicetree/bindings/video/rockchip-drm.tx=
t b/Documentation/devicetree/bindings/video/rockchip-drm.txt
>> new file mode 100644
>> index 0000000..7fff582
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/video/rockchip-drm.txt
>> @@ -0,0 +1,19 @@
>> +Rockchip DRM master device
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +The Rockchip DRM master device is a virtual device needed to list a=
ll
>> +vop devices or other display interface nodes that comprise the
>> +graphics subsystem.
>> +
>> +Required properties:
>> +- compatible: Should be "rockchip,display-subsystem"
>> +- ports: Should contain a list of phandles pointing to display inte=
rface port
>> +  of vop devices. vop definitions as defined in
>> +  Documentation/devicetree/bindings/video/rockchip-vop.txt
>> +
>> +example:
>> +
>> +display-subsystem {
>> +	compatible =3D "rockchip,display-subsystem";
>> +	ports =3D <&vopl_out>, <&vopb_out>;
>> +};
>> --=20
>> 1.7.9.5
>>
>>


--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
