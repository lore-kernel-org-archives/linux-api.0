From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Mon, 9 Mar 2015 09:36:53 -0500
Message-ID: <20150309143653.GA29594@mail.hallyn.com>
References: <alpine.DEB.2.11.1503050917380.31001@gentwo.org>
 <20150305171326.GA14998@mail.hallyn.com>
 <alpine.DEB.2.11.1503060948460.8207@gentwo.org>
 <20150306163443.GA28386@mail.hallyn.com>
 <alpine.DEB.2.11.1503061244130.9804@gentwo.org>
 <CALCETrVQF22rkZFD8VAW_xrVQOjwpej6W4TJS9gbN9B431TEKg@mail.gmail.com>
 <20150306200838.GA29198@mail.hallyn.com>
 <alpine.DEB.2.11.1503070907330.15173@gentwo.org>
 <20150307213554.GB9833@mail.hallyn.com>
 <alpine.DEB.2.11.1503090704230.25725@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1503090704230.25725@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Serge Hallyn <serge.hallyn@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Aaron Jones <aaronmdjones@gmail.com>, LSM List <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 09, 2015 at 07:05:24AM -0500, Christoph Lameter wrote:
> On Sat, 7 Mar 2015, Serge E. Hallyn wrote:
> 
> > > The ancestor here is ambient_test and when it is run pI will not be set
> > > despite the cap setting.
> >
> > ambient_test is supposed to set it.
> 
> I thought the setcap +i would do it.
> 
> So the setcap and setting of the file inheritance bits has no effect on
> pI? When the process starts pI is off despite fI being set?

Correct, pI must be set through capset().  Again, x in fI is saying
that the certain trusted users may have x in pP when they run the
binary;  x in pi means that the users may have x in pP when they run
certain files.  Other users running the file won't have x in pP, and
the special user running other files won't have x in pP.
