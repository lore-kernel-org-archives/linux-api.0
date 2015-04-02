From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [Patch] firmware: dmi_scan: split dmisubsystem from dmi-sysfs
Date: Thu, 02 Apr 2015 17:08:22 +0200
Message-ID: <1427987302.4281.309.camel@chaos.site>
References: <1426539451-2119-1-git-send-email-ivan.khoronzhuk@globallogic.com>
	 <1426779055.4267.1907.camel@chaos.site>	<550B08E6.5050200@globallogic.com>
	 <20150320091620.04cf733a@endymion.delvare>
	 <551D3DE4.8040409@globallogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <551D3DE4.8040409@globallogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ivan.khoronzhuk" <ivan.khoronzhuk@globallogic.com>
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, grant.likely@linaro.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, mikew@google.com, dmidecode-devel@nongnu.org, leif.lindholm@linaro.org, msalter@redhat.com
List-Id: linux-api@vger.kernel.org

Le Thursday 02 April 2015 =C3=A0 16:02 +0300, Ivan.khoronzhuk a =C3=A9c=
rit :
> Hi Jean,
> Sorry for the late reply.
> I've send new series
> "[Patch 0/3] firmware: dmi_scan: add SBMIOS entry point and DMI table=
s"
> with all last propositions.

Thanks Ivan, no problem. I'll look at it when I have time.

Two related notes:

* On week from April 13th to 17th, this is Hack Week 12 at SUSE. This
time I decided to work on dmidecode. I plan to add full support for
SMBIOS 3.0.0, including the new entry point format. Then I'll work on
integrating your work (the sysfs interface.) Project page:

https://hackweek.suse.com/12/projects/766

If you or anyone else want to participate, you are very welcome. Ideall=
y
we would release dmidecode 2.13 at the end of that week.

* Do you know of any hardware already implementing SMBIOS 3.0 (either
the new entry point format, or the new enumerated values, or both)?
Having a real-world example would make testing much easier.

Thanks,
--=20
Jean Delvare
SUSE L3 Support
