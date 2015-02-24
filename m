From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Tue, 24 Feb 2015 16:44:29 +0000
Message-ID: <20150224164429.GB29685@ubuntumail>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org>
 <alpine.DEB.2.11.1502230856400.21238@gentwo.org>
 <20150223161625.GD25477@ubuntumail>
 <alpine.DEB.2.11.1502231041580.21784@gentwo.org>
 <20150223164623.GB32181@mail.hallyn.com>
 <alpine.DEB.2.11.1502231049110.21926@gentwo.org>
 <20150223181553.GE25477@ubuntumail>
 <20150224051928.GA14755@mail.hallyn.com>
 <20150224154715.GA20682@mail.hallyn.com>
 <alpine.DEB.2.11.1502240956400.29006@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1502240956400.29006@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

Quoting Christoph Lameter (cl@linux.com):
> On Tue, 24 Feb 2015, Serge E. Hallyn wrote:
> 
> > The other way to look at it then is that it's basically as though the
> > privileged task (which has CAP_SETFCAP) could've just added fI=full to
> > all binaries on the filesystem;  instead it's using the ambient set
> > so that the risk from fI=full is contained to its own process tree.
> 
> The way that our internal patch works is to leave these things alone and
> just check the ambient mask in the *capable*() functions. That way the
> behavior of the existing cap bits does not change but the ambient caps
> stay available. Apps have no surprises.

Unless I'm misunderstanding what you are saying, apps do have surprises.
They drop capabilities, execute a file, and the result has capabilities
which the app couldn't have expected.  At least if the bits have to be
in fI to become part of pP', the app has a clue.

To be clear, I'm suggesting that the rules at exec become:

pI' = pI
pA' = pA  (pA is ambient)
pP' = (X & fP) | (pI & (fI | pA))
pE' = pP' & fE
