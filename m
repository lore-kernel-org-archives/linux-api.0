From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 4/8] random: Ignore GRND_RANDOM in getentropy(2)
Date: Tue, 7 Jan 2020 15:44:27 -0500
Message-ID: <20200107204427.GI3619@mit.edu>
References: <cover.1577088521.git.luto@kernel.org>
 <705c5a091b63cc5da70c99304bb97e0109be0a26.1577088521.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <705c5a091b63cc5da70c99304bb97e0109be0a26.1577088521.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 23, 2019 at 12:20:47AM -0800, Andy Lutomirski wrote:
> The separate blocking pool is going away.  Start by ignoring
> GRND_RANDOM in getentropy(2).
> 
> This should not materially break any API.  Any code that worked
> without this change should work at least as well with this change.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Applied, thanks.

					- Ted
