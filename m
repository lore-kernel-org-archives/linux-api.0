From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v24 11/12] LRNG - add SP800-90B compliant health tests
Date: Wed, 13 Nov 2019 01:36:22 +0100
Message-ID: <9152597.fJySsU3eCD@positron.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <3385183.Cb3iLDTLdO@positron.chronox.de> <556c89ae-4272-970d-1644-cb77dc3c7946@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <556c89ae-4272-970d-1644-cb77dc3c7946@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>, "Peter, Matthias" <matthias.peter@bsi.b>
List-Id: linux-api@vger.kernel.org

Am Dienstag, 12. November 2019, 20:58:32 CET schrieb Alexander E. Patrakov:

Hi Alexander,
 
> > +config LRNG_HEALTH_TESTS
> > +	bool "Enable noise source online health tests"
> > +	help
> > +	  The online health tests validate the noise source at
> > +	  runtime for fatal errors. These tests include SP800-90B
> > +	  compliant tests which are invoked if the system is booted
> > +	  with fips=1. In case of fatal errors during active
> > +	  SP800-90B tests, the issue is logged and the noise
> > +	  data is discarded. These tests are required for full
> > +	  compliance with SP800-90B.
> 
> How have you tested that these tests work at runtime? Maybe add some
> code under a new CONFIG item that depends on CONFIG_BROKEN that
> deliberately botches the RNG and triggers failures?


I am unable to find sensible information about CONFIG_BROKEN in the recent 
kernel tree. 

Do you happen to have a pointer on how that option is to be used?

Thanks a lot

Ciao
Stephan
