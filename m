From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 1/8] random: Don't wake crng_init_wait when crng_init
 == 1
Date: Tue, 7 Jan 2020 15:42:50 -0500
Message-ID: <20200107204250.GF3619@mit.edu>
References: <cover.1577088521.git.luto@kernel.org>
 <6fbc0bfcbfc1fa2c76fd574f5b6f552b11be7fde.1577088521.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6fbc0bfcbfc1fa2c76fd574f5b6f552b11be7fde.1577088521.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 23, 2019 at 12:20:44AM -0800, Andy Lutomirski wrote:
> crng_init_wait is only used to wayt for crng_init to be set to 2, so
> there's no point to waking it when crng_init is set to 1.  Remove the
> unnecessary wake_up_interruptible() call.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Applied with a spelling fix ("wayt->wait").

					- Ted
