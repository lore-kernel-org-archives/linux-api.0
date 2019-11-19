From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v25 10/12] LRNG - add TRNG support
Date: Tue, 19 Nov 2019 13:41:50 +0100
Message-ID: <20191119124150.GB1975017@kroah.com>
References: <5390778.VeFRgus4bQ@positron.chronox.de>
 <DDB907EA-3FCC-40C7-B55B-A84BC77FD7A1@amacapital.net>
 <3159012.PsEOTp9LqO@positron.chronox.de>
 <CALCETrUKDO1LSMnHNcPiAFQh2ri6saRiRBi9b5e699cm1_Mgsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUKDO1LSMnHNcPiAFQh2ri6saRiRBi9b5e699cm1_Mgsw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>, Arnd Bergmann <arnd@arndb.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai
List-Id: linux-api@vger.kernel.org

On Tue, Nov 19, 2019 at 02:07:40AM -0800, Andy Lutomirski wrote:
> > As this would introduce a new device file now, is there a special process that
> > I need to follow or do I need to copy? Which major/minor number should I use?
> >
> > Looking into static const struct memdev devlist[] I see
> >
> >          [8] = { "random", 0666, &random_fops, 0 },
> >          [9] = { "urandom", 0666, &urandom_fops, 0 },
> >
> > Shall a true_random be added here with [10]?
> 
> I am not at all an expert on chardevs, but this sounds generally
> reasonable.  gregkh is probably the real authority here.

[10] is the aio char device node, so you better not try to overlap it or
bad things will happen :(

thanks,

greg k-h
