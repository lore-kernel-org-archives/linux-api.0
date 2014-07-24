From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Date: Thu, 24 Jul 2014 12:18:14 -0300
Message-ID: <20140724151814.GE32421@khazad-dum.debian.net>
References: <1406212287-9855-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406212287-9855-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, linux-crypto@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 24 Jul 2014, Theodore Ts'o wrote:
> ERRORS
> 	EINVAL		An invalid flag was passed to getrandom(2)
> 
> 	EFAULT		buf is outside the accessible address space.
> 
> 	EAGAIN		The requested entropy was not available, and
> 			getentropy(2) would have blocked if GRND_BLOCK flag
> 			was set.
> 
> 	EINTR		While blocked waiting for entropy, the call was
> 			interrupted by a signal handler; see the description
> 			of how interrupted read(2) calls on "slow" devices
> 			are handled with and without the SA_RESTART flag
> 			in the signal(7) man page.

Should we add E<SOMETHING> to be able to deny access to GRND_RANDOM or some
future extension ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
