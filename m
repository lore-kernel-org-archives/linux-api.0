From: Daniel Stone <daniel@fooishbar.org>
Subject: Re: [PATCH] Add virtio gpu driver.
Date: Wed, 25 Mar 2015 05:47:08 +0000
Message-ID: <CAPj87rOzUyF2U5wj=_w9zWXUgtLMnnbqjUd3Zh_-VqweEfGXJQ@mail.gmail.com>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
 <CAPj87rN4pXHukDRD-e=ZrO1hcts04cSz1Hr9TNAgicGVWE5_-Q@mail.gmail.com>
 <CAPM=9tyM9AxX-RHhbO-LK+LTyQC6YjwW67pZM1XjbL35+counA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1338701072=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <CAPM=9tyM9AxX-RHhbO-LK+LTyQC6YjwW67pZM1XjbL35+counA@mail.gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Dave Airlie <airlied@gmail.com>
Cc: "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, "Michael S. Tsirkin" <mst@redhat.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, "open list:VIRTIO CORE, NET..." <virtualization@lists.linux-foundation.org>, Dave Airlie <airlied@redhat.com>
List-Id: linux-api@vger.kernel.org

--===============1338701072==
Content-Type: multipart/alternative; boundary=e89a8f3ba5e31278bf0512166e53

--e89a8f3ba5e31278bf0512166e53
Content-Type: text/plain; charset=UTF-8

Hi,

On Wednesday, March 25, 2015, Dave Airlie <airlied@gmail.com> wrote:

> On 25 March 2015 at 08:50, Daniel Stone <daniel@fooishbar.org
> <javascript:;>> wrote:
> > I'm not going to lie, I was really hoping the 5th (?) GPU option for
> > Qemu would support pageflipping. Daniel's comment about conversion to
> > atomic is relevant, but: do you have a mechanism which allows you to
> > post updates (e.g. 'start displaying this buffer now please') that
> > allows you to get events back when they have actually been displayed?
>
> Page flip is implemented in a later patch,
>
>
> https://www.kraxel.org/cgit/linux/commit/?h=virtio-gpu&id=1e167e8e964f8e08100d315dd354cc0a4b090841
>
> Since its a long way from an actual display, finding out when
> something is actually displayed is hard,
> but when we've posted it to the frontbuffer should be fine.
>

Oh nice. 100% exact timings aren't critical; it's more just having
something to gate to 60fps that we can actually drive Weston's repaint loop
off, as that's (not unreasonably) driven by pageflip events.

Cheers,
Daniel

--e89a8f3ba5e31278bf0512166e53
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>On Wednesday, March 25, 2015, Dave Airlie &lt;<a href=3D"mailto:=
airlied@gmail.com">airlied@gmail.com</a>&gt; wrote:<br><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex">On 25 March 2015 at 08:50, Daniel Stone &lt;<a href=3D"javascrip=
t:;" onclick=3D"_e(event, &#39;cvml&#39;, &#39;daniel@fooishbar.org&#39;)">=
daniel@fooishbar.org</a>&gt; wrote:<br>
&gt; I&#39;m not going to lie, I was really hoping the 5th (?) GPU option f=
or<br>
&gt; Qemu would support pageflipping. Daniel&#39;s comment about conversion=
 to<br>
&gt; atomic is relevant, but: do you have a mechanism which allows you to<b=
r>
&gt; post updates (e.g. &#39;start displaying this buffer now please&#39;) =
that<br>
&gt; allows you to get events back when they have actually been displayed?<=
br>
<br>
Page flip is implemented in a later patch,<br>
<br>
<a href=3D"https://www.kraxel.org/cgit/linux/commit/?h=3Dvirtio-gpu&amp;id=
=3D1e167e8e964f8e08100d315dd354cc0a4b090841" target=3D"_blank">https://www.=
kraxel.org/cgit/linux/commit/?h=3Dvirtio-gpu&amp;id=3D1e167e8e964f8e08100d3=
15dd354cc0a4b090841</a><br>
<br>
Since its a long way from an actual display, finding out when<br>
something is actually displayed is hard,<br>
but when we&#39;ve posted it to the frontbuffer should be fine.<br>
</blockquote><div><br></div><div>Oh nice. 100% exact timings aren&#39;t cri=
tical; it&#39;s more just having something to gate to 60fps that we can act=
ually drive Weston&#39;s repaint=C2=A0loop off, as that&#39;s (not unreason=
ably) driven by pageflip events.</div><div><br></div><div>Cheers,</div><div=
>Daniel<span></span></div>

--e89a8f3ba5e31278bf0512166e53--

--===============1338701072==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0
cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK

--===============1338701072==--
