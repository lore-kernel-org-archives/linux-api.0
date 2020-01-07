From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 8/8] random: Remove kernel.random.read_wakeup_threshold
Date: Tue, 7 Jan 2020 16:04:31 -0500
Message-ID: <20200107210431.GM3619@mit.edu>
References: <cover.1577088521.git.luto@kernel.org>
 <a74ed2cf0b5a5451428a246a9239f5bc4e29358f.1577088521.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a74ed2cf0b5a5451428a246a9239f5bc4e29358f.1577088521.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 23, 2019 at 12:20:51AM -0800, Andy Lutomirski wrote:
> It has no effect any more, so remove it.  We can revert this if
> there is some user code that expects to be able to set this sysctl.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Applied, thanks.

					- Ted
