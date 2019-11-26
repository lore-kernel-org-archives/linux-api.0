From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v26 12/12] LRNG - add interface for gathering of raw entropy (fwd)
Date: Tue, 26 Nov 2019 20:27:33 +0100
Message-ID: <3845228.ihUtNFa0QL@tauon.chronox.de>
References: <alpine.DEB.2.21.1911261903060.2605@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1911261903060.2605@hadrien>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia.lawall@inria.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>, "Peter, Matthias" <matth>
List-Id: linux-api@vger.kernel.org

Am Dienstag, 26. November 2019, 19:04:10 CET schrieb Julia Lawall:

Hi Julia,

> Hello,
> 
> Should something be done about the lock on line 162?

Yes, thank you for the report. There should be an unlock, naturally.

Ciao
Stephan
