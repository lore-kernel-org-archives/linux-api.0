From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Thu, 26 Feb 2015 12:28:30 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1502261224580.7451@gentwo.org>
References: <20150223164623.GB32181@mail.hallyn.com> <alpine.DEB.2.11.1502231049110.21926@gentwo.org> <20150223181553.GE25477@ubuntumail> <20150224051928.GA14755@mail.hallyn.com> <20150224154715.GA20682@mail.hallyn.com> <alpine.DEB.2.11.1502240956400.29006@gentwo.org>
 <20150224164429.GB29685@ubuntumail> <alpine.DEB.2.11.1502241120270.29416@gentwo.org> <20150225033247.GC29685@ubuntumail> <alpine.DEB.2.11.1502251423580.13489@gentwo.org> <20150226153524.GC15182@mail.hallyn.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150226153524.GC15182-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 26 Feb 2015, Serge E. Hallyn wrote:

> > Well doing that breaks su.
>
> Don't what exactly?  You're saying that doing
>
> pI' = pI
> pA' = pA  (pA is ambient)
> pP' = (X & fP) | (pI & (fI | pA))
> pE' = pP' & (fE | pA)
>
> stopped su from having CAP_SETGID while
>
> pI' = pI
> pA' = pA  (pA is ambient)
> pP' = (X & fP) | (pI & (fI | pA))
> pE' = pP' & fE
>
> worked?  I'll hope you're saying both "fail", in which case

fE does not exist in cpu_vfs_cap_data. We only get fI and fP. Why in the
world does setcap allow setting fE?

V1 does not use fE. In my newer attempt, I seemed to have worked
with zeroed field that I assumed was filled in.

I will just do

pE' = pP'

Ok?
