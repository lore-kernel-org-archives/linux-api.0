From: Till Smejkal <till.smejkal-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [PATCH -v4] random: introduce getrandom(2) system call
Date: Mon, 21 Jul 2014 22:21:26 +0200
Message-ID: <20140721202125.GF1158@osiris>
References: <1405718127-30042-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405718127-30042-1-git-send-email-tytso-3s7WtUTddSA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, beck-7YlrpqBBQ3VAfugRpC6u6w@public.gmane.org, deraadt-VON6Tr2NNtkmbxgs1yVkuA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

On Fri, 18 Jul 2014, Theodore Ts'o wrote:
[...]
> 	If the GRND_RANDOM bit is not set, then the /dev/urandom pool
> 	will be used.  Unlike using read(2) to fetch data from
> 	/dev/urandom, if the urandom pool has not been sufficiently
> 	initialized, getrandom(2) will block or return -1 with the
> 	errno set to EGAIN if the GRND_NONBLOCK bit is set in flags.
                 ^^^^^
Small typo: this should be EAGAIN.

[...]

Regards

Till Smejkal
