From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Date: Thu, 26 Dec 2019 10:03:34 +0000
Message-ID: <20191226100334.bsh3b3dphs4j4cvx@srcf.ucam.org>
References: <cover.1577088521.git.luto@kernel.org>
 <9872655.prSdhymlXK@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9872655.prSdhymlXK@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc: Andy Lutomirski <luto@kernel.org>, Ted Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 26, 2019 at 10:29:00AM +0100, Stephan Müller wrote:
> 
> What about offering a compile-time option to enable or disable such code? 
> Note, with the existing random.c code base, there is no need to have a 
> separate blocking_pool. The ChaCha20 DRNG could be used for that very same 
> purpose, provided that in case these true random numbers are generated when 
> the Chacha20 DRNG received an equal amount of "unused" entropy.

I think it's reasonable to offer such an option as long as it's made 
clear that it'll break userland and should only be enabled under very 
weird circumstances. We don't want to end up in a situation where 
userland developers feel that they need to code to handle such 
situations - the only people who care about this distinction should be 
in control of their userland stack and able to cope with the 
consequences.

> If an unprivileged caller requests true random data, at least 1024 bits of 
> entropy is left in the pool. I.e. all entropy above that point is available 
> for this request type. Note, even namespaces fall into this category 
> considering that unprivileged users can create a user name space in which they 
> can become root.

I also feel like describing any of this as "true random data" is 
misleading. Most of our entropy sources are devices that could, given 
sufficient information, be modelled accurately. We're not sampling 
quantum events here.
 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
