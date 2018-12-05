From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: pkeys: Reserve PKEY_DISABLE_READ
Date: Wed, 5 Dec 2018 12:36:17 -0800
Message-ID: <20181205203617.GF11930@ram.oc3035372033.ibm.com>
References: <20181108201231.GE5481@ram.oc3035372033.ibm.com>
 <87bm6z71yw.fsf@oldenburg.str.redhat.com>
 <20181109180947.GF5481@ram.oc3035372033.ibm.com>
 <87efbqqze4.fsf@oldenburg.str.redhat.com>
 <20181127102350.GA5795@ram.oc3035372033.ibm.com>
 <87zhtuhgx0.fsf@oldenburg.str.redhat.com>
 <58e263a6-9a93-46d6-c5f9-59973064d55e@intel.com>
 <87va4g5d3o.fsf@oldenburg.str.redhat.com>
 <20181203040249.GA11930@ram.oc3035372033.ibm.com>
 <CALCETrXeSQ8T9nvK7WpgPpkraLfg70FoDWvPZeLS3KiDaqXwtw@mail.gmail.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CALCETrXeSQ8T9nvK7WpgPpkraLfg70FoDWvPZeLS3KiDaqXwtw@mail.gmail.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: Florian Weimer <fweimer@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Linux API <linux-api@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Linux-MM <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 05, 2018 at 08:21:02AM -0800, Andy Lutomirski wrote:
> > On Dec 2, 2018, at 8:02 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> >
> >> On Thu, Nov 29, 2018 at 12:37:15PM +0100, Florian Weimer wrote:
> >> * Dave Hansen:
> >>
> >>>> On 11/27/18 3:57 AM, Florian Weimer wrote:
> >>>> I would have expected something that translates PKEY_DISABLE_WRITE |
> >>>> PKEY_DISABLE_READ into PKEY_DISABLE_ACCESS, and also accepts
> >>>> PKEY_DISABLE_ACCESS | PKEY_DISABLE_READ, for consistency with POWER.
> >>>>
> >>>> (My understanding is that PKEY_DISABLE_ACCESS does not disable all
> >>>> access, but produces execute-only memory.)
> >>>
> >>> Correct, it disables all data access, but not execution.
> >>
> >> So I would expect something like this (completely untested, I did not
> >> even compile this):
> >
> >
> > Ok. I re-read through the entire email thread to understand the problem and
> > the proposed solution. Let me summarize it below. Lets see if we are on the same
> > plate.
> >
> > So the problem is as follows:
> >
> > Currently the kernel supports  'disable-write'  and 'disable-access'.
> >
> > On x86, cpu supports 'disable-write' and 'disable-access'. This
> > matches with what the kernel supports. All good.
> >
> > However on power, cpu supports 'disable-read' too. Since userspace can
> > program the cpu directly, userspace has the ability to set
> > 'disable-read' too.  This can lead to inconsistency between the kernel
> > and the userspace.
> >
> > We want the kernel to match userspace on all architectures.
> >
> > Proposed Solution:
> >
> > Enhance the kernel to understand 'disable-read', and facilitate architectures
> > that understand 'disable-read' to allow it.
> >
> > Also explicitly define the semantics of disable-access  as
> > 'disable-read and disable-write'
> >
> > Did I get this right?  Assuming I did, the implementation has to do
> > the following --
> >
> >    On power, sys_pkey_alloc() should succeed if the init_val
> >    is PKEY_DISABLE_READ, PKEY_DISABLE_WRITE, PKEY_DISABLE_ACCESS
> >    or any combination of the three.
> >
> >    On x86, sys_pkey_alloc() should succeed if the init_val is
> >    PKEY_DISABLE_WRITE or PKEY_DISABLE_ACCESS or PKEY_DISABLE_READ
> >    or any combination of the three, except  PKEY_DISABLE_READ
> >          specified all by itself.
> >
> >    On all other arches, none of the flags are supported.
> 
> I don’t really love having a situation where you can use different
> flag combinations to refer to the same mode.

true. But it is a side-effect of x86 cpu implicitly defining
'disable-access' as a combination of 'disable-read' and 'disable_write'.
In other words, if you disable-access on a pte on x86, you are
automatically disabling read and disabling write on that page.
The software/kernel just happens to explicitly capture that implicit
behavior.

> 
> Also, we should document the effect these flags have on execute permission.

Actually none of the above flags, interact with execute permission. They
operate independently; both on x86 and on POWER.  But yes, this
statement needs to be documented somewhere.

RP
