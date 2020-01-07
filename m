From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 2/8] random: Add a urandom_read_nowait() for random
 APIs that don't warn
Date: Tue, 7 Jan 2020 15:43:32 -0500
Message-ID: <20200107204332.GG3619@mit.edu>
References: <cover.1577088521.git.luto@kernel.org>
 <c87ab200588de746431d9f916501ef11e5242b13.1577088521.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c87ab200588de746431d9f916501ef11e5242b13.1577088521.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 23, 2019 at 12:20:45AM -0800, Andy Lutomirski wrote:
> /dev/random and getrandom() never warn.  Split the meat of
> urandom_read() into urandom_read_nowarn() and leave the warning code
> in urandom_read().
> 
> This has no effect on kernel behavior, but it makes subsequent
> patches more straightforward.  It also makes the fact that
> getrandom() never warns more obvious.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Applied, thanks.

					- Ted
