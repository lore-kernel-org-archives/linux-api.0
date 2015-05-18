From: Robert Bragg <robert@sixbynine.org>
Subject: Re: [RFC PATCH 07/11] drm/i915: Expose PMU for
 Observation Architecture
Date: Mon, 18 May 2015 17:21:14 +0100
Message-ID: <CAMou1-1OsNmxy177KaHQewDXoAjT0sSvhctJ4E7sTjL_Sw-Big@mail.gmail.com>
References: <1431008154-6833-1-git-send-email-robert@sixbynine.org>
 <1431008154-6833-8-git-send-email-robert@sixbynine.org>
 <20150507143639.GY22099@nuc-i3427.alporthouse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0124365893=="
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20150507143639.GY22099@nuc-i3427.alporthouse.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@intel.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Chris Wilson <chris@chris-wilson.co.uk>, Arnaldo Carvalho de Melo <acme@kernel.org>, intel-gfx@lists.freedesktop.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

--===============0124365893==
Content-Type: multipart/alternative; boundary=047d7bb03eb06e761f05165d9639

--047d7bb03eb06e761f05165d9639
Content-Type: text/plain; charset=UTF-8

On 7 May 2015 15:37, "Chris Wilson" <chris@chris-wilson.co.uk> wrote:
>
> On Thu, May 07, 2015 at 03:15:50PM +0100, Robert Bragg wrote:
> > +static int init_oa_buffer(struct perf_event *event)
> > +{
> > +     struct drm_i915_private *dev_priv =
> > +             container_of(event->pmu, typeof(*dev_priv), oa_pmu.pmu);
> > +     struct drm_i915_gem_object *bo;
> > +     int ret;
> > +
> > +     BUG_ON(!IS_HASWELL(dev_priv->dev));
> > +     BUG_ON(!mutex_is_locked(&dev_priv->dev->struct_mutex));
> > +     BUG_ON(dev_priv->oa_pmu.oa_buffer.obj);
> > +
> > +     spin_lock_init(&dev_priv->oa_pmu.oa_buffer.flush_lock);
> > +
> > +     /* NB: We over allocate the OA buffer due to the way raw sample
data
> > +      * gets copied from the gpu mapped circular buffer into the perf
> > +      * circular buffer so that only one copy is required.
> > +      *
> > +      * For each perf sample (raw->size + 4) needs to be 8 byte
aligned,
> > +      * where the 4 corresponds to the 32bit raw->size member that's
> > +      * added to the sample header that userspace sees.
> > +      *
> > +      * Due to the + 4 for the size member: when we copy a report to
the
> > +      * userspace facing perf buffer we always copy an additional 4
bytes
> > +      * from the subsequent report to make up for the miss alignment,
but
> > +      * when a report is at the end of the gpu mapped buffer we need to
> > +      * read 4 bytes past the end of the buffer.
> > +      */
> > +     bo = i915_gem_alloc_object(dev_priv->dev, OA_BUFFER_SIZE +
PAGE_SIZE);
> > +     if (bo == NULL) {
> > +             DRM_ERROR("Failed to allocate OA buffer\n");
> > +             ret = -ENOMEM;
> > +             goto err;
> > +     }
> > +     dev_priv->oa_pmu.oa_buffer.obj = bo;
> > +
> > +     ret = i915_gem_object_set_cache_level(bo, I915_CACHE_LLC);
> > +     if (ret)
> > +             goto err_unref;
> > +
> > +     /* PreHSW required 512K alignment, HSW requires 16M */
> > +     ret = i915_gem_obj_ggtt_pin(bo, SZ_16M, 0);
> > +     if (ret)
> > +             goto err_unref;
> > +
> > +     dev_priv->oa_pmu.oa_buffer.gtt_offset =
i915_gem_obj_ggtt_offset(bo);
> > +     dev_priv->oa_pmu.oa_buffer.addr = vmap_oa_buffer(bo);
>
> You can look forward to both i915_gem_object_create_internal() and
> i915_gem_object_pin_vmap()

Okey, will do, thanks.

>
> > +
> > +     /* Pre-DevBDW: OABUFFER must be set with counters off,
> > +      * before OASTATUS1, but after OASTATUS2 */
> > +     I915_WRITE(GEN7_OASTATUS2, dev_priv->oa_pmu.oa_buffer.gtt_offset |
> > +                GEN7_OASTATUS2_GGTT); /* head */
> > +     I915_WRITE(GEN7_OABUFFER, dev_priv->oa_pmu.oa_buffer.gtt_offset);
> > +     I915_WRITE(GEN7_OASTATUS1, dev_priv->oa_pmu.oa_buffer.gtt_offset |
> > +                GEN7_OASTATUS1_OABUFFER_SIZE_16M); /* tail */
> > +
> > +     DRM_DEBUG_DRIVER("OA Buffer initialized, gtt offset = 0x%x, vaddr
= %p",
> > +                      dev_priv->oa_pmu.oa_buffer.gtt_offset,
> > +                      dev_priv->oa_pmu.oa_buffer.addr);
> > +
> > +     return 0;
> > +
> > +err_unref:
> > +     drm_gem_object_unreference_unlocked(&bo->base);
>
> But what I really what to say was:
> mutex deadlock^^^

Yikes, I've pushed an updated patch addressing this and can reply with a
new patch here in a bit.

Thanks,
- Robert


> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre

--047d7bb03eb06e761f05165d9639
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p dir=3D"ltr"><br>
On 7 May 2015 15:37, &quot;Chris Wilson&quot; &lt;<a href=3D"mailto:chris@c=
hris-wilson.co.uk" target=3D"_blank">chris@chris-wilson.co.uk</a>&gt; wrote=
:<br>
&gt;<br>
&gt; On Thu, May 07, 2015 at 03:15:50PM +0100, Robert Bragg wrote:<br>
&gt; &gt; +static int init_oa_buffer(struct perf_event *event)<br>
&gt; &gt; +{<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0struct drm_i915_private *dev_priv =3D<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0container_of(eve=
nt-&gt;pmu, typeof(*dev_priv), oa_pmu.pmu);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0struct drm_i915_gem_object *bo;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0int ret;<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0BUG_ON(!IS_HASWELL(dev_priv-&gt;dev));<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0BUG_ON(!mutex_is_locked(&amp;dev_priv-&gt;de=
v-&gt;struct_mutex));<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0BUG_ON(dev_priv-&gt;oa_pmu.oa_buffer.obj);<b=
r>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0spin_lock_init(&amp;dev_priv-&gt;oa_pmu.oa_b=
uffer.flush_lock);<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0/* NB: We over allocate the OA buffer due to=
 the way raw sample data<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 * gets copied from the gpu mapped circular =
buffer into the perf<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 * circular buffer so that only one copy is =
required.<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 *<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 * For each perf sample (raw-&gt;size + 4) n=
eeds to be 8 byte aligned,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 * where the 4 corresponds to the 32bit raw-=
&gt;size member that&#39;s<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 * added to the sample header that userspace=
 sees.<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 *<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 * Due to the + 4 for the size member: when =
we copy a report to the<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 * userspace facing perf buffer we always co=
py an additional 4 bytes<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 * from the subsequent report to make up for=
 the miss alignment, but<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 * when a report is at the end of the gpu ma=
pped buffer we need to<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 * read 4 bytes past the end of the buffer.<=
br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0bo =3D i915_gem_alloc_object(dev_priv-&gt;de=
v, OA_BUFFER_SIZE + PAGE_SIZE);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0if (bo =3D=3D NULL) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DRM_ERROR(&quot;=
Failed to allocate OA buffer\n&quot;);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -ENOMEM;=
<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto err;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0dev_priv-&gt;oa_pmu.oa_buffer.obj =3D bo;<br=
>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0ret =3D i915_gem_object_set_cache_level(bo, =
I915_CACHE_LLC);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0if (ret)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto err_unref;<=
br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0/* PreHSW required 512K alignment, HSW requi=
res 16M */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0ret =3D i915_gem_obj_ggtt_pin(bo, SZ_16M, 0)=
;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0if (ret)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto err_unref;<=
br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0dev_priv-&gt;oa_pmu.oa_buffer.gtt_offset =3D=
 i915_gem_obj_ggtt_offset(bo);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0dev_priv-&gt;oa_pmu.oa_buffer.addr =3D vmap_=
oa_buffer(bo);<br>
&gt;<br>
&gt; You can look forward to both i915_gem_object_create_internal() and<br>
&gt; i915_gem_object_pin_vmap()</p>
<p dir=3D"ltr">Okey, will do, thanks.</p>
<p dir=3D"ltr">&gt;<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0/* Pre-DevBDW: OABUFFER must be set with cou=
nters off,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 * before OASTATUS1, but after OASTATUS2 */<=
br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0I915_WRITE(GEN7_OASTATUS2, dev_priv-&gt;oa_p=
mu.oa_buffer.gtt_offset |<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GEN7_OAS=
TATUS2_GGTT); /* head */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0I915_WRITE(GEN7_OABUFFER, dev_priv-&gt;oa_pm=
u.oa_buffer.gtt_offset);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0I915_WRITE(GEN7_OASTATUS1, dev_priv-&gt;oa_p=
mu.oa_buffer.gtt_offset |<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GEN7_OAS=
TATUS1_OABUFFER_SIZE_16M); /* tail */<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0DRM_DEBUG_DRIVER(&quot;OA Buffer initialized=
, gtt offset =3D 0x%x, vaddr =3D %p&quot;,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 dev_priv-&gt;oa_pmu.oa_buffer.gtt_offset,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 dev_priv-&gt;oa_pmu.oa_buffer.addr);<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; &gt; +<br>
&gt; &gt; +err_unref:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0drm_gem_object_unreference_unlocked(&amp;bo-=
&gt;base);<br>
&gt;<br>
&gt; But what I really what to say was:<br>
&gt; mutex deadlock^^^</p>
<p dir=3D"ltr">Yikes, I&#39;ve pushed an updated patch addressing this and =
can reply with a new patch here in a bit.</p>
<p dir=3D"ltr">Thanks,<br>
- Robert</p><p dir=3D"ltr"><br>
&gt; -Chris<br>
&gt;<br>
&gt; --<br>
&gt; Chris Wilson, Intel Open Source Technology Centre<br>
</p>
</div>

--047d7bb03eb06e761f05165d9639--

--===============0124365893==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4
IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0
cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZngK

--===============0124365893==--
