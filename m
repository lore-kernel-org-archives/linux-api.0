From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Thu, 26 Feb 2015 09:35:24 -0600
Message-ID: <20150226153524.GC15182@mail.hallyn.com>
References: <20150223164623.GB32181@mail.hallyn.com>
 <alpine.DEB.2.11.1502231049110.21926@gentwo.org>
 <20150223181553.GE25477@ubuntumail>
 <20150224051928.GA14755@mail.hallyn.com>
 <20150224154715.GA20682@mail.hallyn.com>
 <alpine.DEB.2.11.1502240956400.29006@gentwo.org>
 <20150224164429.GB29685@ubuntumail>
 <alpine.DEB.2.11.1502241120270.29416@gentwo.org>
 <20150225033247.GC29685@ubuntumail>
 <alpine.DEB.2.11.1502251423580.13489@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1502251423580.13489@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 25, 2015 at 02:25:19PM -0600, Christoph Lameter wrote:
> On Wed, 25 Feb 2015, Serge Hallyn wrote:
> 
> > Yeah we could make this
> 
> Well doing that breaks su.

Don't what exactly?  You're saying that doing

pI' = pI
pA' = pA  (pA is ambient)
pP' = (X & fP) | (pI & (fI | pA))
pE' = pP' & (fE | pA)

stopped su from having CAP_SETGID while

pI' = pI
pA' = pA  (pA is ambient)
pP' = (X & fP) | (pI & (fI | pA))
pE' = pP' & fE

worked?  I'll hope you're saying both "fail", in which case

> Its best to leave perm bits untouched.


> christoph@fujitsu-haswell:~$ su
> setgid: Operation not permitted

Did you initialize by running a program to fill your pI?

-serge
