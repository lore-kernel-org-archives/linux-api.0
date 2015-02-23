From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Mon, 23 Feb 2015 18:15:53 +0000
Message-ID: <20150223181553.GE25477@ubuntumail>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org>
 <alpine.DEB.2.11.1502230856400.21238@gentwo.org>
 <20150223161625.GD25477@ubuntumail>
 <alpine.DEB.2.11.1502231041580.21784@gentwo.org>
 <20150223164623.GB32181@mail.hallyn.com>
 <alpine.DEB.2.11.1502231049110.21926@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1502231049110.21926@gentwo.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

Quoting Christoph Lameter (cl@linux.com):
> On Mon, 23 Feb 2015, Serge E. Hallyn wrote:
> 
> > > I do not see a problem with dropping privilege since the ambient set
> > > is supposed to be preserved across a drop of priviledge.
> >
> > Because you're tricking the program into thinking it has dropped
> > the privilege, when in fact it has not.
> 
> So the cap was dropped from the cap perm set but it is still active
> in the ambient set?

Right, and the legacy program doesn't know to check the new set.
