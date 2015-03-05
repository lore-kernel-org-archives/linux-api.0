From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Thu, 5 Mar 2015 12:41:36 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1503051235300.32373@gentwo.org>
References: <alpine.DEB.2.11.1502261612370.8994@gentwo.org> <20150301233359.GA22196@mail.hallyn.com> <alpine.DEB.2.11.1503050917380.31001@gentwo.org> <20150305171326.GA14998@mail.hallyn.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150305171326.GA14998@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Jonathan Corbet <corbet@lwn.net>, Aaron Jones <aaronmdjones@gmail.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, 5 Mar 2015, Serge E. Hallyn wrote:

> > >
> > > So I'd say drop this change ^
> >
> > Then the ambient caps get ignored for a executables that have capabilities
> > seton the file?
>
> Yes.  Those are assumed to already know what they're doing.

Do they? What if there is a LD_PRELOAD library that redirects socket calls
and that needs raw device access (there are actually a number of software
packages like that to reduce the latency of network I/O. See for example
Solarflare's software products and the current rsocket libary in OFED.
There are cap issues if the rsocket library should be made useful for
Ethernet instead of infiniband).

> Why?  Do you foresee cases where a file that has fP set needs capabilities
> that aren't in its fP?

Yes due to the library issues.

> It seems more likely that they'll risk misbehaving due to an unexpected set
> of caps.

The userspace driver code in the library wont work since it does not have
the caps to access the raw device registers.
