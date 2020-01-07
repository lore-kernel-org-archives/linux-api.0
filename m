From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 6/8] random: Remove the blocking pool
Date: Tue, 7 Jan 2020 16:03:30 -0500
Message-ID: <20200107210330.GK3619@mit.edu>
References: <cover.1577088521.git.luto@kernel.org>
 <511225a224bf0a291149d3c0b8b45393cd03ab96.1577088521.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <511225a224bf0a291149d3c0b8b45393cd03ab96.1577088521.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 23, 2019 at 12:20:49AM -0800, Andy Lutomirski wrote:
> There is no longer any interface to read data from the blocking
> pool, so remove it.
> 
> This enables quite a bit of code deletion, much of which will be
> done in subsequent patches.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Applied, thanks.

					- Ted
