From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: pkeys: Support setting access rights for signal handlers
Date: Wed, 13 Dec 2017 16:17:56 -0800
Message-ID: <20171214001756.GA5471@ram.oc3035372033.ibm.com>
References: <5fee976a-42d4-d469-7058-b78ad8897219@redhat.com>
 <c034f693-95d1-65b8-2031-b969c2771fed@intel.com>
 <5965d682-61b2-d7da-c4d7-c223aa396fab@redhat.com>
 <aa4d127f-0315-3ac9-3fdf-1f0a89cf60b8@intel.com>
 <20171212231324.GE5460@ram.oc3035372033.ibm.com>
 <9dc13a32-b1a6-8462-7e19-cfcf9e2c151e@redhat.com>
 <20171213113544.GG5460@ram.oc3035372033.ibm.com>
 <9f86d79e-165a-1b8e-32dd-7e4e8579da59@redhat.com>
 <c220f36f-c04a-50ae-3fd7-2c6245e27057@intel.com>
 <93153ac4-70f0-9d17-37f1-97b80e468922@redhat.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <93153ac4-70f0-9d17-37f1-97b80e468922@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-mm <linux-mm@kvack.org>, x86@kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-x86_64@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 13, 2017 at 04:40:11PM +0100, Florian Weimer wrote:
> On 12/13/2017 04:22 PM, Dave Hansen wrote:
> >On 12/13/2017 07:08 AM, Florian Weimer wrote:
> >>Okay, this model is really quite different from x86.  Is there a
> >>good reason for the difference?
> >
> >Yes, both implementations are simple and take the "natural" behavior.
> >x86 changes XSAVE-controlled register values on entering a signal, so we
> >let them be changed (including PKRU).  POWER hardware does not do this
> >to its PKRU-equivalent, so we do not force it to.
> 
> Whuy?  Is there a technical reason not have fully-aligned behavior?
> Can POWER at least implement the original PKEY_ALLOC_SETSIGNAL
> semantics (reset the access rights for certain keys before switching
> to the signal handler) in a reasonably efficient manner?

This can be done on POWER. I can also change the behavior on POWER
to exactly match x86; i.e reset the value to init value before
calling the signal handler.

But I think, we should clearly define the default behavior, the behavior
when no flag is specified. Applications tend to rely on default behavior
and expect the most intuitive behavior to be the default behavior.

I tend to think; keeping my biases aside, that the most intuitive
behavior is to preserve access/write permissions of any key, i.e not
reset to the init value.  If the application has set the permissions of
a key to some value, it would'nt expect anyone to change them,
irrespective of which context it is in.

RP
