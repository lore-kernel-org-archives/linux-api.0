From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 06/10] sysctl: drop away useless label
Date: Wed, 06 Apr 2016 14:34:01 +0300
Message-ID: <1459942441.17884.77.camel@linux.intel.com>
References: <1459864579-55988-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1459864579-55988-7-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20160405151752.de82f221f1c70ff901b2b958@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160405151752.de82f221f1c70ff901b2b958-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2016-04-05 at 15:17 -0700, Andrew Morton wrote:
> On Tue,=C2=A0=C2=A05 Apr 2016 16:56:15 +0300 Andy Shevchenko <andriy.=
shevchenko@
> linux.intel.com> wrote:
>=20
> >=20
> > We have no locking in bin_uuid(). Thus, we may remove the out label
> > and use
> > return statements directly.
> >=20

> Sure, but we may add locking or resource allocation in the future, in
> which case this change will need to be undone.=C2=A0=C2=A0I think it'=
s better to
> leave the code as-is.=C2=A0=C2=A0It's presently quite typical kernel =
code.

I have noticed you updated the patch already. I'm fine with either.=C2=A0

--=20
Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Intel Finland Oy
