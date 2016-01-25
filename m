From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4 0/2] new control V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME
Date: Mon, 25 Jan 2016 09:57:53 +0100
Message-ID: <56A5E391.8050505@xs4all.nl>
References: <1453187230-97231-1-git-send-email-wuchengli@chromium.org>
 <CAOMLVLh7EnMgVfzV7JQy6DSKSaanqHn5kNkTLVrbTCihjphzYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOMLVLh7EnMgVfzV7JQy6DSKSaanqHn5kNkTLVrbTCihjphzYA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?V3UtQ2hlbmcgTGkgKOadjuWLmeiqoCk=?= <wuchengli@chromium.org>
Cc: pawel@osciak.com, mchehab@osg.samsung.com, k.debski@samsung.com, Antti Palosaari <crope@iki.fi>, Masanari Iida <standby24x7@gmail.com>, Nicolas Dufresne <nicolas.dufresne@collabora.com>, Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>, ao2@ao2.it, bparrot@ti.com, Kyungmin Park <kyungmin.park@samsung.com>, jtp.park@samsung.com, linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Tiffany Lin <tiffany.lin@mediatek.com>, Daniel Kurtz <djkurtz@chromium.org>
List-Id: linux-api@vger.kernel.org

On 01/25/2016 05:46 AM, Wu-Cheng Li (=E6=9D=8E=E5=8B=99=E8=AA=A0) wrote=
:
> Hi Hans,
> Can you look at the patch again? I've changed the name from
> V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME to
> V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME. Thanks.

Looks good to me. I'm planning to make a pull request for this once v4.=
5-rc1 is
merged into our media_tree repo.

Regards,

	Hans

>=20
> Wu-Cheng
>=20
> On Tue, Jan 19, 2016 at 3:07 PM, Wu-Cheng Li <wuchengli@chromium.org>=
 wrote:
>> v4 changes:
>> - Change the name to V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.
>> - Add commit message to s5p-mfc patch.
>>
>> Wu-Cheng Li (2):
>>   v4l: add V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.
>>   s5p-mfc: add the support of V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.
>>
>>  Documentation/DocBook/media/v4l/controls.xml |  8 ++++++++
>>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 12 ++++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
>>  include/uapi/linux/v4l2-controls.h           |  1 +
>>  4 files changed, 23 insertions(+)
>>
>> --
>> 2.6.0.rc2.230.g3dd15c0
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
