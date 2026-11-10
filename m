Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311003;
	b=jdYuBTZxrhAeE5pzZw2iZfyLY6Rl8LuGSxulniXzQp8ZhFm7LzzTOUjB2w8buD6Jp8Q3
	 c7kj0nQQicIECskVXWcJH+hyK3NJLbgc3s58iRf3ngjxs6gyrOz0dVxe2r90AFC3uKr55
	 4ACOAzpuk76m1Uc2anqYm5JOdMVksG//OjwtDnZbD+jJbprp8Mz7VcWdTuPNHjeHJZl8B
	 CYdpvBfnb31NQZNZ1KpRr2nX4bdHs/CwY6SvpD34/SpDy3u8RwBhqkT+sRZpWEzzZ0QpG
	 I20GaXb0sydM5Om822jNO1v2LpaJkrTywo5XqGkmme2pbe7T+Op9zBtkqqSZ1NL8bng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311003;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:To:cc:
	 Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type;
	bh=Dwo3NODYrC8lH9+/ED/zyRctWxyQsy+gkPSiaqjxgzM=;
	b=S4S/ziMpEBE8DUM3UiJNElm1uhQffjzb4NCYXJUCLVbweM4Z/lfRVQ6XI2cVLSkFbTfw
	 3VPg/lICzMcG/cYypGieZUDL0J/jiGe0SrmSV82MGv2ou5w3vqTJ9l5Vne4KD/SUgI7lV
	 4io1JUk7XwJBtt9c+PmsoOH7UMovoW1Ujea6ZCWsQG8PozkwtNNnXXgATuiNyuQuTt1FP
	 L+0DNTDc6B0TqcPQ9dqzM+7Lgy3ZpLdOimjUMg/i0MdI85/pXkxt1U4+T3r2m/eCIuNYL
	 FhBPWzW2FDbbBga+nYKGX7F8ee9gmxLBP3UWNvGsAhYR+PMULUprEe+9/1HXDMDEiTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JdpvIJcW;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9F8606A31C;
	Tue, 10 Nov 2026 11:43:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A9F8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JdpvIJcW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794311001; x=1825847001;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=fFlYzKZx6d7zbItcdPrIhfKRGk6oxCXe/4WPWbITVJw=;
  b=JdpvIJcWXyu6v7dcmlx3TuMZLrr5BLdjcE9T7JuxYANe/eCPtVQ24ZE9
   dXhCu+q9gKFHWqzCW76EIJUDfAT3iIeC+wEOprPjzZjRO/Boe2rx3OMyt
   l1rnLrmdX+OJz4O9VnrP4wKmkHiSKj4iW0RyeQlNbw88VUsg/Mtk6CuhG
   ZCZcLZrkfhKdk6+1CHtU7vQZsFy2GJSJ+tmADPHvb4qrJeNP9AaOb/ODK
   edfDdoUdjnFcLQa6Zoh33uqPSdMQyb9EttrOccAV84pn5GPJaIsq7U7hy
   CFMjy35IZtMD3M2wwj3OUwqHiY9ScqOwLTb+V0kzK1S8eKIqgQCUpbJ4L
   A==;
X-CSE-ConnectionGUID: /aZWI9eTRJaZV00/Pmvf6g==
X-CSE-MsgGUID: /KnxLu+ITFyEk/B3z3+1GQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3136973"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3136973"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 03:43:20 -0800
X-CSE-ConnectionGUID: LZa1K/XxTqqy4Ut7m3heoQ==
X-CSE-MsgGUID: E6/vOvLBQkqely5eF00TxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8145256"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.34])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 03:43:18 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 10 Nov 2026 13:43:14 +0200 (EET)
To: Denis Benato <denis.benato@linux.dev>
cc: Bartu Alev <bartualev@gmail.com>, 
    Corentin Chary <corentin.chary@gmail.com>, 
    "Luke D. Jones" <luke@ljones.dev>, Hans de Goede <hansg@kernel.org>, 
    platform-driver-x86@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    linux-api@vger.kernel.org, Denis Benato <benato.denis96@gmail.com>
Subject: Re: [PATCH v4 1/2] platform/x86: asus-wmi: add TUF keyboard RGB
 readback support
In-Reply-To: <9d9e53e5-aede-46fe-b0cb-747b95a816fd@linux.dev>
Message-ID: <31f09d55-2920-e80e-435e-00679996afc3@linux.intel.com>
References: <20261029-asus-tuf-rgb-v4-v4-0-0d3b877d2c30@gmail.com> <20261029-asus-tuf-rgb-v4-v4-1-0d3b877d2c30@gmail.com> <cc9c8655-6f7c-05f9-ad09-4ea30f1dda95@linux.intel.com> <9d9e53e5-aede-46fe-b0cb-747b95a816fd@linux.dev>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1592355462-1794310994=:1229"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1592355462-1794310994=:1229
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 10 Nov 2026, Denis Benato wrote:
> On 11/9/26 19:02, Ilpo J=C3=A4rvinen wrote:
> > On Thu, 29 Oct 2026, Bartu Alev wrote:
> >
> >> The TUF keyboard RGB attributes kbd_rgb_mode and kbd_rgb_state are
> >> write-only, so userspace tools keep their own copy of the lighting
> >> configuration and lose track of it whenever the EC changes state on it=
s
> >> own: after a firmware reset or a boot into another operating system th=
e
> >> tools show a stale configuration until the user rewrites every field.
> >>
> >> DSTS device 0x0010005B evaluates the DSDT method EC0.KBLS(), which
> >> snapshots the EC's host-visible keyboard state into a 16-byte buffer:
> >> lighting mode, red, green and blue levels, animation speed, and the
> >> four power-state flags.  The first byte is a constant 1 written by the
> >> AML, which distinguishes a KBLS reply from any other object the method
> >> could return.
> >>
> >> Add kbd_rgb_read_status() to evaluate and validate that buffer, parse
> >> it through a packed struct, and convert both attributes to
> >> DEVICE_ATTR_RW.  The read returns the write format with "n/a" in the
> >> command position: the command word belongs to the write verb (apply
> >> now or save to flash) and both verbs update the EC mirror the same
> >> way, so there is no state to report there.  The three EC speed codes
> >> map back to the sysfs indices 0 to 2.
> >>
> >> Readback was verified against the EC firmware: the status bytes mirror
> >> EC RAM at 0x0B22 to 0x0B2E, and the speed codes 0xe1, 0xeb and 0xf5
> >> select animation step thresholds of 30, 20 and 10 ticks per phase,
> >> which matches the slow, normal and fast labels.  Tested on a TUF
> >> Gaming A15 (FA507NV).
> >>
> >> Suggested-by: Denis Benato <denis.benato@linux.dev>
> >> Signed-off-by: Bartu Alev <bartualev@gmail.com>
> >> ---
> >>  drivers/platform/x86/asus-wmi.c            | 83 +++++++++++++++++++++=
++++++++-
> >>  include/linux/platform_data/x86/asus-wmi.h |  3 ++
> >>  2 files changed, 84 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/as=
us-wmi.c
> >> index b33ebdb21aa2..054d1d684bb0 100644
> >> --- a/drivers/platform/x86/asus-wmi.c
> >> +++ b/drivers/platform/x86/asus-wmi.c
> >> @@ -1062,6 +1062,65 @@ static DEVICE_ATTR_RW(gpu_mux_mode);
> >>  #define TUF_KBD_RGB_SPEED_SLOW=09=090xe1
> >>  #define TUF_KBD_RGB_SPEED_NORMAL=090xeb
> >>  #define TUF_KBD_RGB_SPEED_FAST=09=090xf5
> >> +/* TUF keyboard RGB status readback *********************************=
**********/
> >> +struct asus_wmi_kbd_rgb_status {
> >> +=09u8 signature;
> >> +=09u8 mode;
> >> +=09u8 red;
> >> +=09u8 green;
> >> +=09u8 blue;
> >> +=09u8 speed;
> >> +=09u8 state;
> >> +=09u8 unused[9];
> >> +} __packed;
> >> +
> >> +static int kbd_rgb_read_status(struct asus_wmi_kbd_rgb_status *status=
)
> >> +{
> >> +=09int err;
> >> +
> >> +=09err =3D asus_wmi_evaluate_method_buf(ASUS_WMI_METHODID_DSTS,
> >> +=09=09=09=09=09   ASUS_WMI_DEVID_TUF_RGB_READ_STATUS,
> >> +=09=09=09=09=09   0, (u8 *)status, sizeof(*status));
> >> +=09if (err)
> >> +=09=09return err < 0 ? err : -ENODEV;
> > What do you (or Denis) think on sashiko's mention about=20
> > asus_wmi_evaluate_method_buf() casting integer.value to int which might=
=20
> > end up aliasing high-bit on return values with errnos?
>=20
> Hi Ilpo,
>=20
> I don't see the sashiko response neither in my mail nor in the lore,
> but I think I understand the problem.

Hi,

https://sashiko.dev is the goto place where you have them for all public=20
submissions covered.

It's intentional that we don't encumber (spam) our first time submitters=20
with gazillions of pre-existing problems sashiko finds. Many of which are=
=20
largely irrelevant/low value for platform drivers anyway (what user would=
=20
remove a platform driver? or probe() rollback path issues; nice to fix=20
those as well but nowhere near urgent or important level).

Sashiko has gotten somewhat better in not spamming the submitters with all=
=20
such pre-existing issues but tries to filter only the ones somewhat=20
relevant to the patch so I might reconsider that.

Sashiko's review emails together with using LLM to create and update=20
patches also have a tendencity to cause undesirable rapid patch respinning=
=20
cycle no human reviewer wants to see in their inboxes so it's a=20
double-edged sword. I don't want to see v10 in a week or two from=20
starting, it seems counterproductive as it's discouraging to human=20
reviewers.

In this case you need to read between the lines as the report is for the=20
Documentation patch, whereas I think it's an indication of a more generic=
=20
problem in the code that isn't a mere documentation issue.

> What I think is that we have been lucky.
>=20
> ASUS probably chose the presence bit high enough not to cause
> troubles when they have to report a status to armoury crate
> and they don't use negative numbers, but yes I agree that the
> return value is more to be seen as a bitfield (with some-bits
> fields as numbers) rather than ints.

So if there's only the FF..FE return with high value, it doesn't seem=20
problem because it's explicilty checked for but I recall there was also=20
FF..FF somewhere (no longer sure if I remember even what driver it was=20
but the numbers seems suspiciously close to ones used here), it's not=20
being checked in ..._buf() case and casting that to int makes it to alias=
=20
with -EPERM.

> I have actually spotted this on a commit from Marco that was not
> being sent on the lkml (because he touched that code) and I didn't
> like what I saw (I didn't like what was already there).
>=20
> Those commits were about modernizing the use of mutex
> and __free where appropriate and I kinda liked them, will
> ask him to revive it...
>=20
> But proper and coherent error handling will touch basically
> a large part of supported hardware and asus-wmi core
> parts,
>=20
> I am a bit hesitant to touch that code because I might break
> some old and not widely known device: it's the only reason
> I haven't (yet) acted in this regard.
>=20
> > The other caller seems to also return that value directly out of _store=
=20
> > function().
>=20
> The other caller got lucky exactly as the rest of driver.
>=20
> setters in wmi don't even report the presence bit so there
> is even less "incentive" to actually check it.
>=20
>=20

--=20
 i.

--8323328-1592355462-1794310994=:1229--
