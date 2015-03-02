From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Mon, 2 Mar 2015 09:43:17 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1503020933120.5540@gentwo.org>
References: <alpine.DEB.2.11.1502261612370.8994@gentwo.org> <20150301044407.GA14196@mail.hallyn.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20150301044407.GA14196@mail.hallyn.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Jonathan Corbet <corbet@lwn.net>, Aaron Jones <aaronmdjones@gmail.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Sat, 28 Feb 2015, Serge E. Hallyn wrote:

> Your example program is not filling in pI though?

The setcap sets the inheritance bit. When the binary runs the i bits
should be set.

> Ah, i see why.  In get_file_caps() you are still assigning
>
> 	fP = pA
>
> if the file has no file capabilities.  so then you are actually
> doing
>
> 	 pP' = (X & (fP | pA)) | (pI & (fI | pA))
> rather than
> 	 pP' = (X & fP) | (pI & (fI | pA))


I thought that fP, fI and pI = {} since the file has no caps
so this comes  out as

pP' = pA

> Other than that, the patch is looking good to me.  We should
> consider emitting an audit record when a task fills in its

How do I do that?

> pA, and I do still wonder whether we should be requiring
> CAP_SETFCAP (unsure how best to think of it).  But assuming the
> fP = pA was not intended, I think this largely does the right
> thing.
