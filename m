From: Frans Klaver <fransklaver@gmail.com>
Subject: Re: [PATCH 05/98] exynos_drm.h: use __u64 from linux/types.h
Date: Mon, 1 Jun 2015 11:14:12 +0200
Message-ID: <CAH6sp9PEuukeGrzXVKmgFZ+CcyfYdT=4VyGQdAGdnhD-chh+sQ@mail.gmail.com>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
	<1433000370-19509-6-git-send-email-mikko.rapeli@iki.fi>
	<20150530164655.GM2067@n2100.arm.linux.org.uk>
	<556C15BA.7000909@amd.com>
	<20150601085605.GN2067@n2100.arm.linux.org.uk>
	<556C2105.2090607@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <556C2105.2090607@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-samsung-soc@vger.kernel.org, Mikko Rapeli <mikko.rapeli@iki.fi>, Seung-Woo Kim <sw0312.kim@samsung.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, DRI mailing list <dri-devel@lists.freedesktop.org>, Kyungmin Park <kyungmin.park@samsung.com>, Kukjin Kim <kgene@kernel.org>, linux-api <linux-api@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 1, 2015 at 11:08 AM, Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
> Yeah, completely agree with Linus on the visibility problem and that'=
s
> exactly the reason why we don't include <stdint.h> in the kernel head=
er and
> expect userspace to define the ISO types somewhere.
>
> But using the types from "include/linux/types.h" and especially inclu=
ding it
> into the uapi headers doesn't make the situation better, but rather w=
orse.
>
> With this step we not only make the headers depend on another header =
that
> isn't part of the uapi, but also pollute the user space namespace wit=
h __sXX
> and __uXX types which aren't defined anywhere else.

These __uXX and __sXX types are defined in
include/uapi/asm-generic/ll64.h and pulled in by
include/uapi/linux/types.h. Including linux/types.h is therefore
valid.

=46rans
