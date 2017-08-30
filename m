From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [3/7,media] dvb: don't use 'time_t' in event ioctl
Date: Wed, 30 Aug 2017 22:25:01 +0200
Message-ID: <CAK8P3a3+ng+kNNH4C2yG1hJf6DUu_sYb5dC388XGPigePw1uAg@mail.gmail.com>
References: <1442332148-488079-4-git-send-email-arnd@arndb.de> <20170828153243.GA27121@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170828153243.GA27121@asgard.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Syromiatnikov <esyr@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux API <linux-api@vger.kernel.org>, "moderated list:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES" <linux-samsung-soc@vger.kernel.org>, "Dmitry V. Levin" <ldv@altlinux.org>, Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
List-Id: linux-api@vger.kernel.org

>> diff --git a/include/uapi/linux/dvb/video.h b/include/uapi/linux/dvb/video.h
>> index d3d14a59d2d5..6c7f9298d7c2 100644
>> --- a/include/uapi/linux/dvb/video.h
>> +++ b/include/uapi/linux/dvb/video.h
>> @@ -135,7 +135,8 @@ struct video_event {
>>  #define VIDEO_EVENT_FRAME_RATE_CHANGED       2
>>  #define VIDEO_EVENT_DECODER_STOPPED  3
>>  #define VIDEO_EVENT_VSYNC            4
>> -     __kernel_time_t timestamp;
>> +     /* unused, make sure to use atomic time for y2038 if it ever gets used */
>> +     long timestamp;
>
> This change breaks x32 ABI (and possibly MIPS n32 ABI), as __kernel_time_t
> there is 64 bit already:
> https://sourceforge.net/p/strace/mailman/message/36015326/
>
> Note the change in structure size from 0x20 to 0x14 for VIDEO_GET_EVENT
> command in linux/x32/ioctls_inc0.h.

Are you sure it worked before the change? I don't see any handler in the kernel
for the x32 compat ioctl call here, only the compat_video_event handling, so
my guess is that the change unintentionally fixes x32.

         Arnd
