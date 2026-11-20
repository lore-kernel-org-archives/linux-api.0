Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192565;
	b=f8kAhsHY+3TJUPzefwIbRx2VsBVoukaoQqW5cd1z3uUTFTfoYFVohqm51arVxaD0H3xa
	 9CH/6X4ZTA7ex3iaUNZE9bsmQfygx2zHLoH7d5o80ZOwOzyjy57/nOf1Xik563ecq9fL7
	 31WsyJDQfKmsUIBnhktozfAzyRRzQblsrfRNwBQxi2WM1H+wIP57x8WUNoC3H7MyJwobj
	 OYA3fvtvP8rlo1pdQLIYM5qGiMk8e1cBEA8Qa26yzSBeKbW/s093hvYoI+t+3CTPTrpja
	 lM8t/JXsI+mbMtwDiLiuPCnBlBnPI0cQt69/H0muDqsloWp33GkxM8dQZF6y+P3i2qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192565;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=NROB+otJAPb3sKEG9kAf2FYeN/cSw15FXGSDwsRGGiA=;
	b=GgjILt1HlJ2J8u+DTpnk4HwIXScIb1WO2SA9dNWGMV8Y0nVwnAdLGqNCyQKOat47RDtV
	 PKzGAkITRdGF0BIHhMWGtbQAzgHOvlLRxNXr5My9m0m1gw1Jls5+vzqM4J3DbtvXNAFNX
	 vzpf2+DbyUOrGewxhis68zapuSZ8p1Uxi2jo8SI84/9ofzwJRAajuCs+UrrOyImU4jULO
	 snVeZ+cSZueoUJVx9lXN41ea3yJYEYy+bHnK0mlPy8o+iDUVPNx/jL2TSbuy7XO8N9aHR
	 tHUJiqTyUp9ZQNsGd/BUPX3gFodotHwEyP+LEJZ9G1NFB5xCIMKabLv6Lw17xC5/6mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Jvj697/T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473BB606A33C
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 16:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jvj697/T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B359B1F000E0
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 16:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795192564;
	bh=NROB+otJAPb3sKEG9kAf2FYeN/cSw15FXGSDwsRGGiA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Jvj697/TG8z5Aw8X8V0KDy/+ofCZg9kXbJWveRZUTJsDr+yFJiZu4gKjZVpzSeo01
	 6yRa30P6jiDowpL2aKsWhTEAEQUHpzNawYaiSysE/Jk+8icOH0/Hm1MYXb2TAL/6Cv
	 JQ/6fwbfIcs+xNqPW9hdfBAGTZt2d3M5fJ3t/WVnGsrVK4+UjkU90hCaxXTfOPe8oB
	 4Trnc13yYyparqlWH1e7++5qMLO0LDuP4rjTYhDboijr1/eJOvIXcQdIfRv7SoiGVs
	 cBELFF2LI1Tvp3wFVDrDq0tgT6dtXOe8wU7x47dJzt1ApBmihEzQ20UKYFCQQet0CK
	 nJ9StSGTTAPMQ==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5c1c0c8d61aso656544e87.1
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 08:36:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEfziASf6UmpOH4xBhgCVdQsud/g3jdoHXyD5UC8T1KLbkeonTBmg+2J9ME6QvN9m1GtaiVuvXRIsk=@vger.kernel.org
X-Gm-Message-State: APuU4Z9pr15bXkCf7vTE+oRmPVrg9KlZVTHtaaUF8/UnENjBlcokW2GF
	tLyX88a1agY2Mw55UThpHxxtWD7mfCtfrqbEAUmLwNyENP9u30atcUV4tyDDWH0QcFRbgtFdiB0
	zeswCJQo6BfTlxq3lmfFIrbItTfbqKK4=
X-Received: by 2002:a05:6512:3da5:b0:5ba:3fbc:272d with SMTP id
 2adb3069b0e04-5c1bc7d651fmr1088634e87.33.1795192562967; Fri, 20 Nov 2026
 08:36:02 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109-dpti-custom-cpu-v1-0-ead8e2d2067e@linux.intel.com>
In-Reply-To: <20261109-dpti-custom-cpu-v1-0-ead8e2d2067e@linux.intel.com>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Fri, 20 Nov 2026 17:35:50 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0jn0RBxEHF4GxtAZUF3SxA+bAxJqtHui=aqbN1Fdjoj0w@mail.gmail.com>
X-Gm-Features: Aa3M54q3UnfQHJFVJ2OgisTESicOBjjN48VEnnoRLIfX6LwfqK5tB8SVptueTeM
Message-ID: <CAJZ5v0jn0RBxEHF4GxtAZUF3SxA+bAxJqtHui=aqbN1Fdjoj0w@mail.gmail.com>
Subject: Re: [PATCH 00/13] thermal: intel: dpti: Direct the package thermal
 interrupt to a chosen CPU
To: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Daniel Lezcano <daniel.lezcano@kernel.org>, 
	Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, linux-pm@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ricardo.neri@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 4:36=E2=80=AFAM Ricardo Neri
<ricardo.neri-calderon@linux.intel.com> wrote:
>
> The directed package-level thermal interrupt (DPTI) lets a single CPU per
> package receive the package thermal interrupt instead of broadcasting it =
to
> every CPU in the package. Today that CPU is chosen with no regard for the
> user's intent: the first CPU of a package to come online claims the
> interrupt, and on offline it is redirected to another CPU of the package.
> As a result, the interrupt can land on a CPU the user would rather keep
> undisturbed, such as a nohz_full CPU, whose tickless isolation it breaks.
>
> This series gives the user explicit control over the interrupt owner
> through sysfs. It also updates automatic selection of the owner CPU to
> avoid CPUs isolated at boot through the nohz_full and isolcpus=3Dnohz
> command-line options.
>
> CPUs isolated through isolcpus=3Ddomain or a cpuset isolated partition ar=
e
> left for a follow-up series, if there is interest.
>
> The sysfs interface
> -------------------
>
> On a system with DPTI, every online CPU gets a boolean attribute in its
> existing thermal_throttle group:
>
>   /sys/devices/system/cpu/cpuX/thermal_throttle/package_interrupt_owner
>
> Reading it answers a question about cpuX alone: 1 if cpuX is the CPU
> currently programmed to receive its package's thermal interrupt, 0
> otherwise. The owner is a per-package property, so at most one CPU of a
> package reads 1, and all of them read 0 while the interrupt is not direct=
ed
> to any CPU.
>
> Writing 1 migrates the interrupt to cpuX and pins it there, overriding
> automatic selection. The request is honored even if cpuX is
> nohz_full-isolated, in which case a warning is logged. The write fails if
> the hardware does not acknowledge the new owner.
>
> Writing 0 releases a pin on cpuX and returns the package to automatic
> selection. If cpuX is nohz_full-isolated, the interrupt moves to a CPU of
> the package that is not, when one is online. Otherwise it stays on cpuX.
> Writing 0 to a CPU that is not pinned has no effect.
>
>   # Direct this package's thermal interrupt to CPU 3 and keep it there
>   echo 1 > \
>       /sys/devices/system/cpu/cpu3/thermal_throttle/package_interrupt_own=
er
>
>   # Let automatic selection govern that package again
>   echo 0 > \
>       /sys/devices/system/cpu/cpu3/thermal_throttle/package_interrupt_own=
er
>
>   # List the CPUs that own their package's interrupt
>   grep -l '^1$' \
>       /sys/devices/system/cpu/cpu*/thermal_throttle/package_interrupt_own=
er
>
> Known limitations
> -----------------
>
> To keep the interface and the implementation simple, the interface accept=
s
> these limitations:
>
>  - The file reports owner state, not pin state. Writing 0 to a CPU that i=
s
>    not isolated unpins without migrating: cpuX keeps the interrupt and
>    keeps reading 1 until the placement changes, for example when cpuX goe=
s
>    offline.
>
>  - There is no request to move the interrupt away from cpuX. Pin another
>    CPU of the package instead.
>
>  - A write to one CPU changes what another CPU's file reads: pinning cpuY
>    makes the previous owner, cpuX, read 0 without cpuX's file being
>    written.
>
>  - Finding which CPU owns a given package's interrupt takes one read per
>    CPU of the package instead of a single read.
>
>  - The pinned preference is not observable. While a pinned CPU is offline=
,
>    the remaining CPUs of the package report the automatically chosen
>    fallback. The pin is silently restored when the pinned CPU comes back
>    online.
>
>  - The same file appears under every CPU of a package, because per-packag=
e
>    state is exposed through the per-CPU device. This reuses the existing
>    per-CPU device infrastructure and mirrors package_throttle_count, whic=
h
>    is also per-package state shown per-CPU.
>
> Organization
> ------------
>
> The series is organized as follows:
>
>  * Fix (patch 1): an existing race between kernel_kexec() and CPU hotplug
>    can program a new owner after the syscore shutdown has cleared the DPT=
I
>    in all packages and leave it enabled in the next kernel. Independent o=
f
>    the rest of the series.
>
>  * Preparation (patches 2-4): prefix the log messages of therm_throt.c
>    with pr_fmt(), move the sysfs device helpers next to their callers, an=
d
>    give the DPTI code a consistent dpti_ naming scheme.
>
>  * Groundwork (patches 5-9): owner changes become more likely once the
>    selection and sysfs patches land. Limit the full teardown to boot, so
>    that a later failure affects only its package; group per-package state
>    in struct dpti_pkg; and factor the programming sequence into helpers
>    that run it on the target CPU, from any CPU and entry point.
>
>  * Rank-based owner selection (patch 10): instead of special-casing pinne=
d
>    and isolated CPUs, rank every CPU and move the interrupt only on a
>    strict rank improvement.
>
>  * Serialization (patch 11): introduce dpti_mutex ahead of the sysfs
>    writer, which runs concurrently with the CPU hotplug callbacks.
>
>  * Avoid nohz_full-isolated CPUs (patch 12): rank housekeeping CPUs above
>    isolated ones, and migrate as soon as a housekeeping CPU comes online.
>
>  * The sysfs interface (patch 13): let the user pin the owner.
>
> Summary of testing
> ------------------
>
> Tested on a 1-socket system with DPTI and on a 2-socket system without it=
,
> where test-only patches emulate DPTI.
>
> - CPU hotplug:
>   - Sweeps that offline and then online each CPU in turn, checking the
>     owner in MSR_IA32_THERM_INTERRUPT (and in sysfs from patch 13) after
>     every step: about 750 transitions across the kernels of every patch o=
n
>     the 1-socket system, and about 950 on the 2-socket system, where
>     package owners go offline and the interrupt migrates.
>   - lockdep stress runs of up to 10,000 offline/online cycles against
>     sysfs writes, with no deadlocks.
>   - Injected handover failures always ended with either the old owner
>     kept or the package broadcasting.
> - Isolation (nohz_full):
>   - The owner stayed on housekeeping CPUs and fell back to an isolated CP=
U,
>     with a warning, only when it had to. Ownership migrated back to a
>     housekeeping CPU as soon as one came online.
>   - 0 of 36 package interrupts reached an isolated CPU with DPTI, against
>     26 of 26 without it.
> - Hibernation (S4):
>   - One cycle on every patch kernel, with the owner restored each time,
>     and a pin restored where one was set.
>   - All four combinations of image and boot kernel, with and without DPTI=
,
>     left no stale state.
> - kexec:
>   - The sysfs race went from 22 of 22 failing to 20 of 20 clean with the
>     fix in patches 1 and 11. The CPU hotplug race went from 4 of 4 failin=
g
>     to 0 of 5 with patch 1.
>   - A kexec into a kernel without DPTI always found the hardware clean.
> - Configurations:
>   - Every patch builds cleanly in an x86_64_defconfig-based configuration=
,
>     with each of NO_HZ_FULL, SYSFS, SMP, CPU_ISOLATION, PM_SLEEP, lockdep
>     and X86_THERMAL_VECTOR turned off one at a time, and in a 32-bit
>     build. On hardware, I ran the test systems' distribution configuratio=
n
>     with debug options, plus three variants: NO_HZ_FULL=3Dn, KASAN with
>     kmemleak, and a no-debug performance build.
>
> Thanks and BR,
> Ricardo
>
> Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
> ---
> Ricardo Neri (13):
>       thermal: intel: Keep directed package interrupts off after syscore =
shutdown
>       thermal: intel: Prefix log messages via pr_fmt()
>       thermal: intel: Move the sysfs device helpers next to their callers
>       thermal: intel: dpti: Adopt the dpti_ prefix and the owner terminol=
ogy
>       thermal: intel: dpti: Tear down DPTI only during boot
>       thermal: intel: dpti: Introduce struct dpti_pkg for per-package sta=
te
>       thermal: intel: dpti: Configure the local CPU by value
>       thermal: intel: dpti: Factor the programming sequence out into a he=
lper
>       thermal: intel: dpti: Program the directed interrupt on the target =
CPU
>       thermal: intel: dpti: Add rank-based owner selection
>       thermal: intel: dpti: Serialize updates to the directed interrupt s=
tate
>       thermal: intel: dpti: Avoid nohz_full CPUs when possible
>       thermal: intel: dpti: Add sysfs control of interrupt owner
>
>  Documentation/ABI/testing/sysfs-devices-system-cpu |  40 ++
>  drivers/thermal/intel/therm_throt.c                | 739 +++++++++++++++=
+-----
>  2 files changed, 606 insertions(+), 173 deletions(-)
> ---

Whole series applied as 7.5 material, thanks!
