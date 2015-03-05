From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Thu, 5 Mar 2015 15:07:26 -0800
Message-ID: <CALCETrUVrfPBpb69WFyptzFoJ8Sx4LwhhjirVx=KQ11ofCcwYg@mail.gmail.com>
References: <alpine.DEB.2.11.1502261612370.8994@gentwo.org>
 <20150301233359.GA22196@mail.hallyn.com> <alpine.DEB.2.11.1503050917380.31001@gentwo.org>
 <20150305171326.GA14998@mail.hallyn.com> <alpine.DEB.2.11.1503051235300.32373@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1503051235300.32373@gentwo.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Andrew Morton <akpm@linuxfoundation.org>, LSM List <linux-security-module@vger.kernel.org>, "Andrew G. Morgan" <morgan@kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, "Serge E. Hallyn" <serge@hallyn.com>, Markku Savela <msa@moth.iki.fi>, Linux API <linux-api@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mar 5, 2015 10:41 AM, "Christoph Lameter" <cl@linux.com> wrote:
>
> On Thu, 5 Mar 2015, Serge E. Hallyn wrote:
>
> > > >
> > > > So I'd say drop this change ^
> > >
> > > Then the ambient caps get ignored for a executables that have capabilities
> > > seton the file?
> >
> > Yes.  Those are assumed to already know what they're doing.
>
> Do they? What if there is a LD_PRELOAD library that redirects socket calls
> and that needs raw device access (there are actually a number of software
> packages like that to reduce the latency of network I/O. See for example
> Solarflare's software products and the current rsocket libary in OFED.
> There are cap issues if the rsocket library should be made useful for
> Ethernet instead of infiniband).
>
> > Why?  Do you foresee cases where a file that has fP set needs capabilities
> > that aren't in its fP?
>
> Yes due to the library issues.

You can't LD_PRELOAD and fP together.  And I'm still unconvinced that
ambient caps can ever be safe in conjunction with fP.  I'll grill you
next week on what you're trying to do that makes you want this :)

--Andy

>
> > It seems more likely that they'll risk misbehaving due to an unexpected set
> > of caps.
>
> The userspace driver code in the library wont work since it does not have
> the caps to access the raw device registers.
