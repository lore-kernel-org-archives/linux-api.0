From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@gmail.com>
Subject: Re: [PATCH v2 3/4] Add virtio gpu driver.
Date: Thu, 2 Apr 2015 17:52:40 +0200
Message-ID: <CAJ+F1CK3ibbn8e1-rUY4OUJuaCt_=JmuT00Fqx4YDD9M5zJv=A@mail.gmail.com>
References: <1427894130-14228-1-git-send-email-kraxel@redhat.com>
 <1427894130-14228-4-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0340416082=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1427894130-14228-4-git-send-email-kraxel@redhat.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, "Michael S. Tsirkin" <mst@redhat.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org, "open list:VIRTIO CORE, NET..." <virtualization@lists.linux-foundation.org>, David Airlie <airlied@redhat.com>
List-Id: linux-api@vger.kernel.org

--===============0340416082==
Content-Type: multipart/alternative; boundary=001a11333434585bc10512bfd277

--001a11333434585bc10512bfd277
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Gerd

While doing some testing with your brance, I reached that:

On Wed, Apr 1, 2015 at 3:15 PM, Gerd Hoffmann <kraxel@redhat.com> wrote:

> +#define MAX_INLINE_CMD_SIZE   96
>

[  750.446449] kernel BUG at drivers/gpu/drm/virtio/virtgpu_vq.c:132!
[  750.447005] Call Trace:
[  750.447005]  [<ffffffffa00f3592>] virtio_gpu_alloc_cmd+0x22/0x50
[virtio_gpu]
[  750.447005]  [<ffffffffa00f4580>]
virtio_gpu_cmd_context_create+0x30/0xa0 [virtio_gpu]


struct virtio_gpu_ctx_create {
        struct virtio_gpu_ctrl_hdr hdr;
        __le32 nlen;
        __le32 padding;
        char debug_name[64];
};

Is actually 96 bytes.

Perhaps that condition should be changed:
+       BUG_ON(size >=3D MAX_INLINE_CMD_SIZE);

--=20
Marc-Andr=C3=A9 Lureau

--001a11333434585bc10512bfd277
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra">Hi Gerd<br><br></div><div class=
=3D"gmail_extra">While doing some testing with your brance, I reached that:=
<br><br></div><div class=3D"gmail_extra"><div class=3D"gmail_quote">On Wed,=
 Apr 1, 2015 at 3:15 PM, Gerd Hoffmann <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:kraxel@redhat.com" target=3D"_blank">kraxel@redhat.com</a>&gt;</span> w=
rote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div id=3D":2bb"=
 class=3D"" style=3D"overflow:hidden">
+#define <span class=3D"">MAX_INLINE_CMD_SIZE</span>=C2=A0 =C2=A096</div></=
blockquote></div><br>[=C2=A0 750.446449] kernel BUG at drivers/gpu/drm/virt=
io/virtgpu_vq.c:132!<br>[=C2=A0 750.447005] Call Trace:<br>[=C2=A0 750.4470=
05]=C2=A0 [&lt;ffffffffa00f3592&gt;] virtio_gpu_alloc_cmd+0x22/0x50 [virtio=
_gpu]<br>[=C2=A0 750.447005]=C2=A0 [&lt;ffffffffa00f4580&gt;] virtio_gpu_cm=
d_context_create+0x30/0xa0 [virtio_gpu]<br><br><br clear=3D"all"></div><div=
 class=3D"gmail_extra">struct virtio_gpu_ctx_create {<br>=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 struct virtio_gpu_ctrl_hdr hdr;<br>=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le32 nlen;<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 __le32 padding;<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
char debug_name[64];<br>};<br><br></div><div class=3D"gmail_extra">Is actua=
lly 96 bytes.<br><br>Perhaps that condition should be changed:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(<span class=3D"">size</span> &gt;=3D <sp=
an class=3D"">MAX_INLINE_CMD_SIZE</span>);<br><br></div><div class=3D"gmail=
_extra">-- <br><div class=3D"gmail_signature">Marc-Andr=C3=A9 Lureau</div>
</div></div>

--001a11333434585bc10512bfd277--

--===============0340416082==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0
cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK

--===============0340416082==--
