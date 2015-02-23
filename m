From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Mon, 23 Feb 2015 10:50:39 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1502231049110.21926@gentwo.org>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org> <alpine.DEB.2.11.1502230856400.21238@gentwo.org> <20150223161625.GD25477@ubuntumail> <alpine.DEB.2.11.1502231041580.21784@gentwo.org> <20150223164623.GB32181@mail.hallyn.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20150223164623.GB32181@mail.hallyn.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mon, 23 Feb 2015, Serge E. Hallyn wrote:

> > I do not see a problem with dropping privilege since the ambient set
> > is supposed to be preserved across a drop of priviledge.
>
> Because you're tricking the program into thinking it has dropped
> the privilege, when in fact it has not.

So the cap was dropped from the cap perm set but it is still active
in the ambient set?
