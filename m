From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 5/8] random: Make /dev/random be almost like
 /dev/urandom
Date: Tue, 7 Jan 2020 16:02:57 -0500
Message-ID: <20200107210257.GJ3619@mit.edu>
References: <cover.1577088521.git.luto@kernel.org>
 <5e6ac8831c6cf2e56a7a4b39616d1732b2bdd06c.1577088521.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5e6ac8831c6cf2e56a7a4b39616d1732b2bdd06c.1577088521.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 23, 2019 at 12:20:48AM -0800, Andy Lutomirski wrote:
> This patch changes the read semantics of /dev/random to be the same
> as /dev/urandom except that reads will block until the CRNG is
> ready.
> 
> None of the cleanups that this enables have been done yet.  As a
> result, this gives a warning about an unused function.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Applied, thanks.

						- Ted
