From: "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: [PATCH v25 10/12] LRNG - add TRNG support
Date: Wed, 20 Nov 2019 14:55:46 +0500
Message-ID: <cdf1791d-0e60-cb9f-6030-0258f12bef3c@gmail.com>
References: <5390778.VeFRgus4bQ@positron.chronox.de>
 <CALCETrUKDO1LSMnHNcPiAFQh2ri6saRiRBi9b5e699cm1_Mgsw@mail.gmail.com>
 <20191119124150.GB1975017@kroah.com>
 <19681012.svDddlc5pN@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <19681012.svDddlc5pN@positron.chronox.de>
Content-Language: en-PH
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>, "Peter, Matthias" <matthias.peter@bsi.bund.de>
List-Id: linux-api@vger.kernel.org

20.11.2019 13:58, Stephan Müller пишет:

> Or another idea and apologies if I restart this conversation as there was
> already a discussion around it: what about extending the getrandom(2) call
> instead of adding a device file?
> 
> What about adding yet another flag to getrandom: GRND_TRUERANDOM and process
> it as follows:
> 
>          if (flags & ~(GRND_NONBLOCK|GRND_RANDOM|GRND_INSECURE|
> GRND_TRUERANDOM))
>                  return -EINVAL;
> 
>          //From Andy's tree
>          /*
>           * Requesting insecure and blocking randomness at the same time makes
>           * no sense.
>           */
>          if ((flags & (GRND_INSECURE|GRND_RANDOM)) == (GRND_INSECURE|
> GRND_RANDOM))
>                  return -EINVAL;
> 
> 	  /* We only allow GRND_TRUERANDOM by itself or with NONBLOCK */
> 	  if (! ((flags & GRND_TRUERANDOM) &&
>                 ((flags == GRND_TRUERANDOM) ||
>                  (flags == GRND_TRUERANDOM | GRND_NONBLOCK))))
> 		return -EINVAL;
> 
> 	if (flags & GRND_TRUERANDOM) {
> 		... do the TRNG processing ...
> 		... may return -ENOPNOTSUPP if no TRNG available ...
> 	}

This would totally miss the point of adding a device node: UNIX 
permissions that don't allow "others" to read and deplete "true" random 
numbers.

-- 
Alexander E. Patrakov
