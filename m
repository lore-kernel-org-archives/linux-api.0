From: Robert Bragg <robert@sixbynine.org>
Subject: Re: [RFC 0/6] Non perf based Gen Graphics OA unit driver
Date: Wed, 30 Sep 2015 14:36:41 +0100
Message-ID: <CAMou1-1WQ5NtQtboXbZq67___ObaaT9qt_OmwUVNBdUA5b5uww@mail.gmail.com>
References: <1443537549-6905-1-git-send-email-robert@sixbynine.org>
 <20150930083027.GF9929@nuc-i3427.alporthouse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0661687681=="
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20150930083027.GF9929@nuc-i3427.alporthouse.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Chris Wilson <chris@chris-wilson.co.uk>, Robert Bragg <robert@sixbynine.org>, intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@intel.com>, Sourab Gupta <sourab.gupta@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Kan Liang <kan.liang@intel.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Zheng Yan <zheng.z.yan@intel.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt.fleming@intel.com>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

--===============0661687681==
Content-Type: multipart/alternative; boundary=001a114782847a98db0520f7060d

--001a114782847a98db0520f7060d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2015 at 9:30 AM, Chris Wilson <chris@chris-wilson.co.uk>
wrote:

> On Tue, Sep 29, 2015 at 03:39:03PM +0100, Robert Bragg wrote:
> > Updating Mesa and GPU Top to experiment with this was straightforward
> > given the similarity to the perf interface.  The main difference is tha=
t
> > it only supports forwarding metrics via read()s instead of an mmaped
> > circular buffer. As mentioned above, I think that suits this well, and
> > requires no additional copying of data. I think the userspace code has
> > ended up being a little simpler too.
>
> Did you try updating the existing perf based overlay?
>

I don't recall the overlay attempting to read OA counters, but potentially
it could be quite nice to add support - sorry I hadn't considered that so
far.

I don't believe being perf based or not will affect the effort to do this
though. The perf based driver doesn't handle OA counter normalization in
the kernel so userspace needs to be able to handle that - which is probably
the bigger effort.

Something to note here about your early pmu driver, is that it was notably
for counters that were explicitly sampled from the cpu using a hrtimer via
mmio. I think they were a better fit for the existing perf design than the
OA unit, primarily because they were explicitly read from the cpu and each
counter was very independent.


>
> > Overall the driver currently isn't much more code than with perf (~200
> > lines).
> >
> > Personally my gut feeling a.t.m, is that we should aim to move forward
> > independent from perf.
> >
> > I'd really appreciate some feedback from others on this though.
> >
> > Daniel and Chris; although I think it made sense at the outset to try
> > and use perf, in light of the above would you be open to a non-perf
> > based driver for the OA unit?
>
> No. I strongly dislike that they will be multiple incompatibile perf
> interfaces and strongly like the coupling with other profiling that
> comes with perf - i.e. we very much want to simultaneously sample CPU
> and GPU workloads along with other devices, that information is much
> more useful to me for the purposes of scheduling work and maximising
> concurrency than optimising shaders.
>

In this case I don't think there's inherently any more compatibility that
comes from using perf or not - no existing userspace will Just Work=E2=84=
=A2 with
the perf based OA driver.

I think some of the cases you're referring to may be ok to expose via the
existing perf infrastructure, but I'm currently enabling the OA unit which
poses some unique difficulties I've tried to explain.

A guiding differentiator may be whether or not the counter is orthogonal
(in terms of configuration and normalization) and explicitly readable from
the cpu, as to whether the existing perf pmu infrastructure is a good fit.

'i915 perf' shows my lack of imagination naming this and maybe another name
could imply a more limited scope. I.e. on a case by case basis, when
looking to expose a new counters we can still evaluate whether it makes
sense to expose via the existing perf infrastructure or this.

- Robert


> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

--001a114782847a98db0520f7060d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Wed, Sep 30, 2015 at 9:30 AM, Chris Wilson <span dir=3D"ltr">&lt;<a =
href=3D"mailto:chris@chris-wilson.co.uk" target=3D"_blank">chris@chris-wils=
on.co.uk</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex"><span class=3D"">On Tue, Sep 29, 2015 at 03:39:03PM +0100, Rober=
t Bragg wrote:<br>
&gt; Updating Mesa and GPU Top to experiment with this was straightforward<=
br>
&gt; given the similarity to the perf interface.=C2=A0 The main difference =
is that<br>
&gt; it only supports forwarding metrics via read()s instead of an mmaped<b=
r>
&gt; circular buffer. As mentioned above, I think that suits this well, and=
<br>
&gt; requires no additional copying of data. I think the userspace code has=
<br>
&gt; ended up being a little simpler too.<br>
<br>
</span>Did you try updating the existing perf based overlay?<br></blockquot=
e><div><br></div><div>I don&#39;t recall the overlay attempting to read OA =
counters, but potentially it could be quite nice to add support - sorry I h=
adn&#39;t considered that so far.<br><br></div><div>I don&#39;t believe bei=
ng perf based or not will affect the effort to do this though. The perf bas=
ed driver doesn&#39;t handle OA counter normalization in the kernel so user=
space needs to be able to handle that - which is probably the bigger effort=
.<br><br></div><div>Something to note here about your early pmu driver, is =
that it was notably for counters that were explicitly sampled from the cpu =
using a hrtimer via mmio. I think they were a better fit for the existing p=
erf design than the OA unit, primarily because they were explicitly read fr=
om the cpu and each counter was very independent.<br></div><div>=C2=A0</div=
><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border=
-left:1px solid rgb(204,204,204);padding-left:1ex">
<span class=3D""><br>
&gt; Overall the driver currently isn&#39;t much more code than with perf (=
~200<br>
&gt; lines).<br>
&gt;<br>
&gt; Personally my gut feeling a.t.m, is that we should aim to move forward=
<br>
&gt; independent from perf.<br>
&gt;<br>
&gt; I&#39;d really appreciate some feedback from others on this though.<br=
>
&gt;<br>
&gt; Daniel and Chris; although I think it made sense at the outset to try<=
br>
&gt; and use perf, in light of the above would you be open to a non-perf<br=
>
&gt; based driver for the OA unit?<br>
<br>
</span>No. I strongly dislike that they will be multiple incompatibile perf=
<br>
interfaces and strongly like the coupling with other profiling that<br>
comes with perf - i.e. we very much want to simultaneously sample CPU<br>
and GPU workloads along with other devices, that information is much<br>
more useful to me for the purposes of scheduling work and maximising<br>
concurrency than optimising shaders.<br></blockquote><div><br>In this case =
I don&#39;t think there&#39;s inherently any more compatibility that comes =
from using perf or not - no existing userspace will Just Work=E2=84=A2 with=
 the perf based OA driver.<br><br></div><div>I think some of the cases you&=
#39;re referring to may be ok to expose via the existing perf infrastructur=
e, but I&#39;m currently enabling the OA unit which poses some unique diffi=
culties I&#39;ve tried to explain.<br><br></div><div>A guiding differentiat=
or may be whether or not the counter is orthogonal (in terms of configurati=
on and normalization) and explicitly readable from the cpu, as to whether t=
he existing perf pmu infrastructure is a good fit.<br><br></div><div>&#39;i=
915 perf&#39; shows my lack of imagination naming this and maybe another  n=
ame could imply a more limited scope. I.e. on a case by case basis, when lo=
oking to expose a new counters we can still evaluate whether it makes sense=
 to expose via the existing perf infrastructure or this.<br><br></div><div>=
- Robert<br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">
<span class=3D""><font color=3D"#888888">-Chris<br>
<br>
--<br>
Chris Wilson, Intel Open Source Technology Centre<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-kernel=
&quot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at=C2=A0 <a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" rel=3D"noreferrer" target=3D"_blank">http://vger.kernel.org/majord=
omo-info.html</a><br>
Please read the FAQ at=C2=A0 <a href=3D"http://www.tux.org/lkml/" rel=3D"no=
referrer" target=3D"_blank">http://www.tux.org/lkml/</a><br>
</font></span></blockquote></div><br></div></div>

--001a114782847a98db0520f7060d--

--===============0661687681==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4
IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0
cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZngK

--===============0661687681==--
