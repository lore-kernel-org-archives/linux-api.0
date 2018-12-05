From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: pkeys: Reserve PKEY_DISABLE_READ
Date: Wed, 5 Dec 2018 12:23:32 -0800
Message-ID: <20181205202332.GE11930@ram.oc3035372033.ibm.com>
References: <20181109180947.GF5481@ram.oc3035372033.ibm.com>
 <87efbqqze4.fsf@oldenburg.str.redhat.com>
 <20181127102350.GA5795@ram.oc3035372033.ibm.com>
 <87zhtuhgx0.fsf@oldenburg.str.redhat.com>
 <58e263a6-9a93-46d6-c5f9-59973064d55e@intel.com>
 <87va4g5d3o.fsf@oldenburg.str.redhat.com>
 <20181203040249.GA11930@ram.oc3035372033.ibm.com>
 <87pnuibobh.fsf@oldenburg.str.redhat.com>
 <20181204062318.GC11930@ram.oc3035372033.ibm.com>
 <87zhtki0vo.fsf@oldenburg2.str.redhat.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <87zhtki0vo.fsf@oldenburg2.str.redhat.com>
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
To: Florian Weimer <fweimer@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 05, 2018 at 02:00:59PM +0100, Florian Weimer wrote:
> * Ram Pai:
> 
> > Ok. here is a patch, compiled but not tested. See if this meets the
> > specifications.
> >
> > -----------------------------------------------------------------------------------
> >
> > commit 3dc06e73f3795921265d5d1d935e428deab01616
> > Author: Ram Pai <linuxram@us.ibm.com>
> > Date:   Tue Dec 4 00:04:11 2018 -0500
> >
> >     pkeys: add support of PKEY_DISABLE_READ
> 
> Thanks.  In the x86 code, the translation of PKEY_DISABLE_READ |
> PKEY_DISABLE_WRITE to PKEY_DISABLE_ACCESS appears to be missing.  I
> believe the existing code produces PKEY_DISABLE_WRITE, which is wrong.

ah. yes. good point.

> 
> Rest looks okay to me (again not tested).

thanks,
RP
