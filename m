From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] pkeys: Introduce PKEY_ALLOC_SIGNALINHERIT and change
 signal semantics
Date: Wed, 16 May 2018 13:52:44 -0700
Message-ID: <20180516205244.GB5479@ram.oc3035372033.ibm.com>
References: <CALCETrVrm6yGiv6_z7RqdeB-324RoeMmjpf1EHsrGOh+iKb7+A@mail.gmail.com>
 <b2df1386-9df9-2db8-0a25-51bf5ff63592@redhat.com>
 <CALCETrW_Dt-HoG4keFJd8DSD=tvyR+bBCFrBDYdym4GQbfng4A@mail.gmail.com>
 <20180503021058.GA5670@ram.oc3035372033.ibm.com>
 <CALCETrXRQF08exQVZqtTLOKbC8Ywq5x4EYH_1D7r5v9bdOSwbg@mail.gmail.com>
 <927c8325-4c98-d7af-b921-6aafcf8fe992@redhat.com>
 <CALCETrX46wR_MDW=m9SVm=ejQmPAmD3+2oC3iapf75bPhnEAWQ@mail.gmail.com>
 <314e1a48-db94-9b37-8793-a95a2082c9e2@redhat.com>
 <CALCETrUGjN8mhOaLqGcau-pPKm9TQW8k05hZrh52prRNdC5yQQ@mail.gmail.com>
 <008010c1-20a1-c307-25ac-8a69d672d031@redhat.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <008010c1-20a1-c307-25ac-8a69d672d031@redhat.com>
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
Cc: linux-arch <linux-arch@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, Dave Hansen <dave.hansen@intel.com>, linux-x86_64@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 14, 2018 at 02:01:23PM +0200, Florian Weimer wrote:
> On 05/09/2018 04:41 PM, Andy Lutomirski wrote:
> >Hmm.  I can get on board with the idea that fork() / clone() /
> >pthread_create() are all just special cases of the idea that the thread
> >that*calls*  them should have the right pkey values, and the latter is
> >already busted given our inability to asynchronously propagate the new mode
> >in pkey_alloc().  So let's so PKEY_ALLOC_SETSIGNAL as a starting point.
> 
> Ram, any suggestions for implementing this on POWER?

I suspect the changes will go in 
restore_user_regs() and save_user_regs().  These are the functions
that save and restore register state before entry and exit into/from
a signal handler.

> 
> >One thing we could do, though: the current initual state on process
> >creation is all access blocked on all keys.  We could change it so that
> >half the keys are fully blocked and half are read-only.  Then we could add
> >a PKEY_ALLOC_STRICT or similar that allocates a key with the correct
> >initial state*and*  does the setsignal thing.  If there are no keys left
> >with the correct initial state, then it fails.
> 
> The initial PKRU value can currently be configured by the system
> administrator.  I fear this approach has too many moving parts to be
> viable.

Sounds like on x86  keys can go active in signal-handler 
without any explicit allocation request by the application.  This is not
the case on power. Is that API requirement? Hope not.

RP
