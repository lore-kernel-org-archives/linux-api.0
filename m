From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sat, 14 Jun 2014 20:59:36 -0700
Message-ID: <539D1A28.7040107@zytor.com>
References: <cover.1402769596.git.luto@amacapital.net> <20140614213000.GO179@brightrain.aerifal.cx> <CALCETrX3Kv7VAfYau-79odKtRvME0-AzZB_xGUMPEHeas8AkaQ@mail.gmail.com> <539CDC6F.6010501@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <539CDC6F.6010501-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
Cc: Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ian Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/14/2014 04:36 PM, H. Peter Anvin wrote:
> 
> Now, if we can do this without adding another page then that becomes
> much more compelling IMO.  I suspect we can if you are already down to
> 488 bytes.
> 

(If it isn't already the case, was inteded to be part of that...)

	-hpa
