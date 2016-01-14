From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH v3 2/2] s5p-mfc: add the support of
 V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME.
Date: Thu, 14 Jan 2016 18:25:26 +0100
Message-ID: <00b301d14ef0$8f51df00$adf59d00$@samsung.com>
References: <1452783007-80883-1-git-send-email-wuchengli@chromium.org>
 <1452783007-80883-3-git-send-email-wuchengli@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-reply-to: <1452783007-80883-3-git-send-email-wuchengli@chromium.org>
Content-language: pl
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: 'Wu-Cheng Li' <wuchengli@chromium.org>, pawel@osciak.com, mchehab@osg.samsung.com, hverkuil@xs4all.nl, crope@iki.fi, standby24x7@gmail.com, nicolas.dufresne@collabora.com, ricardo.ribalda@gmail.com, ao2@ao2.it, bparrot@ti.com, kyungmin.park@samsung.com, jtp.park@samsung.com
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, djkurtz@chromium.org, tiffany.lin@mediatek.com, linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

> From: Wu-Cheng Li [mailto:wuchengli@chromium.org]
> Sent: Thursday, January 14, 2016 3:50 PM
> To: pawel@osciak.com; mchehab@osg.samsung.com; hverkuil@xs4all.nl;
> k.debski@samsung.com; crope@iki.fi; standby24x7@gmail.com;
> wuchengli@chromium.org; nicolas.dufresne@collabora.com;
> ricardo.ribalda@gmail.com; ao2@ao2.it; bparrot@ti.com;
> kyungmin.park@samsung.com; jtp.park@samsung.com
> Cc: linux-media@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> api@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> tiffany.lin@mediatek.com; djkurtz@chromium.org
> Subject: [PATCH v3 2/2] s5p-mfc: add the support of
> V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME.

However simple the patch is, please do provide a commit message.
Please write something. 

Best wishes,
Kamil

> Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 0434f02..974b4c5 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -212,6 +212,14 @@ static struct mfc_control controls[] = {
>  		.menu_skip_mask = 0,
>  	},
>  	{
> +		.id = V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME,
> +		.type = V4L2_CTRL_TYPE_BUTTON,
> +		.minimum = 0,
> +		.maximum = 0,
> +		.step = 0,
> +		.default_value = 0,
> +	},
> +	{
>  		.id = V4L2_CID_MPEG_VIDEO_VBV_SIZE,
>  		.type = V4L2_CTRL_TYPE_INTEGER,
>  		.minimum = 0,
> @@ -1423,6 +1431,10 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl
*ctrl)
>  	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:
>  		ctx->force_frame_type = ctrl->val;
>  		break;
> +	case V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME:
> +		ctx->force_frame_type =
> +
> 	V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_I_FRAME;
> +		break;
>  	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:
>  		p->vbv_size = ctrl->val;
>  		break;
> --
> 2.6.0.rc2.230.g3dd15c0
