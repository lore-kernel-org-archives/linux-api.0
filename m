From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Sat, 7 Mar 2015 15:35:22 -0600
Message-ID: <20150307213522.GA9833@mail.hallyn.com>
References: <alpine.DEB.2.11.1502261612370.8994@gentwo.org>
 <20150301233359.GA22196@mail.hallyn.com>
 <alpine.DEB.2.11.1503050917380.31001@gentwo.org>
 <20150305171326.GA14998@mail.hallyn.com>
 <alpine.DEB.2.11.1503060948460.8207@gentwo.org>
 <20150306163443.GA28386@mail.hallyn.com>
 <alpine.DEB.2.11.1503061244130.9804@gentwo.org>
 <CALCETrVQF22rkZFD8VAW_xrVQOjwpej6W4TJS9gbN9B431TEKg@mail.gmail.com>
 <alpine.DEB.2.11.1503070906130.15173@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1503070906130.15173@gentwo.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Aaron Jones <aaronmdjones@gmail.com>, LSM List <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 07, 2015 at 09:06:46AM -0600, Christoph Lameter wrote:
> On Fri, 6 Mar 2015, Andy Lutomirski wrote:
> 
> > > christoph@fujitsu-haswell:~$ getcap ambient_test
> > >
> > > ambient_test = cap_setpcap,cap_net_admin,cap_net_raw,cap_sys_nice+eip
> >
> > I think that's right.  fI doesn't set pI.
> 
> Ok then that is the point of pI if it cannot be set?

It can be set!  Anything with CAP_SETPCAP can fill it's pI.  When
it and its children exec(), pI' = pI.
