From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Thu, 23 Jun 2016 07:07:05 +0200
Message-ID: <3250613.UAo0YkFYZb@tauon.atsec.com>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1> <dbcb97e0-35c0-7e6e-9351-d90a0d945bab@intel.com> <alpine.OSX.2.20.1606221515040.16377@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.OSX.2.20.1606221515040.16377-zaFMaa3cLiZe6KzckbbZvYT4S9po1h25@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mat Martineau <mathew.j.martineau-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 22. Juni 2016, 15:45:38 schrieb Mat Martineau:

Hi Mat,

> > 
> > Ok, I'll update the patch.
> 
> Thanks, that helps (especially with pkcs1pad).

Tadeusz received the updated patch from me to integrate it into his patch set.
> 
> This brings me to another proposal for read buffer sizing: AF_ALG akcipher
> can guarantee that partial reads (where the read buffer is shorter than
> the output of the crypto op) will work using the same semantics as
> SOCK_DGRAM/SOCK_SEQPACKET. With those sockets, as much data as will fit is
> copied in to the read buffer and the remainder is discarded.
> 
> I realize there's a performance and memory tradeoff, since the crypto
> algorithm needs a sufficiently large output buffer that would have to be
> created by AF_ALG akcipher. The user could manage that tradeoff by
> providing a larger buffer (typically key_size?) if it wants to avoid
> allocating and copying intermediate buffers inside the kernel.

How shall the user know that something got truncated or that the kernel 
created memory?

Ciao
Stephan
