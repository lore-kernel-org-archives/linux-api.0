From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Fri, 6 Mar 2015 14:08:38 -0600
Message-ID: <20150306200838.GA29198@mail.hallyn.com>
References: <alpine.DEB.2.11.1502261612370.8994@gentwo.org>
 <20150301233359.GA22196@mail.hallyn.com>
 <alpine.DEB.2.11.1503050917380.31001@gentwo.org>
 <20150305171326.GA14998@mail.hallyn.com>
 <alpine.DEB.2.11.1503060948460.8207@gentwo.org>
 <20150306163443.GA28386@mail.hallyn.com>
 <alpine.DEB.2.11.1503061244130.9804@gentwo.org>
 <CALCETrVQF22rkZFD8VAW_xrVQOjwpej6W4TJS9gbN9B431TEKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVQF22rkZFD8VAW_xrVQOjwpej6W4TJS9gbN9B431TEKg@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christoph Lameter <cl@linux.com>, "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Aaron Jones <aaronmdjones@gmail.com>, LSM List <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 06, 2015 at 11:02:43AM -0800, Andy Lutomirski wrote:
> On Fri, Mar 6, 2015 at 10:53 AM, Christoph Lameter <cl@linux.com> wrote:
> > On Fri, 6 Mar 2015, Serge E. Hallyn wrote:
> >
> >> Sorry, something about that patch-patch didn't make sense to me, but I
> >> need to look more closely.  My objection was that you were able to get the
> >> pA capabilities into pP without them being in your pI.  Your proposed
> >> change didn't seem like it would fix that.
> >
> > Just tried to fix that. Could it be that cap_inherited is never set even
> > for a binary that has
> >
> > christoph@fujitsu-haswell:~$ getcap ambient_test
> >
> > ambient_test = cap_setpcap,cap_net_admin,cap_net_raw,cap_sys_nice+eip
> 
> I think that's right.  fI doesn't set pI.

Right.  The idea is that for the running binary to get capability x in its
pP, its privileged ancestor must have set x in pI, and the binary itself
must be trusted with x in fI.

What we are doing is allowing bypassing fI using pA, without bypassing the
requirement for x to be in pI.  Since pI is intended to be filled (for 
instance) at login based on username/group, pI generally does not get cleared.
At the same time, any software which thinks it is running untrusted code
safely without privilege by clearing pI and pP won't be fooled by pA.

-serge
