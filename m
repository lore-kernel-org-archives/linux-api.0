From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Thu, 26 Feb 2015 14:34:05 -0600
Message-ID: <20150226203405.GB18926@mail.hallyn.com>
References: <20150224154715.GA20682@mail.hallyn.com>
 <alpine.DEB.2.11.1502240956400.29006@gentwo.org>
 <20150224164429.GB29685@ubuntumail>
 <alpine.DEB.2.11.1502241120270.29416@gentwo.org>
 <20150225033247.GC29685@ubuntumail>
 <alpine.DEB.2.11.1502251423580.13489@gentwo.org>
 <20150226153524.GC15182@mail.hallyn.com>
 <alpine.DEB.2.11.1502261224580.7451@gentwo.org>
 <20150226193200.GA17709@mail.hallyn.com>
 <alpine.DEB.2.11.1502261412250.7451@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1502261412250.7451@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 26, 2015 at 02:13:00PM -0600, Christoph Lameter wrote:
> On Thu, 26 Feb 2015, Serge E. Hallyn wrote:
> 
> > Andrew Morgan was against that.  What if we changed
> >
> > pE' = pP' & (fE | pA)
> >
> > to
> >
> > 	if (pA)
> > 		pE' = pP' & fE
> > 	else
> > 		pE' = pP'
> >
> 
> Same problem as before. The ambient bits will not be set in pE'.

And what if I weren't scatterbrained and we did 

 	if (pA)
 		pE' = pP'
 	else
 		pE' = pP' & fE

All pP' bits would be set in pE'.
