From: Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH 3/5] update virtio gpu driver: add 3d/virgl support
Date: Thu, 10 Sep 2015 20:32:30 +1000
Message-ID: <CAPM=9txn4yGwQg+ZdL5Z9ZtFzSnw3QfUtAWT5mSXgB_JL00pYA@mail.gmail.com>
References: <1441798946-26233-1-git-send-email-kraxel@redhat.com>
 <1441798946-26233-4-git-send-email-kraxel@redhat.com>
 <CACvgo51Y7j0ka46Rfq2eBvXzP4q8Jc6x4j-JrYHDLkH6_xOh7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1883576346=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <CACvgo51Y7j0ka46Rfq2eBvXzP4q8Jc6x4j-JrYHDLkH6_xOh7w@mail.gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Emil Velikov <emil.l.velikov@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, ML dri-devel <dri-devel@lists.freedesktop.org>, "open list:VIRTIO GPU DRIVER" <virtualization@lists.linux-foundation.org>, Dave Airlie <airlied@redhat.com>
List-Id: linux-api@vger.kernel.org

--===============1883576346==
Content-Type: multipart/alternative; boundary=089e0160b5eed13908051f621dba

--089e0160b5eed13908051f621dba
Content-Type: text/plain; charset=UTF-8

> > --- /dev/null
> > +++ b/include/uapi/drm/virtgpu_drm.h
> > @@ -0,0 +1,163 @@
>
> > +
> > +struct drm_virtgpu_3d_box {
> > +       uint32_t x, y, z;
> > +       uint32_t w, h, d;
> > +};
> > +
> There was a similar case (multiple variables declared on a single
> line) in drm core that caused confusion and we broke the 32bit compat.
> I thought I mention it - not advocating for/against the above declaration.


probably should put some newlines alright,

>

> > +struct drm_virtgpu_3d_transfer_to_host {
> > +       uint32_t bo_handle;
> > +       struct drm_virtgpu_3d_box box;
> > +       uint32_t level;
> > +       uint32_t offset;
> > +};
> > +
> > +struct drm_virtgpu_3d_transfer_from_host {
> > +       uint32_t bo_handle;
> > +       struct drm_virtgpu_3d_box box;
> > +       uint32_t level;
> > +       uint32_t offset;
> > +};
> > +
> Afaics these seems to be used by the ioctls. If so the current
> declarations are not 32bit compat safe. Things will also go badly if
> you consider expanding struct drm_virtgpu_3d_box in the distant
> future. A u32 pad after bo_handle and a 'pointer' to struct

I'm curious what you think we can add to a 3d box.

So this one is fine, no need to align it either I don't think, though I
should confirm that.

Maybe for safety we can pull the other uint32_t above the box.

Dave.

--089e0160b5eed13908051f621dba
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p dir=3D"ltr">&gt; &gt; --- /dev/null<br>
&gt; &gt; +++ b/include/uapi/drm/virtgpu_drm.h<br>
&gt; &gt; @@ -0,0 +1,163 @@<br>
&gt;<br>
&gt; &gt; +<br>
&gt; &gt; +struct drm_virtgpu_3d_box {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t x, y, z;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t w, h, d;<br>
&gt; &gt; +};<br>
&gt; &gt; +<br>
&gt; There was a similar case (multiple variables declared on a single<br>
&gt; line) in drm core that caused confusion and we broke the 32bit compat.=
<br>
&gt; I thought I mention it - not advocating for/against the above declarat=
ion.</p><p dir=3D"ltr"><br></p><p>probably should put some newlines alright=
,</p><p>&gt;<br></p><p dir=3D"ltr">
&gt; &gt; +struct drm_virtgpu_3d_transfer_to_host {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t bo_handle;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0struct drm_virtgpu_3d_box box;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t level;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t offset;<br>
&gt; &gt; +};<br>
&gt; &gt; +<br>
&gt; &gt; +struct drm_virtgpu_3d_transfer_from_host {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t bo_handle;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0struct drm_virtgpu_3d_box box;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t level;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t offset;<br>
&gt; &gt; +};<br>
&gt; &gt; +<br>
&gt; Afaics these seems to be used by the ioctls. If so the current<br>
&gt; declarations are not 32bit compat safe. Things will also go badly if<b=
r>
&gt; you consider expanding struct drm_virtgpu_3d_box in the distant<br>
&gt; future. A u32 pad after bo_handle and a &#39;pointer&#39; to struct<br=
>
</p><p dir=3D"ltr">I&#39;m curious what you think we can add to a 3d box.</=
p><p>So this one is fine, no need to align it either I don&#39;t think, tho=
ugh I should confirm that.</p><p>Maybe for safety we can pull the other uin=
t32_t above the box.</p><p>Dave.<br></p></div>

--089e0160b5eed13908051f621dba--

--===============1883576346==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0
cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK

--===============1883576346==--
