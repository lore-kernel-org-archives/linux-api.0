From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Wed, 25 Feb 2015 03:32:47 +0000
Message-ID: <20150225033247.GC29685@ubuntumail>
References: <20150223161625.GD25477@ubuntumail>
 <alpine.DEB.2.11.1502231041580.21784@gentwo.org>
 <20150223164623.GB32181@mail.hallyn.com>
 <alpine.DEB.2.11.1502231049110.21926@gentwo.org>
 <20150223181553.GE25477@ubuntumail>
 <20150224051928.GA14755@mail.hallyn.com>
 <20150224154715.GA20682@mail.hallyn.com>
 <alpine.DEB.2.11.1502240956400.29006@gentwo.org>
 <20150224164429.GB29685@ubuntumail>
 <alpine.DEB.2.11.1502241120270.29416@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1502241120270.29416@gentwo.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

Quoting Christoph Lameter (cl@linux.com):
> On Tue, 24 Feb 2015, Serge Hallyn wrote:
> 
> > Unless I'm misunderstanding what you are saying, apps do have surprises.
> > They drop capabilities, execute a file, and the result has capabilities
> > which the app couldn't have expected.  At least if the bits have to be
> > in fI to become part of pP', the app has a clue.
> 
> Well yes but the surprises do not occur in the cap bits they are
> manipulating or inspecting via prctl.
> 
> > To be clear, I'm suggesting that the rules at exec become:
> >
> > pI' = pI
> 
> Ok that is new and on its own may solve the issue?

No that's not new.

> > pA' = pA  (pA is ambient)
> 
> Thats what this patch does
> 
> > pP' = (X & fP) | (pI & (fI | pA))
> 
> Hmmm... fP is empty for the file not having caps. so
> 
> pP' = pI & pA

Right.

> > pE' = pP' & fE
> 
> fE? So the inherited caps are not effective? fE would be empty for a file
> not having caps thus the ambient caps would not be available in the child.

Yeah we could make this

pE' = pP' & (fE | pA)

-serge
