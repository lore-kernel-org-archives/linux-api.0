From: Rolf Eike Beer <eike-kernel-F+mm6HnICJmzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Date: Wed, 30 Jul 2014 16:34:40 +0200
Message-ID: <3912417.mEOGY4YVAb@devpool02>
References: <1406212287-9855-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406212287-9855-1-git-send-email-tytso-3s7WtUTddSA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Linux Kernel Developers List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Theodore Ts'o wrote:

It's me again, finding only one issue per cycle :/

> 	EAGAIN		The requested entropy was not available, and
> 			getentropy(2) would have blocked if GRND_BLOCK flag
> 			was set.

"if GRND_NONBLOCK flag was not set"

Eike
